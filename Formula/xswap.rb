class Xswap < Formula
  desc "Account switcher and quota monitor for Codex CLI"
  homepage "https://github.com/BryanPinheiro77/xswap"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.9.0/xswap_v0.9.0_darwin_arm64.tar.gz"
      sha256 "b8b77a82845b0951694370d4099add7a64facb24e846f9bbc19b8fd1d317aafa"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.9.0/xswap_v0.9.0_darwin_amd64.tar.gz"
      sha256 "68f522c3e887eb1c53f1c309a48912b8ae96847a4e1835b3d1cf535bd5545461"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.9.0/xswap_v0.9.0_linux_arm64.tar.gz"
      sha256 "ba818b0d369f9a08dc4d1fb251d71b31d165a97e3733dfc13bed00eb7dc877c7"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.9.0/xswap_v0.9.0_linux_amd64.tar.gz"
      sha256 "6546ce6f3be3623e26ae3097a6c60d37e180723db0b984b47a004fee5a45396d"
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
      Open a new terminal after installation so the durable wrapper takes precedence.
      XSwap installed by Homebrew is updated with `brew upgrade xswap`.
      Before removing the formula, run `xswap uninstall` to remove the wrapper.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xswap version")
    assert_match "Managed by: Homebrew", shell_output("#{bin}/xswap version")
  end
end
