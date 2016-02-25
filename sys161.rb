class Sys161 < Formula
  homepage "http://os161.eecs.harvard.edu/#sys161"
  url "http://os161.eecs.harvard.edu/download/sys161-2.0.7.tar.gz"
  sha256 "fdec52c0d92f46b96bd67a07f47e949c933d4026a8ab9599e35125de324c45b1"

  bottle do
    root_url "http://dl.bintray.com/benesch/homebrew-os161"
    cellar :any_skip_relocation
    sha256 "c62b1147d19d662e63d0a598ec9f70a530240c4f5f12697ce51ebe2724cdd9dc" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "mipseb"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sys161"
  end
end
