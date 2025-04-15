{ pkgs }:

let
  rubyVersion = "3_1";
  ruby = pkgs."ruby_${rubyVersion}";
in {
  bootstrap = "";
  name = "rails";
  config = {
    description = "Ruby on Rails configuration with Ruby 3.1.4, PostgreSQL, and Redis.";
    devshell = {
      packages = [
        ruby
        ruby.pkgs.bundler
        pkgs.yarn
        pkgs.postgresql
        pkgs.redis
        pkgs.git
      ];

      env = {
        BUNDLE_IGNORE_CONFIG = "true";
        PATH = "${pkgs.ruby.pkgs.ruby-lsp}/bin:${ruby}/bin:${pkgs.yarn}/bin:$PATH";
        GEM_HOME = "$PROJECT_ROOT/.gem_home";
        BUNDLE_APP_CONFIG = "$PROJECT_ROOT/.bundle_config";
      };

      init = ''
        bundle install
        yarn install
        createdb || true
        rails db:migrate
        rails server
      '';

      scripts = {
        server.exec = "rails server";
      };
    };
  };
}