require 'bundler/setup'

require 'aws-sdk'
require 'digest/sha2'
require 'json'
require 'open-uri'
require 'rack/auth/travis_webhook'
require 'sinatra'

BUCKET = ENV['S3_BUCKET']

$s3 = Aws::S3::Resource.new

class CommandFailedError < StandardError
end

class BadRequestError < StandardError
  def http_status
    400
  end
end

class Build
  def initialize(payload)
    @payload = JSON.parse(payload)
  rescue
    raise BadRequestError
  end

  def on_master?
    @payload['type'] == 'push' && @payload['branch'] == 'master'
  end

  def successful?
    @payload['status'] == 0
  end

  def repo_slug
    owner = @payload['repository']['owner_name']
    name = @payload['repository']['name']
    "#{owner}/#{name}"
  end

  def artifact_prefix
    number = @payload['number']
    "#{repo_slug}/#{number}/#{number}."
  end
end

class Bottle
  def initialize(object_summary)
    @key = object_summary.key
    @json = JSON.parse(object_summary.get.body.read)
    attach_root_url
  end

  def write!
    $s3.bucket(BUCKET).object(File.join(dirname, tarball)).copy_to(
      bucket: BUCKET, key: tarball)
    File.write(basename, JSON.dump(@json))
  end

  private

  def dirname
    File.dirname(@key)
  end

  def basename
    File.basename(@key)
  end

  def tarball
    @json.first[1]['bottle']['tags'].first[1]['filename']
  end

  def attach_root_url
    @json.each do |_, bottle_data|
      bottle_data['bottle']['root_url'] = "https://s3.amazonaws.com/#{BUCKET}"
    end
  end
end

helpers do
  def run(command)
    logger.info("Running command: #{command}")
    system(command) || (raise CommandFailedError)
  end
end

post('/') do
  logger.info("Received request: #{params}")
  build = Build.new(params[:payload])
  unless build.successful? && build.on_master?
    logger.info("Skipping request; build not on master or unsuccessful")
    halt(403)
  end
  bottles = $s3.bucket(BUCKET)
               .objects(prefix: build.artifact_prefix)
               .select { |os| os.key =~ /\.bottle(.*)?\.json/ }
               .each { |os| logger.info("Found #{os.key}") }
               .map { |os| Bottle.new(os) }
  if bottles.empty?
    logger.info("No bottles found; aborting")
    halt(200)
  end
  run("brew tap #{build.repo_slug}")
  Dir.chdir(`brew --repository #{build.repo_slug}`.chomp) do
    run("git fetch")
    run("git reset --hard origin/master")
    run("git clean -fdX")
    Dir.mktmpdir do |dir|
      bottles.each { |b| b.write! }
      run("brew bottle --merge --write *.json")
    end
    run("git push")
  end
  200
end

# Git will generate bogus commits unless we set these.
%w(GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL)
  .each do |var|
    abort("missing #{var} environment variable") if !ENV[var] || ENV[var].empty?
  end

# Install Homebrew, if it's not already installed. We use Linuxbrew,
# because using Homebrew directly on Heroku isn't possible. This is
# unfortunate, because Linuxbrew makes some annoying Linux-specific
# changes we have to remove. See patches below.
if !system('brew --version')
  system('git clone https://github.com/linuxbrew/brew')
  IO.popen('patch -p1 --directory=brew', 'w') do |patch|
    patch.write(<<'EOS')
--- a/Library/Homebrew/dev-cmd/bottle.rb
+++ b/Library/Homebrew/dev-cmd/bottle.rb
@@ -465,7 +465,7 @@ module Homebrew
 
           path.parent.cd do
             safe_system "git", "commit", "--no-edit", "--verbose",
-              "--message=#{short_name}: #{update_or_add} #{pkg_version} bottle#{" for Linuxbrew" if OS.linux?}.",
+              "--message=#{short_name}: #{update_or_add} #{pkg_version} bottle.",
               "--", path
           end
         end
--- a/Library/Homebrew/software_spec.rb
+++ b/Library/Homebrew/software_spec.rb
@@ -288,9 +288,7 @@ class Bottle
 end
 
 class BottleSpecification
-  DEFAULT_PREFIX_MAC = "/usr/local".freeze
-  DEFAULT_PREFIX_LINUX = "/home/linuxbrew/.linuxbrew".freeze
-  DEFAULT_PREFIX = (OS.linux? ? DEFAULT_PREFIX_LINUX : DEFAULT_PREFIX_MAC).freeze
+  DEFAULT_PREFIX = "/usr/local".freeze
   DEFAULT_CELLAR = "#{DEFAULT_PREFIX}/Cellar".freeze
   DEFAULT_DOMAIN_LINUX = "https://linuxbrew.bintray.com".freeze
   DEFAULT_DOMAIN_MAC = "https://homebrew.bintray.com".freeze

EOS
  end
end

# Install SSH key from environment if necessary.
ssh_key = Pathname.new('~/.ssh/id_rsa').expand_path
if !ssh_key.exist?
  ssh_key.parent.mkpath
  ssh_key.write(ENV['SSH_KEY'])

  # Convince Homebrew taps to use the SSH URL so that we have
  # authorization to push. Statically configuring HTTPS credentials is a
  # nightmare.
  system('git config --global url.ssh://git@github.com/.insteadOf https://github.com/')

  # Heroku ships an old version of Git, so we can't use GIT_SSH_COMMAND
  # to disable host-key checking.
  system('ssh-keyscan github.com >> ~/.ssh/known_hosts')
end

use Rack::Auth::TravisWebhook
run Sinatra::Application
