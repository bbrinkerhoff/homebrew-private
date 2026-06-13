cask "sikulix" do
  version "2.0.5"
  sha256 "bf20552913e5ca8ebd42fe3979c80bba025bb41bceb56436b4a998e8fb8181de"

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
