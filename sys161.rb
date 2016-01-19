class Sys161 < Formula
  homepage "http://os161.eecs.harvard.edu/#sys161"
  url "http://os161.eecs.harvard.edu/download/sys161-2.0.6.tar.gz"
  sha256 "c791f7d4d08597738bd0b1903124fa69b633b17903a18645a20e4ae5005d194c"

  bottle do
    root_url "http://dl.bintray.com/benesch/homebrew-os161"
    cellar :any_skip_relocation
    sha256 "0fa2388d6fb92962a9799f53e7882e6fafcb08c3f2c43d0b41995c866975d659" => :el_capitan
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
