{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [80 443 6443];
  networking.firewall.allowedUDPPorts = [80 443];

  environment.systemPackages = with pkgs; [
    k3s
  ];

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--service-node-port-range 53-65535"
      #"--datastore-endpoint=\"postgres://kubernetes:WGugzAPZvZBMBK7Gjj2wHKEW@127.0.0.1:5432/kubernetes?sslmode=disable\""
      #"--cluster-cidr="
      #"--kubelet-arg=v=4"
    ];
  };

  environment.etc."rancher/k3s/registries.yaml" = {
    mode = "0600";
    text = ''
      configs:
        "registry.hanleym.com":
          auth:
            username: "hanleym"
            password: "QhwwkU32EwyiWLM6yusnT3A4"
    '';
  };

  # https://docs.k3s.io/helm#customizing-packaged-components-with-helmchartconfig
  # created /var/lib/rancher/k3s/server/manifests/traefik-config.yaml by hand:
}
