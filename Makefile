.PHONY: home
home:
	home-manager switch --flake .#myprofile

.PHONY: os
os:
	nh os switch

.PHONY: clean
clean:
	nix-collect-garbage -d
