{ config, lib, ... }:

with lib;

{
  options.k3s.nodeLabels = mkOption {
    type = types.attrsOf types.str;
    default = { };
    description = "Node labels to apply to this node.";
  };

  config = {
    environment.variables.K3S_NODE_LABEL_FLAGS = builtins.concatStringsSep " " (
      map (kv: "--node-label ${kv}") (
        map (key: "${key}=${config.k3s.nodeLabels.${key}}") (builtins.attrNames config.k3s.nodeLabels)
      )
    );
  };
}
