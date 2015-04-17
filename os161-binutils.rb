class Os161Binutils < Formula
  homepage "http://www.eecs.harvard.edu/~dholland/os161/"
  url "http://www.eecs.harvard.edu/~dholland/os161/download/binutils-2.24+os161-2.1.tar.gz"
  version "2.24+os161-2.1.tar.gz"
  sha256 "7c1221ad538ee2d72ce4b6bad996d701b2a8e21977c0fd7c9bb6020c035ce664"

  bottle do
    root_url "http://dl.bintray.com/benesch/homebrew-os161"
    sha256 "c306cd3885e98c725f92e84b7f286d6cb351b00eca64c19ea942e44a69f1bf45" => :yosemite
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--target=mips-harvard-os161"
    system "make"
    system "make", "install"
  end
end
