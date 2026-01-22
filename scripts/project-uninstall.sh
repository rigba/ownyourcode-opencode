#!/bin/bash

# OwnYourCode Project Uninstallation Script
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
CLAUDE_MD="$PROJECT_DIR/.claude/CLAUDE.md"
BACKUP="$PROJECT_DIR/.claude/CLAUDE.md.pre-ownyourcode"

# Helpers
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Header
echo ""
echo -e "${RED}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║            OwnYourCode Uninstallation                  ║${NC}"
echo -e "${RED}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

# ============================================================================
# STEP 0: Check if OwnYourCode is installed
# ============================================================================

if [ ! -d "$PROJECT_DIR/ownyourcode" ] && [ ! -d "$PROJECT_DIR/.claude/commands/own" ]; then
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
echo "    - .claude/commands/own/"
echo "    - OwnYourCode section from CLAUDE.md"
echo ""

read -p "Continue? (y/N): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    info "Cancelled."
    exit 0
fi

echo ""

# ============================================================================
# STEP 2: Handle CLAUDE.md
# ============================================================================

info "Restoring CLAUDE.md..."

if [ -f "$CLAUDE_MD" ]; then
    if [ -f "$BACKUP" ]; then
        # Restore from backup
        cp "$BACKUP" "$CLAUDE_MD"
        rm "$BACKUP"
        success "Restored original CLAUDE.md from backup"
    elif grep -q "OWNYOURCODE:" "$CLAUDE_MD" 2>/dev/null; then
        # Remove OwnYourCode section using markers
        # Create temp file without OwnYourCode section
        sed '/# ═.*OWNYOURCODE/,/# ═.*END OWNYOURCODE/d' "$CLAUDE_MD" > "$CLAUDE_MD.tmp"

        # Remove trailing blank lines
        sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$CLAUDE_MD.tmp" > "$CLAUDE_MD"
        rm "$CLAUDE_MD.tmp"

        # Check if CLAUDE.md is now empty (only whitespace)
        if [ ! -s "$CLAUDE_MD" ] || [ -z "$(grep -v '^[[:space:]]*$' "$CLAUDE_MD")" ]; then
            rm "$CLAUDE_MD"
            success "Removed CLAUDE.md (was only OwnYourCode content)"
        else
            success "Removed OwnYourCode section from CLAUDE.md"
        fi
    else
        info "No OwnYourCode section found in CLAUDE.md"
    fi
else
    info "No CLAUDE.md found"
fi

# ============================================================================
# STEP 3: Remove commands
# ============================================================================

info "Removing commands..."

if [ -d "$PROJECT_DIR/.claude/commands/own" ]; then
    rm -rf "$PROJECT_DIR/.claude/commands/own"
    success "Removed .claude/commands/own/"
else
    info "No commands folder found"
fi

# Clean up empty directories
if [ -d "$PROJECT_DIR/.claude/commands" ] && [ -z "$(ls -A "$PROJECT_DIR/.claude/commands")" ]; then
    rmdir "$PROJECT_DIR/.claude/commands"
    info "Removed empty .claude/commands/"
fi

if [ -d "$PROJECT_DIR/.claude" ] && [ -z "$(ls -A "$PROJECT_DIR/.claude")" ]; then
    rmdir "$PROJECT_DIR/.claude"
    info "Removed empty .claude/"
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
