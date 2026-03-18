cask "czkawka-krokiet" do
  version "11.0.1"
  sha256 "04bc51fa769e8373ef6c2425c08cd7016b2cc826ec29e25d3a403bc8a56e8a70"

  url "https://github.com/qarmin/czkawka/releases/download/#{version}/mac_krokiet_arm64"
  name "Czkawka"
  desc "Multi functional app to find duplicates, empty folders, similar images, and more"
  homepage "https://github.com/qarmin/czkawka"

  depends_on arch: :arm64

  binary "mac_krokiet_arm64"
end
