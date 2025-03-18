#!/bin/sh

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/git
nix flake update
git add .
git commit -m "update flake"
git push
nixos-rebuild switch --upgrade