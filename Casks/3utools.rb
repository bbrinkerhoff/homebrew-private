cask "3utools" do
  version "9.02.003"

  on_arm do
    sha256 "5dfc00347c6a05c3059a4761f423c279ef1bfcb48ab4175012b83375a965d11c"

    url "https://dl.3u.com/update/v900/macos/arm64/3uTools_v#{version}_arm64.dmg"
  end

  on_intel do
    sha256 "278bde7fe8d1fb9f4aa1177825b99b56752a3c89e9c999bef35bdc77cf31ff73"

    url "https://dl.3u.com/update/v900/macos/x64/3uTools_v#{version}_x64.dmg"
  end

  name "3uTools"
  desc "Toolbox for managing iOS devices"
  homepage "https://www.3u.com/"

  pkg "3utools.pkg"
end
