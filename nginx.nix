{ pkgs, ... }:
{
  systemd.services.nginx.serviceConfig.SupplementaryGroups = [ "users" ];
  security.acme = {
    acceptTerms = true;
    email = "jupiter@m.rdis.dev";
  };
  services.nginx = {
    enable = true;
    virtualHosts = {
      "tilde.hackclub.com" = {
        enableACME = true;
        locations = {
	  "~ ^/.well-known/amce-challenge" = {
            alias = "/var/lib/amce/amce-challenge/";
	  };
          "/" = {
            root = "/srv/www";
          };
          "~ ^/~(.+?)(/.*)?$" = {
            alias = "/srv/pub/$1/www$2";
            extraConfig = ''
             autoindex on;
	     add_header Content-Security-Policy "default-src 'self' 'unsafe-eval' 'unsafe-inline'; sandbox allow-forms allow-orientation-lock allow-pointer-lock allow-presentation allow-scripts allow-same-origin";
            '';
          };
        };
      };
    };
  };
}
