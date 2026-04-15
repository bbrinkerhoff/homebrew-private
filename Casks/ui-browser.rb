cask "ui-browser" do
  version "4.0.0"
  sha256 "467f0a13c9d8f9a7dcd3fb598bf97f1f675e3f854838937f7b64b7116ea1e81e"

  url "https://s3.amazonaws.com/latenightsw.com/UIBrowser/UIBrowser#{version}.zip",
      verified: "s3.amazonaws.com/latenightsw.com/UIBrowser/"
  name "UI Browser"
  desc "Accessibility inspector and browser"
  homepage "https://latenightsw.com/support/ui-browser/"

  app "UI Browser.app"

  zap trash: [
    "~/Library/Application Support/UI Browser",
    "~/Library/Preferences/com.pfiddlesoft.UIBrowser4.plist",
  ]
end
