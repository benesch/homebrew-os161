class Sys161 < Formula
  homepage "http://www.eecs.harvard.edu/~dholland/os161/#sys161"
  url "http://www.eecs.harvard.edu/~dholland/os161/download/sys161-2.0.2.tar.gz"
  sha256 "8bcf4cd4749e2b634f22506c347f617754e42acf69d1d58f9f7230d7b89f046d"

  bottle do
    root_url "http://dl.bintray.com/benesch/homebrew-os161"
    cellar :any
    sha256 "a0e504a105299d371ce4deeb9f5fce8f79c9a9bd6fc0c2f42bb6cbb7a68d4bcd" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}", "mipseb"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sys161"
  end
end
