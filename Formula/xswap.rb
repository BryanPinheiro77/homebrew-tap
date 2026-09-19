class Xswap < Formula
  desc "Account switcher and quota monitor for Codex CLI"
  homepage "https://github.com/BryanPinheiro77/xswap"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.0/xswap_v0.5.0_darwin_arm64.tar.gz"
      sha256 "1efe76c3cffe91392fc6f4e8f38444e4d1d6f518dda76d7e92bb857028ad9fca"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.0/xswap_v0.5.0_darwin_amd64.tar.gz"
      sha256 "28681f8aeb360c2cdbc3e121cfe537d54222055c360a683e1f33527cce0a363c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.0/xswap_v0.5.0_linux_arm64.tar.gz"
      sha256 "e45206864eed7847b477f7b4c84114a927fb71ba1a71f079e90ad2a47644e457"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.0/xswap_v0.5.0_linux_amd64.tar.gz"
      sha256 "5abc5fde3a18a5eb4f087abce66b2d65a8e5f326b852895d9cc5dadec851a8e4"
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
