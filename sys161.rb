class Sys161 < Formula
  homepage "http://os161.eecs.harvard.edu/#sys161"
  url "http://os161.eecs.harvard.edu/download/sys161-2.0.7.tar.gz"
  sha256 "fdec52c0d92f46b96bd67a07f47e949c933d4026a8ab9599e35125de324c45b1"
  revision 1

  bottle do
    root_url "http://dl.bintray.com/benesch/homebrew-os161"
    cellar :any_skip_relocation
    sha256 "7dc61a17f794ada22dbede974ed442bcc9853f12c6553b707a109a91d5031d4a" => :el_capitan
  end

  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "mipseb"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sys161"
  end
end
__END__
diff --git a/bus/dev_emufs.c b/bus/dev_emufs.c
index 44b3a2f..9ae11a8 100644
--- a/bus/dev_emufs.c
+++ b/bus/dev_emufs.c
@@ -302,6 +302,7 @@ emufs_open(struct emufs_data *ed, int flags)
 	int curdir;
 	struct stat sbuf, sbuf2;
 	int isdir;
+	int create = 0;
 
 	if (ed->ed_iolen >= EMU_BUF_SIZE) {
 		return EMU_RES_BADSIZE;
@@ -327,6 +328,9 @@ emufs_open(struct emufs_data *ed, int flags)
 		/* creating; ok if it doesn't exist, and it's not a dir */
 		flags |= O_RDWR;
 		isdir = 0;
+		sbuf.st_dev = 0;
+		sbuf.st_ino = 0;
+		create = 1;
 	}
 	else {
 		isdir = S_ISDIR(sbuf.st_mode)!=0;
@@ -370,8 +374,8 @@ emufs_open(struct emufs_data *ed, int flags)
 		 * when we finally get code to prohibit going outside
 		 * the root dir.
 		 */
-		if (sbuf2.st_dev != sbuf.st_dev ||
-		    sbuf2.st_ino != sbuf.st_ino) {
+		if (!create && (sbuf2.st_dev != sbuf.st_dev ||
+				sbuf2.st_ino != sbuf.st_ino)) {
 			close(ed->ed_handles[handle].eh_fd);
 			ed->ed_handles[handle].eh_fd = -1;
 			goto retry;
