class Bibclean < Formula
  desc "BibTeX bibliography file pretty printer and syntax checker"
  homepage "https://www.math.utah.edu/~beebe/software/bibclean/bibclean-03.html#HDR.3"
  url "https://ftp.math.utah.edu/pub/bibclean/bibclean-3.04.tar.xz"
  sha256 "4fa68bfd97611b0bb27b44a82df0984b300267583a313669c1217983b859b258"
  license "GPL-2.0"

  livecheck do
    url "https://ftp.math.utah.edu/pub/bibclean/"
    regex(/href=.*?bibclean[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "1ca564c71ae986472ba45f55cee1dc9c2070513a908b5f3931d4cbd82ed1cd45"
    sha256 big_sur:       "4b273f7061767e8e2a4776863f2da581ab726212ee1ae9b4d512a6bc228a6d7a"
    sha256 catalina:      "15dbbabace79aafd93546976d8a899a393c6489d7951ce2bd2bb148a45f262a3"
    sha256 mojave:        "82a7919c9d5054012b54d53eacf5a9c0785105071c4c65c83bc2ff428642b3e5"
    sha256 high_sierra:   "9a2beadc688b6b12a22359890a6a85f20f3c79af561b5d4268e86069b806f585"
    sha256 x86_64_linux:  "ae4136132d9dab8d9728409fa6423969d405eacea6dbfd43d95945cf5a0b7802"
  end

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"

    # The following inline patches have been reported upstream.
    inreplace "Makefile" do |s|
      # Insert `mkdir` statements before `scp` statements because `scp` in macOS
      # requires that the full path to the target already exist.
      s.gsub!(/[$][{]CP.*BIBCLEAN.*bindir.*BIBCLEAN[}]/,
              "mkdir -p ${bindir} && ${CP} ${BIBCLEAN} ${bindir}/${BIBCLEAN}")
      s.gsub!(/[$][{]CP.*bibclean.*mandir.*bibclean.*manext[}]/,
              "mkdir -p ${mandir} && ${CP} bibclean.man ${mandir}/bibclean.${manext}")

      # Correct `mandir` (man file path) in the Makefile.
      s.gsub!(/mandir.*prefix.*man.*man1/, "mandir = ${prefix}/share/man/man1")
    end

    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"test.bib").write <<~EOS
      @article{small,
      author = {Test, T.},
      title = {Test},
      journal = {Test},
      year = 2014,
      note = {test},
      }
    EOS

    system "#{bin}/bibclean", "test.bib"
  end
end
