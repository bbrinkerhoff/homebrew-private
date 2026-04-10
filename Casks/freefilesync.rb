require "download_strategy"

unless defined?(NextcloudAuthDownloadStrategy)
  class NextcloudAuthDownloadStrategy < CurlDownloadStrategy
    def _fetch(url:, resolved_url:, timeout:)
      require "uri"
      nc_user = `/usr/local/bin/op read "op://Private/Nextcloud Application WebDav/username"`.chomp
      nc_pass = `/usr/local/bin/op read "op://Private/Nextcloud Application WebDav/password"`.chomp
      nc_base = `/usr/local/bin/op read "op://Private/Nextcloud Application WebDav/webdav_url"`.chomp

      path = URI.decode_www_form_component(URI.parse(url).path)

      curl_download(
        "#{nc_base}#{path}",
        "--globoff",
        "--user", "#{nc_user}:#{nc_pass}",
        to: temporary_path,
      )
    end
  end
end

cask "freefilesync" do
  version "14.9"
  sha256 "ea4351535ae3a90e893f67c1668a6ac4bd30e501f52accaadd676ba48a182128"

  url "https://nextcloud.invalid/FreeFileSync/FreeFileSync_#{version}_%5BDonation_Edition%5D_macOS.zip",
      using: NextcloudAuthDownloadStrategy

  name "FreeFileSync"
  desc "Free file synchronization"
  homepage "https://www.freefilesync.org"

  pkg "FreeFileSync_#{version}_[Donation_Edition].pkg"

  uninstall pkgutil: [
    "org.freefilesync.pkg.FreeFileSync",
    "org.freefilesync.pkg.RealTimeSync",
  ]

  zap trash: [
    "~/Library/Application Support/FreeFileSync",
    "~/Library/Preferences/FreeFileSync",
  ]
end
