#!/bin/bash

# OwnYourCode Project Installation Script (OpenCode Version)
# AI-Mentored Development for Juniors
# Version 2.2.3-opencode

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Paths
BASE_DIR="$HOME/ownyourcode"
PROJECT_DIR=$(pwd)
PROJECT_NAME=$(basename "$PROJECT_DIR")

# Helpers
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Header
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     OwnYourCode Installation v2.2.3 (OpenCode Version)    ║${NC}"
echo -e "${GREEN}║       AI-Mentored Spec-Driven Development Engine          ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check base exists
if [ ! -d "$BASE_DIR" ]; then
    error "OwnYourCode base not found at $BASE_DIR. Run the base installer first."
fi

info "Installing OwnYourCode into: $PROJECT_DIR"
echo ""

# ============================================================================
# STEP 1: Handle existing installation
# ============================================================================

if [ -d "$PROJECT_DIR/ownyourcode" ]; then
    warn "OwnYourCode already installed in this project."
    read -p "Reinstall? (y/N): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        info "Cancelled."
        exit 0
    fi
    echo ""
fi

# ============================================================================
# STEP 2: Create directory structure
# ============================================================================

info "Creating directories..."

# OwnYourCode project directories
mkdir -p "$PROJECT_DIR/ownyourcode/product"
mkdir -p "$PROJECT_DIR/ownyourcode/specs/active"
mkdir -p "$PROJECT_DIR/ownyourcode/specs/completed"
mkdir -p "$PROJECT_DIR/ownyourcode/career/stories"
mkdir -p "$PROJECT_DIR/ownyourcode/guides"

# OpenCode directories (v2.0 - Skill-Driven)
mkdir -p "$PROJECT_DIR/.opencode/commands/own"
mkdir -p "$PROJECT_DIR/.opencode/skills/fundamentals/frontend"
mkdir -p "$PROJECT_DIR/.opencode/skills/fundamentals/backend"
mkdir -p "$PROJECT_DIR/.opencode/skills/fundamentals/security"
mkdir -p "$PROJECT_DIR/.opencode/skills/fundamentals/performance"
mkdir -p "$PROJECT_DIR/.opencode/skills/fundamentals/error-handling"
mkdir -p "$PROJECT_DIR/.opencode/skills/fundamentals/engineering"
mkdir -p "$PROJECT_DIR/.opencode/skills/fundamentals/database"
mkdir -p "$PROJECT_DIR/.opencode/skills/fundamentals/testing"
mkdir -p "$PROJECT_DIR/.opencode/skills/fundamentals/seo"
mkdir -p "$PROJECT_DIR/.opencode/skills/fundamentals/accessibility"
mkdir -p "$PROJECT_DIR/.opencode/skills/fundamentals/documentation"
mkdir -p "$PROJECT_DIR/.opencode/skills/fundamentals/debugging"
mkdir -p "$PROJECT_DIR/.opencode/skills/fundamentals/resistance"
mkdir -p "$PROJECT_DIR/.opencode/skills/gates/ownership"
mkdir -p "$PROJECT_DIR/.opencode/skills/gates/security"
mkdir -p "$PROJECT_DIR/.opencode/skills/gates/error"
mkdir -p "$PROJECT_DIR/.opencode/skills/gates/performance"
mkdir -p "$PROJECT_DIR/.opencode/skills/gates/fundamentals"
mkdir -p "$PROJECT_DIR/.opencode/skills/gates/testing"
mkdir -p "$PROJECT_DIR/.opencode/skills/career/star-stories"
mkdir -p "$PROJECT_DIR/.opencode/skills/career/resume-bullets"
mkdir -p "$PROJECT_DIR/.opencode/skills/learned"

# Note: Learning is GLOBAL at ~/ownyourcode/learning/ (not project-local)

success "Directories created"

# ============================================================================
# STEP 3: Handle opencode.md (Smart Merge)
# ============================================================================

OPENCODE_MD="$PROJECT_DIR/.opencode/opencode.md"
TEMPLATE="$BASE_DIR/core/opencode.md.template"

info "Configuring opencode.md..."

if [ -f "$OPENCODE_MD" ]; then
    # Check if OwnYourCode already installed
    if grep -q "OWNYOURCODE:" "$OPENCODE_MD" 2>/dev/null; then
        warn "OwnYourCode section already exists in opencode.md"
        read -p "Replace existing OwnYourCode section? (y/N): " replace
        if [ "$replace" = "y" ] || [ "$replace" = "Y" ]; then
            # Remove existing OwnYourCode section
            sed -i.bak '/# ═.*OWNYOURCODE/,/# ═.*END OWNYOURCODE/d' "$OPENCODE_MD"
            # Append fresh template
            echo "" >> "$OPENCODE_MD"
            cat "$TEMPLATE" >> "$OPENCODE_MD"
            success "OwnYourCode section replaced"
        else
            info "Keeping existing OwnYourCode section"
        fi
    else
        # Existing opencode.md without OwnYourCode - Smart merge
        info "Found existing opencode.md - merging..."

        # Backup original
        cp "$OPENCODE_MD" "$PROJECT_DIR/.opencode/opencode.md.pre-ownyourcode"
        success "Backed up to opencode.md.pre-ownyourcode"

        # Append OwnYourCode section
        echo "" >> "$OPENCODE_MD"
        echo "" >> "$OPENCODE_MD"
        cat "$TEMPLATE" >> "$OPENCODE_MD"
        success "OwnYourCode section merged into opencode.md"
    fi
else
    # No existing opencode.md - create fresh
    mkdir -p "$PROJECT_DIR/.opencode"
    cp "$TEMPLATE" "$OPENCODE_MD"
    success "Created opencode.md with THE STRICTNESS"
fi

# ============================================================================
# STEP 4: Copy commands (v2.0 location)
# ============================================================================

info "Installing commands..."

# Copy commands from .opencode/commands/own/
cp "$BASE_DIR/.opencode/commands/own/"*.md "$PROJECT_DIR/.opencode/commands/own/" 2>/dev/null || true
success "Commands installed (10 commands including test/docs)"

# ============================================================================
# STEP 5: Copy skills (NEW in v2.0)
# ============================================================================

info "Installing skills..."

# Copy fundamentals
if [ -d "$BASE_DIR/.opencode/skills/fundamentals" ]; then
    for skill in frontend backend security performance error-handling engineering database testing seo accessibility documentation debugging resistance; do
        if [ -f "$BASE_DIR/.opencode/skills/fundamentals/$skill/SKILL.md" ]; then
            cp "$BASE_DIR/.opencode/skills/fundamentals/$skill/SKILL.md" \
               "$PROJECT_DIR/.opencode/skills/fundamentals/$skill/"
        fi
    done
    success "13 Core Fundamental skills installed"
fi

# Copy gates
if [ -d "$BASE_DIR/.opencode/skills/gates" ]; then
    for gate in ownership security error performance fundamentals testing; do
        if [ -f "$BASE_DIR/.opencode/skills/gates/$gate/SKILL.md" ]; then
            cp "$BASE_DIR/.opencode/skills/gates/$gate/SKILL.md" \
               "$PROJECT_DIR/.opencode/skills/gates/$gate/"
        fi
    done
    success "6 Mentorship Gate skills installed"
fi

# Copy career skills
if [ -d "$BASE_DIR/.opencode/skills/career" ]; then
    for career in star-stories resume-bullets; do
        if [ -f "$BASE_DIR/.opencode/skills/career/$career/SKILL.md" ]; then
            cp "$BASE_DIR/.opencode/skills/career/$career/SKILL.md" \
               "$PROJECT_DIR/.opencode/skills/career/$career/"
        fi
    done
    success "Career extraction skills installed"
fi

# Create .gitkeep for learned skills
echo "# Auto-generated skills go here (from /own-retro)" > "$PROJECT_DIR/.opencode/skills/learned/.gitkeep"

# ============================================================================
# STEP 6: Learning Registry Note (v2.1 - Global Learning)
# ============================================================================

info "Learning Registry..."

# Learning is GLOBAL at ~/ownyourcode/learning/ (not project-local)
# This ensures learnings persist across ALL projects
if [ -d "$BASE_DIR/learning" ]; then
    success "Using global registry at ~/ownyourcode/learning/"
else
    warn "Global learning registry not found. Run base-install.sh to create it."
fi

# ============================================================================
# STEP 7: Copy guides
# ============================================================================

info "Copying guides..."

cp "$BASE_DIR/guides/"*.md "$PROJECT_DIR/ownyourcode/guides/" 2>/dev/null || true
success "Guides copied"

# ============================================================================
# STEP 8: Create product templates
# ============================================================================

info "Creating product templates..."

cat > "$PROJECT_DIR/ownyourcode/product/mission.md" << 'EOF'
# Project Mission

> Run `/own-init` to define your project vision.

## The Problem

<!-- What problem are you solving? Describe the PROBLEM, not features. -->

## Who Is This For?

<!-- Who will use this? -->

## Definition of Done

<!-- When is this project DONE? What must work? -->
EOF

cat > "$PROJECT_DIR/ownyourcode/product/stack.md" << 'EOF'
# Technology Stack

> Run `/own-init` to auto-detect and document your stack.

## Frontend

<!-- Technologies detected or chosen -->

## Backend

<!-- Technologies detected or chosen -->

## Why These Choices?

<!-- Document your reasoning -->
EOF

cat > "$PROJECT_DIR/ownyourcode/product/roadmap.md" << 'EOF'
# Project Roadmap

> Run `/own-init` to create your development roadmap.

## Phase 1: Foundation

- [ ] Project setup
- [ ] Core structure

## Phase 2: Core Features

- [ ] Feature 1
- [ ] Feature 2

## Phase 3: Polish & Deploy

- [ ] Testing
- [ ] Deployment
EOF

success "Product templates created"

# ============================================================================
# STEP 9: Update .gitignore
# ============================================================================

if [ -f "$PROJECT_DIR/.gitignore" ]; then
    if ! grep -q "ownyourcode/career/" "$PROJECT_DIR/.gitignore" 2>/dev/null; then
        echo "" >> "$PROJECT_DIR/.gitignore"
        echo "# OwnYourCode - personal career tracking" >> "$PROJECT_DIR/.gitignore"
        echo "ownyourcode/career/" >> "$PROJECT_DIR/.gitignore"
        success "Updated .gitignore"
    fi
fi

# ============================================================================
# COMPLETE
# ============================================================================

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Installation Complete! v2.2.3-opencode                  ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"

success "OwnYourCode v2.2.3-opencode installed successfully!"
echo ""

info "What was created:"
echo ""
echo "  📁 ownyourcode/              — Your project docs (commit this)"
echo "     ├── product/             — Mission, stack, roadmap"
echo "     ├── specs/               — Feature specifications"
echo "     ├── career/              — Interview stories & bullets"
echo "     └── guides/              — Setup guides"
echo ""
echo "  📁 .opencode/               — OpenCode configuration"
echo "     ├── opencode.md          — THE STRICTNESS (mentor behavior)"
echo "     ├── commands/            — 10 slash commands"
echo "     └── skills/              — Auto-invoked mentorship skills"
echo "         ├── fundamentals/    — 13 Core review skills"
echo "         ├── gates/           — 6 Mentorship gates"
echo "         ├── career/          — STAR & resume extraction"
echo "         └── learned/         — Auto-generated from /own-retro"
echo ""
echo "  📁 ~/ownyourcode/learning/  — GLOBAL Learning Flywheel"
echo "     ├── LEARNING_REGISTRY.md — Your growth tracker (all projects)"
echo "     ├── patterns/            — Reusable solutions"
echo "     └── failures/            — Documented anti-patterns"
echo ""

info "Next steps:"
echo "  1. Open OpenCode in this project"
echo "  2. Run: /own-init"
echo ""
info "The workflow:"
echo "  /own-feature  →  Plan a new feature (creates spec, design, tasks)"
echo "  /own-advise   →  Get relevant learnings before starting a task"
echo "  /own-guide    →  Get implementation help as you code"
echo "  /own-done     →  Pass 6 Gates, code review, extract STAR story"
echo "  /own-retro    →  Capture what you learned"
echo ""

info "MCP Setup (recommended):"
echo "  Context7:  opencode mcp add context7 --transport http https://mcp.context7.com/mcp"
echo "  OctoCode:  https://octocode.ai/#installation"
echo ""

info "To remove OwnYourCode later:"
echo "  ~/ownyourcode/scripts/project-uninstall.sh"
echo ""
