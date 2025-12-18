#!/bin/bash

# =============================================================================
# Cursor Extensions
# Run standalone: bash scripts/cursor.sh
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Only set up error handling if running standalone
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_standalone
fi

if command -v cursor &>/dev/null; then
    print_section "Installing Cursor extensions (${#CURSOR_EXTENSIONS[@]} marketplace + ${#CURSOR_VSIX_EXTENSIONS[@]} VSIX)"
    
    # Install marketplace extensions
    for ext in "${CURSOR_EXTENSIONS[@]}"; do
        if cursor --install-extension "$ext" --force 2>>"$LOG_FILE"; then
            echo "  ✅ $ext"
        else
            echo "  ❌ $ext"
        fi
    done
    
    # Install VSIX extensions (not on Cursor marketplace)
    VSIX_DIR="$SETUP_DIR/.vsix-cache"
    mkdir -p "$VSIX_DIR"
    
    for ext in "${CURSOR_VSIX_EXTENSIONS[@]}"; do
        publisher="${ext%%.*}"
        extension="${ext#*.}"
        vsix_file="$VSIX_DIR/$ext.vsix"
        
        # Download VSIX if not cached
        if [ ! -f "$vsix_file" ]; then
            vsix_url="https://$publisher.gallery.vsassets.io/_apis/public/gallery/publisher/$publisher/extension/$extension/latest/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
            if curl -fsSL "$vsix_url" -o "$vsix_file" 2>>"$LOG_FILE"; then
                echo "  📦 Downloaded $ext"
            else
                echo "  ❌ $ext (download failed)"
                rm -f "$vsix_file"
                continue
            fi
        fi
        
        # Install from VSIX
        if cursor --install-extension "$vsix_file" --force 2>>"$LOG_FILE"; then
            echo "  ✅ $ext (vsix)"
        else
            echo "  ❌ $ext (install failed)"
        fi
    done
else
    echo ""
    echo "⚠️  Cursor CLI not found - skipping extensions"
    echo "   Run 'Shell Command: Install cursor command' from Cursor"
fi
