{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
	hello
    ];

    username = "rockygo2";
    homeDirectory = "/home/rockygo2";
    
    # You do not need to change this if you're reading this in the future.
    # Don't ever change this after the first build.  Don't ask questions.
    stateVersion = "23.11";
  };
  
  programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        ms-vscode.cpptools
        ms-python.python
      ];
    };
  };

programs.firefox = {
  enable = true;
  profiles.default = {
    id = 0;
    settings = {
      "browser.startup.homepage" = "https://duckduckgo.com";
    };
    
    # This MUST be 'extensions.packages' (note the .packages)
    extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      darkreader
    ];
  };
};

  programs.bash = {
      enable = true;

      initExtra = ''
	if [[ -n "$FHS" ]]; then
		export PS1="\n(FHS) ''${PS1:2}"
	fi
      '';
    };

}
