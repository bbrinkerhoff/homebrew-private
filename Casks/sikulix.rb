cask "sikulix" do
  version "2.0.5"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

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
