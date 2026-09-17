class Xswap < Formula
  desc "Account switcher and quota monitor for Codex CLI"
  homepage "https://github.com/BryanPinheiro77/xswap"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.1/xswap_v0.3.1_darwin_arm64.tar.gz"
      sha256 "ebae56020e8c1a73ebdf3f2d16728deda05562edcca036dcc51214d1c5535d9f"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.1/xswap_v0.3.1_darwin_amd64.tar.gz"
      sha256 "01e12d02c6da7d00df20bac8e24f3886ee442e203d9aa455d631426661e9182b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.1/xswap_v0.3.1_linux_arm64.tar.gz"
      sha256 "a86e932e21bc3340353c5c925ad889c68c4f498fd71473e1088bfe1643dca9d6"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.1/xswap_v0.3.1_linux_amd64.tar.gz"
      sha256 "565b31884705b3005e76ebad5000105ec01688c3001e96ed50d8eca03e0d0338"
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
