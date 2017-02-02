class Sys161 < Formula
  homepage "http://os161.eecs.harvard.edu/#sys161"
  url "http://os161.eecs.harvard.edu/download/sys161-2.0.8.tar.gz"
  sha256 "5a642090c51da2f0d192bc4520d69aae262223abdcbf9d1d704f21ae6fd91b26"
  revision 3

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "mipseb"
    system "make"
    system "make", "install"
  end
end
