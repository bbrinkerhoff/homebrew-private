cask "sikulix" do
  version "2.0.5"
  sha256 "0c56f19121b73d1370fd95cfae536458dcc607afe02ec4d03873d335e928e610"

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
