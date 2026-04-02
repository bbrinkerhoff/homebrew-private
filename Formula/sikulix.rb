class Sikulix < Formula
  desc "Visual automation and testing tool using screenshots"
  homepage "https://github.com/oculix-org/SikuliX1"
  url "https://launchpadlibrarian.net/526041591/sikulixide-2.0.5.jar"
  sha256 "f4b0b50c8e413094e78cd1d8fed02ae65f62f8c53ed00da0562fdedf4acff729"
  version "2.0.5"
  license "MIT"

  depends_on "openjdk"

  def install
    libexec.install "sikulixide-2.0.5.jar" => "sikulixide.jar"

    (bin/"sikulix").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="#{Formula["openjdk"].opt_prefix}"
      export PATH="#{Formula["openjdk"].opt_bin}:$PATH"
      exec java -jar "#{libexec}/sikulixide.jar" "$@"
    EOS
  end

  test do
    assert_predicate libexec/"sikulixide.jar", :exist?
  end
end
