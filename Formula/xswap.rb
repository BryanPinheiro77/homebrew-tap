class Xswap < Formula
  desc "Account switcher and quota monitor for Codex CLI"
  homepage "https://github.com/BryanPinheiro77/xswap"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.6.1/xswap_v0.6.1_darwin_arm64.tar.gz"
      sha256 "747aa8591c5eb7996355b71eff88f45f3700f7a159a3fc2592cb8b4a6d3b3f02"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.6.1/xswap_v0.6.1_darwin_amd64.tar.gz"
      sha256 "9deb1962d0bfe203e96c22fdd0b7577b5763d54e33a151860f8d739b23cef93f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.6.1/xswap_v0.6.1_linux_arm64.tar.gz"
      sha256 "f1e817e50f98833ac2687eeb8ca79ab72a0611b3a492de8ba30aa19d4496fe24"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.6.1/xswap_v0.6.1_linux_amd64.tar.gz"
      sha256 "479266c6609da717571ff47cb120702e992a378beb90c80e08b0de368840b52f"
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
