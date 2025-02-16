class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/13.0.0.tar.gz"
  sha256 "0fb17aaf285b3eee8ddab17b833af1e190d73de317ff9648751ab0660d763ed2"
  license "Unlicense"
  head "https://github.com/BurntSushi/ripgrep.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d3e0ae859dc1e66ebecbc66a8ad1ec2abac59bc707d2305dde66212e71406d36"
    sha256 cellar: :any,                 big_sur:       "a8f2bd6586de9f7aa36eaaefd36777309f9b5d57f01bf33bf022d715fd3dbb89"
    sha256 cellar: :any,                 catalina:      "0edcffa1251002e2747020d62a16ae077bd7aa5fb289d351622e0065c9686c40"
    sha256 cellar: :any,                 mojave:        "b57024c0d221249a1f5eaef1069ac90d44e54afdadb146acd117ae23b7de98c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "773831fdff6a4c5e197e4fbd8c40422274eff3fa65318d93e982c1c2c44417a4"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "pcre2"

  def install
    system "cargo", "install", "--features", "pcre2", *std_cargo_args

    # Completion scripts and manpage are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/ripgrep-*/out"].first
    man1.install "#{out_dir}/rg.1"
    bash_completion.install "#{out_dir}/rg.bash"
    fish_completion.install "#{out_dir}/rg.fish"
    zsh_completion.install "complete/_rg"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/rg", "Hello World!", testpath
  end
end
