self: super: {
  wiimms-iso-tools = super.wiimms-iso-tools.overrideAttrs (oldAttrs: rec {
    version = "3.03b";

    src = super.fetchFromGitHub {
      owner = "Wiimm";
      repo = "wiimms-iso-tools";
      rev = "7f41a7f1edf2bd1698482cafe1b10f6b87b73da7";
      sha256 = "1vhsi87vwjnmvnwjw8gnqqh9wishzcx885kwxm5j51zizl1mhqi9";
    };

    sourceRoot = "source/project";

    postPatch = ''
      sed -ie 's|/usr/bin/env|${super.coreutils}/bin/env|' gen-template.sh
      sed -ie 's|/usr/bin/env|${super.coreutils}/bin/env|' gen-text-file.sh
    '';
  });
}
