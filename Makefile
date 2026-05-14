OS := $(shell hostname)

.PHONY: home laptop desktop os all clean

home:
	home-manager switch --flake .#myprofile

laptop:
	nh os switch .#laptop -b backup

desktop:
	nh os switch .#desktop -b backup

os:
	nh os switch .#$(OS)

all:
	$(MAKE) os
	$(MAKE) home

clean:
	nix-collect-garbage -d