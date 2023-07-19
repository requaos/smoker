#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq unzip
# shellcheck shell=bash
set -eu -o pipefail

shopt -s nullglob
for g in $(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V); do
    echo "IOMMU Group ${g##*/}:"
    for d in $g/devices/*; do
        echo -e "\t$(lspci -nns ${d##*/})"
    done;
done;

# Attribution: https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/