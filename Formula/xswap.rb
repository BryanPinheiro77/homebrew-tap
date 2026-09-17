class Xswap < Formula
  desc "Account switcher and quota monitor for Codex CLI"
  homepage "https://github.com/BryanPinheiro77/xswap"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.2/xswap_v0.3.2_darwin_arm64.tar.gz"
      sha256 "8a91bec97e04e80e30055760547a875fef5e9f29fab951bb51b62a8eaf47f992"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.2/xswap_v0.3.2_darwin_amd64.tar.gz"
      sha256 "de0f6561113626ecd7cb5792647ec660dc130602d59a9e3008c8865f9288c56f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.2/xswap_v0.3.2_linux_arm64.tar.gz"
      sha256 "ec25e2b56822537d96ef2dc71e880ac58dc07c76d5f46acd70117c159d171980"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.2/xswap_v0.3.2_linux_amd64.tar.gz"
      sha256 "7652592acfd2301e4b8fb08f150e8ec7cb3a17011df78fb42b7d35f05ee659bb"
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
