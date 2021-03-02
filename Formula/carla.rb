class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.2.0.tar.gz"
  sha256 "4bf08511257db88979eccc002f10c153ff2a14f5143291c2be39cadd69ce10e1"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/falkTX/Carla.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, big_sur:     "acf32e79adbb82d6cc86b6ce0615e7cdf20378622929d4ee32cc70750b40c192"
    sha256 cellar: :any, catalina:    "8f55c9c9f85709f1d85d219d3d421cee0246b9e5b4a097613a8a8d2b1aba8c9b"
    sha256 cellar: :any, mojave:      "ed7ec50b3e5193111da088c770dc1c4e6609299c9009f18b6b09e7558ac6e03e"
    sha256 cellar: :any, high_sierra: "e4ae5a76855872c3fca8ffda7054abf5ae5acdb56473132a9945ff52f42ff2b1"
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt"
  depends_on "python@3.9"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    inreplace bin/"carla", "PYTHON=$(which python3 2>/dev/null)",
                           "PYTHON=#{Formula["python@3.9"].opt_bin}/python3"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
