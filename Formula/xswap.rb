class Xswap < Formula
  desc "Account switcher and quota monitor for Codex CLI"
  homepage "https://github.com/BryanPinheiro77/xswap"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.0/xswap_v0.3.0_darwin_arm64.tar.gz"
      sha256 "6cebe76a66691b3a82b323b2cf67252e1e67864a942ebb72ac1593605ccd1804"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.0/xswap_v0.3.0_darwin_amd64.tar.gz"
      sha256 "0830bc97db33955aa1fdb73663600e518929880d6cf5c7c06e0a14a0f2f8de3f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.0/xswap_v0.3.0_linux_arm64.tar.gz"
      sha256 "2dd135981e3634094fa24741e667cbcf82b66e2ba842f5b69c3e882fc6e34cea"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.0/xswap_v0.3.0_linux_amd64.tar.gz"
      sha256 "5272bac9650a9308b3ec6a211f7baabd930852ccdf8bf1fc87793e8b9092fcb4"
    end
  end

  def install
    libexec.install "xswap" => "xswap-bin"
    (bin/"xswap").write <<~SH
      #!/bin/sh
      case "$(basename "$0")" in
        codex) set -- __codex "$@" ;;
      esac
      export XSWAP_PACKAGE_MANAGER=homebrew
      export XSWAP_EXECUTABLE="#{HOMEBREW_PREFIX}/opt/xswap/bin/xswap"
      exec "#{libexec}/xswap-bin" "$@"
    SH
    (bin/"xswap").chmod 0755
    bin.install_symlink "xswap" => "codex-swap"
  end

  def caveats
    <<~EOS
      The official Codex CLI must be installed before configuring XSwap.
      Run `xswap install` once to connect XSwap to the official Codex CLI.
      XSwap installed by Homebrew is updated with `brew upgrade xswap`.
      Before removing the formula, run `xswap uninstall` to restore Codex.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xswap version")
    assert_match "Managed by: Homebrew", shell_output("#{bin}/xswap version")
  end
end
