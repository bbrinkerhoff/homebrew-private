cask "oculix" do
  version "3.0.4"
  sha256 "455054370304c51d0bf67a9c1e0bc2380795a5676e402e2ad5de68af3155926b"

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
