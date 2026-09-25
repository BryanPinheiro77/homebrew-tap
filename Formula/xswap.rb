class Xswap < Formula
  desc "Account switcher and quota monitor for Codex CLI"
  homepage "https://github.com/BryanPinheiro77/xswap"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.5/xswap_v0.5.5_darwin_arm64.tar.gz"
      sha256 "e3b9d835322e85cc03b07e90be82cb5a7f512e0fe7a905143e394ede540d1752"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.5/xswap_v0.5.5_darwin_amd64.tar.gz"
      sha256 "065cfd9c8f4d6c7823f824b78e6fd17cec191906238f8c3e528c877abc6a572b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.5/xswap_v0.5.5_linux_arm64.tar.gz"
      sha256 "816219368c672c406f47fb8b30342217ae475c3c8e978631adbc1b99b0c82b03"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.5/xswap_v0.5.5_linux_amd64.tar.gz"
      sha256 "259e9469bce72145293b8f7e814797f0aab7accb4fc03a28ab637e7ee98a7969"
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
