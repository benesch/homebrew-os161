class Os161Binutils < Formula
  homepage "http://os161.eecs.harvard.edu/"
  url "http://os161.eecs.harvard.edu/download/binutils-2.24+os161-2.1.tar.gz"
  version "2.24+os161-2.1.tar.gz"
  sha256 "7c1221ad538ee2d72ce4b6bad996d701b2a8e21977c0fd7c9bb6020c035ce664"

  bottle do
    root_url "http://dl.bintray.com/benesch/homebrew-os161"
    sha256 "c306cd3885e98c725f92e84b7f286d6cb351b00eca64c19ea942e44a69f1bf45" => :yosemite
    sha256 "311d4052a39271617087fba4a03b044d3e83c435e4c4b2c0be8b4b635cbd967a" => :el_capitan
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
