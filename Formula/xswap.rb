class Xswap < Formula
  desc "Account switcher and quota monitor for Codex CLI"
  homepage "https://github.com/BryanPinheiro77/xswap"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.4.2/xswap_v0.4.2_darwin_arm64.tar.gz"
      sha256 "578c932b1c49c59343092a74086cfa37518dbf276e365785efab6b6a662336f8"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.4.2/xswap_v0.4.2_darwin_amd64.tar.gz"
      sha256 "485d4f12cd0566e2c1db7287a900369c7ae09598f3cd4c44c924151d26a9344f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.4.2/xswap_v0.4.2_linux_arm64.tar.gz"
      sha256 "e74f55876aaeddf4913168e0edc69a65d8919913d71da95d532d6ddc36424c4d"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.4.2/xswap_v0.4.2_linux_amd64.tar.gz"
      sha256 "55ba3d7f117682c7c67a848e15b8a764a0358ba67bbeba65545dbc148fd9ae9d"
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
