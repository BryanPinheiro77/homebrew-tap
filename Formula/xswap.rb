class Xswap < Formula
  desc "Account switcher and quota monitor for Codex CLI"
  homepage "https://github.com/BryanPinheiro77/xswap"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.3/xswap_v0.3.3_darwin_arm64.tar.gz"
      sha256 "f9be7ac782294a8bfcaadecfd7cb0ae8dd18a10917f031b6305679652dd34642"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.3/xswap_v0.3.3_darwin_amd64.tar.gz"
      sha256 "11b61cfb6f4ca2104f3adabed7bd9977b4487afcf0b4ca2e18f16e23fe9de5b8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.3/xswap_v0.3.3_linux_arm64.tar.gz"
      sha256 "7ee6a985c61956dd48e2e8184f525444d5a0e5cb23fcdd246e15b80b5d50974f"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.3/xswap_v0.3.3_linux_amd64.tar.gz"
      sha256 "fae2811a176055546f32899df17c2a977089c7f2c9e7b92fd6abe772b53e8874"
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
