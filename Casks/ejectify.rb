cask "ejectify" do
  version "2.0.3"
  sha256 "09b492ceb5b677fd983904ab390bd5d9f127539e67e2ed6f11daf332b9ae2889"

  url "https://github.com/bbrinkerhoff/homebrew-private/releases/download/ejectify-#{version}/Ejectify.zip",
      verified: "github.com/bbrinkerhoff/homebrew-private/"

  name "Ejectify"
  desc "Menu bar app that safely ejects external drives before sleep"
  homepage "https://ejectify.app"

  app "Ejectify.app"

  zap trash: [
    "~/Library/Application Support/Ejectify",
    "~/Library/Preferences/app.ejectify.Ejectify.plist",
  ]
end
