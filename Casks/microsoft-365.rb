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

cask "microsoft-365" do
  version "16.109.26052523"
  sha256 "80d1846821552aa20c3ba397372e5d0265ab5ccbcbe56213f6070784c27d9d58"

  url "https://nextcloud.invalid/Microsoft/Microsoft_365_and_Office_#{version}_Installer.pkg",
      using:    NextcloudAuthDownloadStrategy,
      verified: "nextcloud.invalid"

  name "Microsoft 365"
  desc "Microsoft 365 and Office suite (Word, Excel, PowerPoint)"
  homepage "https://www.microsoft.com/microsoft-365"

  pkg "Microsoft_365_and_Office_#{version}_Installer.pkg"

  uninstall pkgutil: [
    "com.microsoft.package.Microsoft_Excel.app",
    "com.microsoft.package.Microsoft_PowerPoint.app",
    "com.microsoft.package.Microsoft_Word.app",
    "com.microsoft.package.DFonts",
    "com.microsoft.package.Frameworks",
    "com.microsoft.package.Proofing_Tools",
    "com.microsoft.pkg.licensing",
  ]

  zap trash: [
    "~/Library/Containers/com.microsoft.Excel",
    "~/Library/Containers/com.microsoft.Powerpoint",
    "~/Library/Containers/com.microsoft.Word",
    "~/Library/Group Containers/UBF8T346G9.Office",
    "~/Library/Group Containers/UBF8T346G9.ms",
    "~/Library/Preferences/com.microsoft.Excel.plist",
    "~/Library/Preferences/com.microsoft.Powerpoint.plist",
    "~/Library/Preferences/com.microsoft.Word.plist",
  ]
end
