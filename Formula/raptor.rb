class Raptor < Formula
  desc "RDF parser toolkit"
  homepage "https://librdf.org/raptor/"
  url "https://download.librdf.org/source/raptor2-2.0.15.tar.gz"
  sha256 "ada7f0ba54787b33485d090d3d2680533520cd4426d2f7fb4782dd4a6a1480ed"

  livecheck do
    url :homepage
    regex(/href=.*?raptor2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2970bdade24bb5ec9afe4b79e89234016147cb506f6b450bcfd66c50fce1cede"
    sha256 cellar: :any, big_sur:       "5b58712f0ba9fc647c6b241f80ce3697e25c851f80b26cb8f89f28809905126f"
    sha256 cellar: :any, catalina:      "d0be0655a9546fe278830f8b60a19f66dcc10a77445e2bf2cf76ad61a0a802e2"
    sha256 cellar: :any, mojave:        "cbfcd2b8ce9fa8701a15eba572e766e3a9b3b19eba8438d41618e6ee3ab4501d"
    sha256 cellar: :any, high_sierra:   "194f9a66e1aeccb23185abd6f1f1408422594dfd54cad5460c5a5ac3f5e0c48c"
    sha256 cellar: :any, sierra:        "dba42ee8efa54c0b5722f0e12a7a585c2a9fe07a22aea6aec9124aaf09860f1d"
    sha256 cellar: :any, el_capitan:    "cc2feb9cd1d6f9eb0f511853f19c43bc96d143de6a73edfd3cdb854647d1d14a"
    sha256 cellar: :any, yosemite:      "c23392012fb5edffbe800771eaee6ae81d288e62c477c27332474f2ed342d1b3"
    sha256 cellar: :any, x86_64_linux:  "a04c8786feb2bc0715a9e3b1f1f306311840c1cae53a4251eb0dae25da22065e"
  end

  uses_from_macos "libxml2"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
