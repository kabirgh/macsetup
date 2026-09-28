#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$#" -ne 1 ]; then
    echo "Usage: setup.sh --personal | --work" >&2
    exit 2
fi

case "${1:-}" in
    --personal)
        exec bash "$ROOT_DIR/setup-personal.sh"
        ;;
    --work)
        exec bash "$ROOT_DIR/setup-work.sh"
        ;;
    *)
        echo "Usage: setup.sh --personal | --work" >&2
        exit 2
        ;;
esac
