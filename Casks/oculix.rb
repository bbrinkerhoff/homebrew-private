cask "oculix" do
  version "3.0.4"
  sha256 "8d7714f096ebad6828bccf19e2a3c3973a5d661a9a2e216c4e582ce1f6ca7e12"

  url "https://github.com/bbrinkerhoff/homebrew-private/releases/download/oculix-#{version}/OculiX-#{version}.dmg"

  name "OculiX"
  desc "Open-source visual automation IDE using pixel-based image recognition"
  homepage "https://github.com/oculix-org/Oculix"

  depends_on macos: :catalina
  depends_on formula: "openjdk@21"

  app "OculiX.app"

  zap trash: [
    "~/Library/Application Support/OculiX",
    "~/Library/Preferences/org.oculix.ide.plist",
  ]
end
