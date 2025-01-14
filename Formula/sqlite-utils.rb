class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/9c/c9/3b3d73898243153dd80aa56c1bf80f5dd700ae65d12c29324ac9db833e03/sqlite-utils-3.9.1.tar.gz"
  sha256 "a08ed62eb269e26ae9c35b9be9cd3d395b0522157e6543128a40cc5302d8aa81"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d3d41fd0bfc7181c540754bf4914fc78c508f32585254212812b1e8c6672ad44"
    sha256 cellar: :any_skip_relocation, big_sur:       "808f09dbc1b73d9b3aed93fec485ade6f49fe2c37d83650e34a73116b033121d"
    sha256 cellar: :any_skip_relocation, catalina:      "808f09dbc1b73d9b3aed93fec485ade6f49fe2c37d83650e34a73116b033121d"
    sha256 cellar: :any_skip_relocation, mojave:        "808f09dbc1b73d9b3aed93fec485ade6f49fe2c37d83650e34a73116b033121d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4803174fa44958321888a5668894331a4cd5e6e2130a54df14951c4590475e4c"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/22/3a/e9feb3435bd4b002d183fcb9ee08fb369a7e570831ab1407bc73f079948f/click-default-group-1.2.2.tar.gz"
    sha256 "d9560e8e8dfa44b3562fbc9425042a0fd6d21956fcc2db0077f63f34253ab904"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/62/30/63e64b7b8fa69aabf97b14cbc204cb9525eb2132545f82231c04a6d40d5c/sqlite-fts4-1.0.1.tar.gz"
    sha256 "b2d4f536a28181dc4ced293b602282dd982cc04f506cf3fc491d18b824c2f613"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "15", shell_output("#{bin}/sqlite-utils :memory: 'select 3 * 5'")
  end
end
