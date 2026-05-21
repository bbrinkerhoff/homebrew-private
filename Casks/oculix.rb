cask "oculix" do
  version "3.0.4"
  sha256 "9934621ab41be73ecf08014dc1fb2ca7a66c55fb6c2892723bc240d3984c8adb"

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
