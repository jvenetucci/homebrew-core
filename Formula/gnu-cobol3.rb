class GnuCobol3 < Formula
  desc "Version 3.1-rc1 of gnu-cobol"
  homepage "https://sourceforge.net/projects/gnucobol/"
  url "https://sourceforge.net/projects/gnucobol/files/gnucobol/3.1/gnucobol-3.1-rc1.tar.xz"
  sha256 "c2e41c2ba520681a67c570d7246d25c31f7f55c8a145aaec3f6273a500a93a76"

=begin
  bottle do
    rebuild 1
    sha256 "5f7a515f0ee41a8c841fb06e4cf1b662d52eaff20145d894ac4cb851cbae1bd3" => :catalina
    sha256 "62df1877f13b109a5ab0c775d1419fb687a6c47356333190367ab356165524f3" => :mojave
    sha256 "257ab86b68ebb00c5e29ae347cd71f041644a779ab0c1dcf6146509546603a46" => :high_sierra
  end
=end

  depends_on "berkeley-db"
  depends_on "gmp"

  def install
    # both environment variables are needed to be set
    # the cobol compiler takes these variables for calling cc during its run
    # if the paths to gmp and bdb are not provided, the run of cobc fails
    gmp = Formula["gmp"]
    bdb = Formula["berkeley-db"]
    ENV.append "CPPFLAGS", "-I#{gmp.opt_include} -I#{bdb.opt_include}"
    ENV.append "LDFLAGS", "-L#{gmp.opt_lib} -L#{bdb.opt_lib}"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-libiconv-prefix=/usr",
                          "--with-libintl-prefix=/usr"
    system "make", "install"
  end

  test do
    (testpath/"hello.cob").write <<~EOS
            * COBOL must be indented
      000001 IDENTIFICATION DIVISION.
      000002 PROGRAM-ID. hello.
      000003 PROCEDURE DIVISION.
      000004 DISPLAY "Hello World!".
      000005 STOP RUN.
    EOS
    system "#{bin}/cobc", "-x", "hello.cob"
    system "./hello"
  end
end
