#!/bin/sh
eval "$(ssh-agent -s)" && ssh-add ~/.ssh/git
sudo nix flake update
git add . && git commit -m "update flake" && git push
sudo nixos-rebuild switch --upgrade
