# modules/k3s-node-labels.nix

{ config, lib, ... }:

with lib;

{
  options.k3s.nodeLabels = mkOption {
    type = types.attrsOf types.str;
    default = { };
    description = "Node labels to apply to this node.";
  };

  config = {
    # Generiert die Flags:  --node-label key=value
    environment.variables.K3S_NODE_LABEL_FLAGS =
      builtins.concatStringsSep " "
        (map (kv: "--node-label ${kv}")
             (map (key: "${key}=${config.k3s.nodeLabels.${key}}")
                  (builtins.attrNames config.k3s.nodeLabels)));
  };
}
