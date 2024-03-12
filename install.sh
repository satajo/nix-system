#!/bin/sh -e

sudo nixos-rebuild switch --flake .#default
