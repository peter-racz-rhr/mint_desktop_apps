#!/usr/bin/env bash
# Installs several apps in one go.
#   ./install.sh                  asks for each app
#   ./install.sh all              installs every app
#   ./install.sh text-grab quick-notes
set -uo pipefail
cd "$(dirname "$0")"

APPS=(drop-shelf quick-notes text-grab now-playing mail-brief)

if [ $# -eq 0 ]; then
    chosen=()
    for app in "${APPS[@]}"; do
        read -r -p "Install $app? [Y/n] " answer
        case "${answer,,}" in n|no) ;; *) chosen+=("$app") ;; esac
    done
elif [ "$1" = "all" ]; then
    chosen=("${APPS[@]}")
else
    chosen=("$@")
fi

failed=()
for app in "${chosen[@]}"; do
    if [ ! -x "$app/install.sh" ]; then
        echo "Unknown app: $app (choose from: ${APPS[*]})"
        failed+=("$app")
        continue
    fi
    echo
    echo "=== $app ==="
    (cd "$app" && ./install.sh) || failed+=("$app")
done

echo
if [ ${#failed[@]} -eq 0 ]; then
    echo "Done."
else
    echo "Finished with problems in: ${failed[*]}"
    exit 1
fi
