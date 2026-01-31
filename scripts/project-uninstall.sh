#!/bin/bash

# OwnYourCode Project Uninstallation Script (OpenCode Version)
# Cleanly removes OwnYourCode from a project

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Paths
PROJECT_DIR=$(pwd)
OPENCODE_MD="$PROJECT_DIR/.opencode/opencode.md"
BACKUP="$PROJECT_DIR/.opencode/opencode.md.pre-ownyourcode"

# Helpers
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Header
echo ""
echo -e "${RED}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║     OwnYourCode Uninstallation (OpenCode Version)     ║${NC}"
echo -e "${RED}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

# ============================================================================
# STEP 0: Check if OwnYourCode is installed
# ============================================================================

if [ ! -d "$PROJECT_DIR/ownyourcode" ] && [ ! -d "$PROJECT_DIR/.opencode/commands/own" ]; then
    warn "OwnYourCode does not appear to be installed in this project."
    exit 0
fi

# ============================================================================
# STEP 1: Confirm
# ============================================================================

info "This will remove OwnYourCode from: $PROJECT_DIR"
echo ""
echo "  Will remove:"
echo "    - ownyourcode/ folder"
echo "    - .opencode/commands/own/"
echo "    - OwnYourCode section from opencode.md"
echo ""

read -p "Continue? (y/N): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    info "Cancelled."
    exit 0
fi

echo ""

# ============================================================================
# STEP 2: Handle opencode.md
# ============================================================================

info "Restoring opencode.md..."

if [ -f "$OPENCODE_MD" ]; then
    if [ -f "$BACKUP" ]; then
        # Restore from backup
        cp "$BACKUP" "$OPENCODE_MD"
        rm "$BACKUP"
        success "Restored original opencode.md from backup"
    elif grep -q "OWNYOURCODE:" "$OPENCODE_MD" 2>/dev/null; then
        # Remove OwnYourCode section using markers
        # Create temp file without OwnYourCode section
        sed '/# ═.*OWNYOURCODE/,/# ═.*END OWNYOURCODE/d' "$OPENCODE_MD" > "$OPENCODE_MD.tmp"

        # Remove trailing blank lines
        sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$OPENCODE_MD.tmp" > "$OPENCODE_MD"
        rm "$OPENCODE_MD.tmp"

        # Check if opencode.md is now empty (only whitespace)
        if [ ! -s "$OPENCODE_MD" ] || [ -z "$(grep -v '^[[:space:]]*$' "$OPENCODE_MD")" ]; then
            rm "$OPENCODE_MD"
            success "Removed opencode.md (was only OwnYourCode content)"
        else
            success "Removed OwnYourCode section from opencode.md"
        fi
    else
        info "No OwnYourCode section found in opencode.md"
    fi
else
    info "No opencode.md found"
fi

# ============================================================================
# STEP 3: Remove commands
# ============================================================================

info "Removing commands..."

if [ -d "$PROJECT_DIR/.opencode/commands/own" ]; then
    rm -rf "$PROJECT_DIR/.opencode/commands/own"
    success "Removed .opencode/commands/own/"
else
    info "No commands folder found"
fi

# Clean up empty directories
if [ -d "$PROJECT_DIR/.opencode/commands" ] && [ -z "$(ls -A "$PROJECT_DIR/.opencode/commands")" ]; then
    rmdir "$PROJECT_DIR/.opencode/commands"
    info "Removed empty .opencode/commands/"
fi

if [ -d "$PROJECT_DIR/.opencode" ] && [ -z "$(ls -A "$PROJECT_DIR/.opencode")" ]; then
    rmdir "$PROJECT_DIR/.opencode"
    info "Removed empty .opencode/"
fi

# ============================================================================
# STEP 4: Remove ownyourcode folder
# ============================================================================

info "Removing ownyourcode folder..."

if [ -d "$PROJECT_DIR/ownyourcode" ]; then
    # Ask about specs if they exist
    if [ -d "$PROJECT_DIR/ownyourcode/specs" ] && [ "$(ls -A "$PROJECT_DIR/ownyourcode/specs/active" 2>/dev/null)" ]; then
        warn "You have active specs in ownyourcode/specs/active/"
        read -p "Delete them too? (y/N): " delete_specs
        if [ "$delete_specs" != "y" ] && [ "$delete_specs" != "Y" ]; then
            # Move specs to project root before deletion
            mv "$PROJECT_DIR/ownyourcode/specs" "$PROJECT_DIR/ownyourcode-specs-backup"
            success "Backed up specs to ownyourcode-specs-backup/"
        fi
    fi

    rm -rf "$PROJECT_DIR/ownyourcode"
    success "Removed ownyourcode/"
else
    info "No ownyourcode folder found"
fi

# ============================================================================
# COMPLETE
# ============================================================================

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Uninstallation Complete!                     ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

success "OwnYourCode has been removed from this project."
echo ""

info "To reinstall later:"
echo "  ~/ownyourcode/scripts/project-install.sh"
echo ""
