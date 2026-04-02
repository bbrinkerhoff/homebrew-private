cask "temurin-jdk11" do
  version "11.0.30_7"

  on_arm do
    url "https://github.com/adoptium/temurin11-binaries/releases/latest/download/OpenJDK11U-jdk_aarch64_mac_hotspot_#{version}.pkg"
    sha256 "ed352d5851b89872399b15ab309f2367b56a71d70fbc75a34f29b77e2c4e7107"
  end

  on_intel do
    url "https://github.com/adoptium/temurin11-binaries/releases/latest/download/OpenJDK11U-jdk_x64_mac_hotspot_#{version}.pkg"
    sha256 "0b666462bb8f582f73c724a1cb45ab44f454a7bba02e7ab883fa8c44f075b8f8"
  end

  name "Eclipse Temurin JDK 11"
  desc "OpenJDK 11 distribution from the Eclipse Foundation (Adoptium)"
  homepage "https://adoptium.net/"

  livecheck do
    url "https://api.adoptium.net/v3/assets/latest/11/hotspot?os=mac&image_type=jdk"
    strategy :json do |json|
      json.map { |item| item.dig("version", "semver")&.tr("+", "_") }
    end
  end

  pkg "OpenJDK11U-jdk_#{Hardware::CPU.arm? ? "aarch64" : "x64"}_mac_hotspot_#{version}.pkg"

  uninstall pkgutil: "net.adoptium.11.jdk",
            delete:  "/Library/Java/JavaVirtualMachines/temurin-11.jdk"

  zap delete: "/Library/Java/JavaVirtualMachines/temurin-11.jdk"
end
