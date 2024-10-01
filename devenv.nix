{ pkgs, nixpkgs-ruby, lib, config, inputs, ... }:

let
  ignoringVulns = x: x // { meta = (x.meta // { knownVulnerabilities = []; }); };
  ruby_2_7_6 = nixpkgs-ruby.packages.${pkgs.system}."ruby-2.7.6".override {
    openssl = pkgs.openssl_1_1.overrideAttrs ignoringVulns;
  };

in {
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [ pkgs.git ];

  # https://devenv.sh/languages/
  # languages.rust.enable = true;

  languages.ruby.enable = true;
  languages.ruby.package = ruby_2_7_6;

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  # services.postgres.enable = true;
  services.postgres = {
    enable = true;
    package = pkgs.postgresql_15;
    initialDatabases = [{ name = "project1"; }]; 
    extensions = extensions: [
      extensions.postgis
    ];
  };

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  enterShell = ''
    hello
    git --version
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
