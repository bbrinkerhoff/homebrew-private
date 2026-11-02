cask "oculix" do
  version "4.0.0"
  sha256 "050ca08b65acd1da0e610e4993938a455323375d43ff1209fd6b376e0cbb7b92"

  url "https://github.com/bbrinkerhoff/homebrew-private/releases/download/oculix-#{version}/OculiX-#{version}.dmg"

  name "OculiX"
  desc "Open-source visual automation IDE using pixel-based image recognition"
  homepage "https://github.com/oculix-org/Oculix"

  depends_on formula: "openjdk@21"

  app "OculiX.app"

  zap trash: [
    "~/Library/Application Support/OculiX",
    "~/Library/Preferences/org.oculix.ide.plist",
  ]
end
