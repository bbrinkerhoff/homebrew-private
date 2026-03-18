class Ffmpeg < Formula
  desc "Play, record, convert, and stream audio and video (full codec support)"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-8.1.tar.xz"
  sha256 "b072aed6871998cce9b36e7774033105ca29e33632be5b6347f3206898e0756a"
  license "LGPL-2.1-or-later"
  head "https://github.com/FFmpeg/FFmpeg.git", branch: "master"

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build

  # AV1
  depends_on "aom"        # libaom-av1 encoder/decoder
  depends_on "dav1d"      # fast AV1 decoder
  depends_on "svt-av1"    # SVT-AV1 encoder

  # H.264 / H.265
  depends_on "x264"
  depends_on "x265"

  # VP8/VP9
  depends_on "libvpx"

  # Audio
  depends_on "opus"
  depends_on "libvorbis"
  depends_on "lame"
  depends_on "fdk-aac"    # higher quality AAC; makes binary nonfree

  # Subtitles
  depends_on "libass"
  depends_on "freetype"

  # ffplay
  depends_on "sdl2"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-pthreads
      --enable-version3
      --enable-gpl
      --enable-nonfree
      --enable-libaom
      --enable-libdav1d
      --enable-libsvtav1
      --enable-libx264
      --enable-libx265
      --enable-libvpx
      --enable-libopus
      --enable-libvorbis
      --enable-libmp3lame
      --enable-libfdk-aac
      --enable-libass
      --enable-libfreetype
      --enable-ffplay
      --disable-htmlpages
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "libaom-av1", shell_output("#{bin}/ffmpeg -encoders 2>&1")
    assert_match "libsvtav1",  shell_output("#{bin}/ffmpeg -encoders 2>&1")
    assert_match "libx264",    shell_output("#{bin}/ffmpeg -encoders 2>&1")
  end
end
