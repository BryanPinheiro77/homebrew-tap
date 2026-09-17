class Xswap < Formula
  desc "Account switcher and quota monitor for Codex CLI"
  homepage "https://github.com/BryanPinheiro77/xswap"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.2/xswap_v0.3.2_darwin_arm64.tar.gz"
      sha256 "9a411e93d7ade899ba189ad1092c6f9a1d540d5ed2b4d0df3c04e36b932d9e2b"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.2/xswap_v0.3.2_darwin_amd64.tar.gz"
      sha256 "45d38906b3e728fb8ed9b4684edcb3d998b6c3f5236f457746642ee69f650c95"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.2/xswap_v0.3.2_linux_arm64.tar.gz"
      sha256 "101d9fb50f3c305ca4efe4d59f37abfc85cef1f99511d6834eb14f6d5db86697"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.2/xswap_v0.3.2_linux_amd64.tar.gz"
      sha256 "2ce7e57186ab61496a1a0962713049d74796903c21d5a07fbe53c05d4dd5b299"
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
