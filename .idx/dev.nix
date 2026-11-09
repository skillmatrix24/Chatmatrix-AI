# Project IDX configuration for Laravel
# To learn more, see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-23.11"; # or "unstable"

  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.php82
    pkgs.php82Packages.composer
    pkgs.nodejs_20
    pkgs.mariadb
  ];

  # Sets environment variables in the workspace
  env = {
    PORT = "8000";
  };

  # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
  idx = {
    extensions = [
      "bmewburn.vscode-intelephense-client"
      "onecentlin.laravel5-snippets"
      "codingyu.laravel-goto-view"
    ];

    # Enable previews and customize configuration
    previews = {
      enable = true;
      previews = {
        web = {
          command = ["php" "artisan" "serve" "--port" "$PORT" "--host" "0.0.0.0"];
          manager = "web";
        };
      };
    };

    # Workspace lifecycle hooks
    workspace = {
      # Runs when a workspace is first created
      onCreate = {
        # Initialize database and setup env
        setup = ''
          if [ ! -f .env ]; then
            cp .env.example .env
            php artisan key:generate
          fi
          composer install --no-interaction
          mysql_install_db
          mysqld_safe --datadir="./.idx/mysql" &
          sleep 5
          mysql -u root -e "CREATE DATABASE IF NOT EXISTS u360021411_api;"
        '';
      };
      # Runs each time the workspace is (re)started
      onStart = {
        start-mysql = "mysqld_safe --datadir='./.idx/mysql' &";
      };
    };
  };
}
