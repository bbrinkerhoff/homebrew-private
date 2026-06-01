cask "exstar-hub" do
  version "1.1.2-12"
  sha256 "9f9332b6f8e2db916f282d750a90162e390e704338f50cfb431e0064585e3483"

  # Hash-based CDN URL — must be updated manually with each new release.
  # Run: curl -sI https://cdnimg.shining3d.com/software/<hash> | grep content-disposition
  # to confirm the version matches before updating.
  url "https://cdnimg.shining3d.com/software/94d36a01f47882d81c9b2d65d6168741"

  name "EXStar Hub"
  desc "Desktop software for Einstar Rockit & Einstar 2 3D scanners"
  homepage "https://www.einstar.com"

  livecheck do
    url "https://support.einstar.com/support/solutions/articles/60001635292-download-exstar-hub-desktop-software-for-einstar-rockit-einstar-2-"
    regex(/v?(\d+\.\d+\.\d+-\d+)/i)
  end

  pkg "EXStar_Hub_v#{version}_Release.pkg"

  zap trash: [
    "~/Library/Application Support/EXStar Hub",
    "~/Library/Preferences/com.shining3d.exstarhub.plist",
  ]
end
