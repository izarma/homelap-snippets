#!/usr/bin/env -S just --justfile

## repo configuration
sub-update:
  cd .. && git submodule update --init --recursive

## nix installation
install IP:
  ssh -o "StrictHostKeyChecking no" nixos@{{IP}} "sudo bash -c '\
    nix-shell -p git --run \"cd /root/ && \
    git clone -b main https://github.com/izarma/nix-ollama-snippets.git && \
    cd nix-ollama-snippets/nix/hosts/nixos/iza-ai/ && \
    sh install-nix.sh\"'"

## nix updates
hostname := `hostname | cut -d "." -f 1`
[linux]
switch target_host=hostname:
  cd nix && sudo nixos-rebuild switch --flake .#{{target_host}}

## copy docker compose yaml to remote host via Ansible
compose HOST *V:
  cd ansible && ansible-playbook playbook.yaml --limit {{HOST}} --tags compose {{V}}