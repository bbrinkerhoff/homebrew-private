cask "ejectify" do
  version "HEAD-18f51a3"
  sha256 "1b1bff6b7147f8eb1ea44d1ea96c7d929137e2ee439a7f8dd4d93da7c2bea414"

  url "https://github.com/bbrinkerhoff/homebrew-private/releases/download/ejectify-#{version.split("-").last}/Ejectify.zip"
  name "Ejectify"
  desc "Menu bar app that safely ejects external drives before sleep"
  homepage "https://ejectify.app"

  app "Ejectify.app"

  caveats <<~EOS
    Ejectify is built from source and hosted in a private GitHub repository.
    Set HOMEBREW_GITHUB_API_TOKEN to a token with `repo` scope so Homebrew
    can download the release asset:
      export HOMEBREW_GITHUB_API_TOKEN=<your_token>
  EOS

  zap trash: [
    "~/Library/Application Support/Ejectify",
    "~/Library/Preferences/app.ejectify.Ejectify.plist",
  ]
end
