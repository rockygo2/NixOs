{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
	    hello
      (pkgs.python314.withPackages (ps: [
        ps.numpy
        ps.requests
        ps.pwntools
      ]))
    ];

    username = "rockygo2";
    homeDirectory = "/home/rockygo2";
    
    # You do not need to change this if you're reading this in the future.
    # Don't ever change this after the first build.  Don't ask questions.
    stateVersion = "23.11";
  };
  
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };

  xdg.configFile."mimeapps.list".force = true;

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
      
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
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

