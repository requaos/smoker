{
  config,
  pkgs,
  lib,
  ...
}: {
  age.secrets.gmail-me-at-req-dot-com.file = ../../secrets/gmail-me-at-req-dot-com.age;
  programs.msmtp = {
    enable = true;
    setSendmail = true;
    accounts = {
      default = {
        auth = true;
        host = "smtp.gmail.com";
        port = 587;
        tls = true;
        from = config.vars.email;
        user = config.vars.email;
        passwordeval = "cat ${config.age.secrets.gmail-me-at-req-dot-com.path}";
      };
    };
  };
}
