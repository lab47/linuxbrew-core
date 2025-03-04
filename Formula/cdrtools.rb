class Cdrtools < Formula
  desc "CD/DVD/Blu-ray premastering and recording software"
  homepage "https://cdrtools.sourceforge.io/private/cdrecord.html"
  url "https://downloads.sourceforge.net/project/cdrtools/alpha/cdrtools-3.02a09.tar.gz"
  mirror "https://fossies.org/linux/misc/cdrtools-3.02a09.tar.gz"
  sha256 "c7e4f732fb299e9b5d836629dadf5512aa5e6a5624ff438ceb1d056f4dcb07c2"

  livecheck do
    # For 3.0.2a we are temporarily using the "alpha" due to a long wait for release.
    # This can go back to "url :stable" later
    url "https://downloads.sourceforge.net/project/cdrtools/alpha"
    regex(%r{url=.*?/cdrtools[._-]v?(\d+(?:\.\d+)+(a\d\d)?)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "06bd97603df2dba522d6cb18b50815b3cb4f6b619b3244e6d870009831129a37"
    sha256 big_sur:       "dd2f2609309ef54a2b9289ef79032222714f01c86ecb280d8d79ebc520488ae6"
    sha256 catalina:      "411c2dc1a6931d3c7c299d7c9d73129efbf45a39a421518158a3852de554fcaf"
    sha256 mojave:        "4669f544745a05b8ef4ffd9bc1ea446ef7cda4c98f32b26279c81af803f1ab7e"
    sha256 x86_64_linux:  "9f705017f1a6c2e647f37d87f4a9472a83e327505ebed822169e8821e713c958"
  end

  depends_on "smake" => :build

  conflicts_with "dvdrtools",
    because: "both dvdrtools and cdrtools install binaries by the same name"

  def install
    # Speed-up the build by skipping the compilation of the profiled libraries.
    # This could be done by dropping each occurrence of *_p.mk from the definition
    # of MK_FILES in every lib*/Makefile. But it is much easier to just remove all
    # lib*/*_p.mk files. The latter method produces warnings but works fine.
    rm_f Dir["lib*/*_p.mk"]
    # CFLAGS is required to work around autoconf breakages as of 3.02a
    system "smake", "INS_BASE=#{prefix}", "INS_RBASE=#{prefix}",
           "CFLAGS=-Wno-implicit-function-declaration",
           "install"
    # cdrtools tries to install some generic smake headers, libraries and
    # manpages, which conflict with the copies installed by smake itself
    (include/"schily").rmtree
    %w[libschily.a libdeflt.a libfind.a].each do |file|
      (lib/file).unlink
    end
    man5.rmtree
  end

  test do
    system "#{bin}/cdrecord", "-version"
    system "#{bin}/cdda2wav", "-version"
    date = shell_output("date")
    mkdir "subdir" do
      (testpath/"subdir/testfile.txt").write(date)
      system "#{bin}/mkisofs", "-r", "-o", "../test.iso", "."
    end
    assert_predicate testpath/"test.iso", :exist?
    system "#{bin}/isoinfo", "-R", "-i", "test.iso", "-X"
    assert_predicate testpath/"testfile.txt", :exist?
    assert_equal date, File.read("testfile.txt")
  end
end
