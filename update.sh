#!/bin/sh
eval "$(ssh-agent -s)" && ssh-add ~/.ssh/git
sleep 5
sudo nix flake update
sleep 10
git add . && git commit -m "update flake" && git push
sleep 5
sudo nixos-rebuild switch --upgrade
