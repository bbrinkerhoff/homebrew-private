cask "sikulix" do
  version "2.0.5"
  sha256 "6c7d6faf3dce1f49de8b06b53162f37cf0a0053ab11e2a4beed91566367880bf"

  url "https://github.com/bbrinkerhoff/homebrew-private/releases/download/sikulix-#{version}/SikuliX-#{version}.dmg"

  name "SikuliX"
  desc "Visual automation and testing tool using screenshots"
  homepage "https://github.com/oculix-org/SikuliX1"

  depends_on macos: :catalina
  depends_on formula: "openjdk@21"

  app "SikuliX.app"

  zap trash: [
    "~/Library/Application Support/SikuliX",
    "~/Library/Preferences/org.sikuli.ide.plist",
  ]
end
