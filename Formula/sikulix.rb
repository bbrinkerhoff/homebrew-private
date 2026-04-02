class Sikulix < Formula
  desc "Visual automation and testing tool using screenshots"
  homepage "https://github.com/oculix-org/SikuliX1"
  url "https://launchpadlibrarian.net/526041591/sikulixide-2.0.5.jar"
  sha256 "f4b0b50c8e413094e78cd1d8fed02ae65f62f8c53ed00da0562fdedf4acff729"
  version "2.0.5"
  license "MIT"

  def install
    libexec.install "sikulixide-2.0.5.jar" => "sikulixide.jar"

    (bin/"sikulix").write <<~EOS
      #!/bin/bash
      JAVA_HOME="$(/usr/libexec/java_home -v 11 2>/dev/null)"
      if [ -z "$JAVA_HOME" ]; then
        echo "Error: JDK 11 not found. Install with: brew install --cask bbrinkerhoff/private/temurin-jdk11" >&2
        exit 1
      fi
      export JAVA_HOME
      export PATH="$JAVA_HOME/bin:$PATH"
      cleanup() {
        pkill -f "sikulixide.jar" 2>/dev/null
      }
      trap cleanup EXIT INT TERM
      java -jar "#{libexec}/sikulixide.jar" "$@"
      # SikuliX re-launches itself as a detached process; poll until it exits
      sleep 1
      while pgrep -f "sikulixide.jar" > /dev/null 2>&1; do
        sleep 1
      done
    EOS
  end

  def caveats
    <<~EOS
      SikuliX requires JDK 11. Install the recommended JDK with:
        brew install --cask bbrinkerhoff/private/temurin-jdk11
    EOS
  end

  test do
    assert_predicate libexec/"sikulixide.jar", :exist?
  end
end
