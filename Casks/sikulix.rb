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

cask "sikulix" do
  version "2.0.6"
  sha256 "6161de5522883a9232ef4c6ced94ad530621157e539e034e7fc033c696da2652"

  url "https://nextcloud.invalid/SikuliX/SikuliX-#{version}.dmg",
      using: NextcloudAuthDownloadStrategy

  name "SikuliX"
  desc "Visual automation and testing tool using screenshots"
  homepage "https://github.com/oculix-org/SikuliX1"

  app "SikuliX.app"

  zap trash: [
    "~/Library/Application Support/SikuliX",
    "~/Library/Preferences/org.sikuli.ide.plist",
  ]
end
