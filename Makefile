.PHONY: home
home:
	home-manager switch --flake .#myprofile

.PHONY: os
os:
	nh os switch

all:
	make os
	make home

.PHONY: clean
clean:
	nix-collect-garbage -d
