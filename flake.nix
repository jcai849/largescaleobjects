{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    chunknet.url = "github:jcai849/chunknet";
  };
  outputs =
    {
      nixpkgs,
      utils,
      chunknet,
      ...
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        largescaleobjects = pkgs.rPackages.buildRPackage {
          name = "largescaleobjects";
          version = "1.0";
          src = ./.;
          propagatedBuildInputs = [
            chunknet.packages.${system}.default
            pkgs.rPackages.iotools
            pkgs.rPackages.dplyr
          ];
        };

        prod_pkgs = [ largescaleobjects ];
        dev_pkgs = prod_pkgs ++ [ pkgs.rPackages.languageserver ];

        R_dev = pkgs.rWrapper.override { packages = dev_pkgs; };
        radian_dev = pkgs.radianWrapper.override { packages = dev_pkgs; };
        radian_dev_exec = pkgs.writeShellApplication {
          name = "r";
          runtimeInputs = [ radian_dev ];
          text = "exec radian";
        };

      in
      {
        packages.default = largescaleobjects;
        devShell = pkgs.mkShell {
          buildInputs = [
            R_dev
            radian_dev_exec
          ];
        };
      }
    );
}
