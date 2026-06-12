cask "oculix" do
  version "3.0.4"
  sha256 "f48aad72723b9a55029ee36c713ecedc7dc931018aace723d2892c60dc8abcac"

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
