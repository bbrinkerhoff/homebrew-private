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

cask "ejectify" do
  version "HEAD-adf07c3"
  sha256 "58f9ec24c8e45ea09b1687056ca9de8203ee93e8a217700be9515d98d2b7b72f"

  url "https://nextcloud.invalid/Ejectify/Ejectify-#{version}.dmg",
      using: NextcloudAuthDownloadStrategy

  name "Ejectify"
  desc "Menu bar app that safely ejects external drives before sleep"
  homepage "https://ejectify.app"

  app "Ejectify.app"

  zap trash: [
    "~/Library/Application Support/Ejectify",
    "~/Library/Preferences/app.ejectify.Ejectify.plist",
  ]
end
