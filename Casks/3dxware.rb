# Documentation: https://docs.brew.sh/Cask-Cookbook
#                https://docs.brew.sh/Adding-Software-to-Homebrew#cask-stanzas
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
cask "3dxware" do
  version "10-8-11"
  sha256 "e7f7ff9c22bdda049433d4681e92c9b9ee2828891f83ea8532b670805a1d9356"

  url "https://download.3dconnexion.com/drivers/mac/#{version}_DA8ADF2B/3DxWareMac_v#{version}_r3896.dmg"
  name "3DxWare"
  desc "3D Connextion driver for Spacemouse and Spacemouse Pro"
  homepage "https://3dconnexion.com/"

  # Documentation: https://docs.brew.sh/Brew-Livecheck
  livecheck do
    url "https://3dconnexion.com/us/drivers/"
    regex(/href=.*?3dconnexion\.com\/drivers\/.*?v(\d{1,2}-\d{1,2}-\d{1,2})\w+\.dmg/i)

  end

  depends_on macos: :monterey

  pkg "Install 3Dconnexion software.pkg"
end
