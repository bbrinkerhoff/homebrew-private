cask "czkawka-krokiet" do
  version "11.0.1"

  on_arm do
    sha256 "04bc51fa769e8373ef6c2425c08cd7016b2cc826ec29e25d3a403bc8a56e8a70"
    url "https://github.com/qarmin/czkawka/releases/download/#{version}/mac_krokiet_arm64"
    binary "mac_krokiet_arm64", target: "czkawka_krokiet"
  end

  on_intel do
    sha256 "bbbdf421681a7c7339c19c8bf625c0d676d4160ecc998eae4c9ca8356405219d"
    url "https://github.com/qarmin/czkawka/releases/download/#{version}/mac_krokiet_x86_64"
    binary "mac_krokiet_x86_64", target: "czkawka_krokiet"
  end

  name "Czkawka"
  desc "Multi functional app to find duplicates, empty folders, similar images, and more"
  homepage "https://github.com/qarmin/czkawka"
end
