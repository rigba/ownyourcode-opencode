# OwnYourCode Project Installation Script (Windows - OpenCode Version)
# AI-Mentored Development for Juniors
# Version 2.2.3-opencode

$ErrorActionPreference = "Stop"

# Paths
$BASE_DIR = Join-Path $env:USERPROFILE "ownyourcode"
$PROJECT_DIR = Get-Location
$PROJECT_NAME = Split-Path -Leaf $PROJECT_DIR

# Colors
function Write-Info { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Blue }
function Write-OK { param($msg) Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Err { param($msg) Write-Host "[ERROR] $msg" -ForegroundColor Red; exit 1 }

# Header
Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║     OwnYourCode Installation v2.2.3 (OpenCode Version)    ║" -ForegroundColor Green
Write-Host "║       AI-Mentored Spec-Driven Development Engine          ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

# Check base exists
if (-not (Test-Path $BASE_DIR)) {
    Write-Err "OwnYourCode base not found at $BASE_DIR. Run the base installer first."
}

Write-Info "Installing OwnYourCode into: $PROJECT_DIR"
Write-Host ""

# ============================================================================
# STEP 1: Handle existing installation
# ============================================================================

$ownyourcodeDir = Join-Path $PROJECT_DIR "ownyourcode"
if (Test-Path $ownyourcodeDir) {
    Write-Warn "OwnYourCode already installed in this project."
    $confirm = Read-Host "Reinstall? [y/N]"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Info "Cancelled."
        exit 0
    }
    Write-Host ""
}

# ============================================================================
# STEP 2: Create directory structure
# ============================================================================

Write-Info "Creating directories..."

$directories = @(
    "ownyourcode/product",
    "ownyourcode/specs/active",
    "ownyourcode/specs/completed",
    "ownyourcode/career/stories",
    "ownyourcode/guides",
    ".opencode/commands/own",
    ".opencode/skills/fundamentals/frontend",
    ".opencode/skills/fundamentals/backend",
    ".opencode/skills/fundamentals/security",
    ".opencode/skills/fundamentals/performance",
    ".opencode/skills/fundamentals/error-handling",
    ".opencode/skills/fundamentals/engineering",
    ".opencode/skills/fundamentals/database",
    ".opencode/skills/fundamentals/testing",
    ".opencode/skills/fundamentals/seo",
    ".opencode/skills/fundamentals/accessibility",
    ".opencode/skills/fundamentals/documentation",
    ".opencode/skills/fundamentals/debugging",
    ".opencode/skills/fundamentals/resistance",
    ".opencode/skills/gates/ownership",
    ".opencode/skills/gates/security",
    ".opencode/skills/gates/error",
    ".opencode/skills/gates/performance",
    ".opencode/skills/gates/fundamentals",
    ".opencode/skills/gates/testing",
    ".opencode/skills/career/star-stories",
    ".opencode/skills/career/resume-bullets",
    ".opencode/skills/learned"
)

foreach ($dir in $directories) {
    $fullPath = Join-Path $PROJECT_DIR $dir
    New-Item -ItemType Directory -Force -Path $fullPath | Out-Null
}

Write-OK "Directories created"

# ============================================================================
# STEP 3: Handle opencode.md (Smart Merge)
# ============================================================================

$OPENCODE_MD = Join-Path $PROJECT_DIR ".opencode/opencode.md"
$TEMPLATE = Join-Path $BASE_DIR "core/opencode.md.template"

Write-Info "Configuring opencode.md..."

if (Test-Path $OPENCODE_MD) {
    $content = Get-Content $OPENCODE_MD -Raw

    if ($content -match "OWNYOURCODE:") {
        Write-Warn "OwnYourCode section already exists in opencode.md"
        $replace = Read-Host "Replace existing OwnYourCode section? [y/N]"

        if (($replace -eq "y" -or $replace -eq "Y") -and (Test-Path $TEMPLATE)) {
            # Remove existing section and append fresh
            $cleaned = $content -replace "# ═.*OWNYOURCODE[\s\S]*?# ═.*END OWNYOURCODE[^\n]*", ""
            $templateContent = Get-Content $TEMPLATE -Raw
            Set-Content -Path $OPENCODE_MD -Value ($cleaned.Trim() + "`n`n" + $templateContent)
            Write-OK "OwnYourCode section replaced"
        } else {
            Write-Info "Keeping existing OwnYourCode section"
        }
    } else {
        # Existing opencode.md without OwnYourCode - merge
        Write-Info "Found existing opencode.md - merging..."

        # Backup
        $backupPath = Join-Path $PROJECT_DIR ".opencode/opencode.md.pre-ownyourcode"
        Copy-Item $OPENCODE_MD $backupPath
        Write-OK "Backed up to opencode.md.pre-ownyourcode"

        # Append template
        if (Test-Path $TEMPLATE) {
            $templateContent = Get-Content $TEMPLATE -Raw
            Add-Content -Path $OPENCODE_MD -Value ("`n`n" + $templateContent)
            Write-OK "OwnYourCode section merged into opencode.md"
        }
    }
} else {
    # No existing opencode.md - create fresh
    if (Test-Path $TEMPLATE) {
        $opencodeDir = Join-Path $PROJECT_DIR ".opencode"
        New-Item -ItemType Directory -Force -Path $opencodeDir | Out-Null
        Copy-Item $TEMPLATE $OPENCODE_MD
        Write-OK "Created opencode.md with THE STRICTNESS"
    }
}

# ============================================================================
# STEP 4: Copy commands
# ============================================================================

Write-Info "Installing commands..."

$srcCommands = Join-Path $BASE_DIR ".opencode/commands/own"
$destCommands = Join-Path $PROJECT_DIR ".opencode/commands/own"

if (Test-Path $srcCommands) {
    $files = Get-ChildItem -Path $srcCommands -Filter "*.md"
    foreach ($file in $files) {
        Copy-Item $file.FullName -Destination $destCommands -Force
    }
    $cmdCount = $files.Count
    Write-OK "Commands installed: $cmdCount"
} else {
    Write-Warn "Commands directory not found"
}

# ============================================================================
# STEP 5: Copy skills
# ============================================================================

Write-Info "Installing skills..."

# Fundamentals
$fundamentals = @(
    "frontend", "backend", "security", "performance", "error-handling",
    "engineering", "database", "testing", "seo", "accessibility",
    "documentation", "debugging", "resistance"
)

$fundamentalCount = 0
foreach ($skill in $fundamentals) {
    $src = Join-Path $BASE_DIR ".opencode/skills/fundamentals/$skill/SKILL.md"
    $dest = Join-Path $PROJECT_DIR ".opencode/skills/fundamentals/$skill/SKILL.md"
    if (Test-Path $src) {
        Copy-Item $src $dest -Force
        $fundamentalCount++
    }
}
Write-OK "Fundamental skills installed: $fundamentalCount"

# Gates
$gates = @("ownership", "security", "error", "performance", "fundamentals", "testing")
$gateCount = 0
foreach ($gate in $gates) {
    $src = Join-Path $BASE_DIR ".opencode/skills/gates/$gate/SKILL.md"
    $dest = Join-Path $PROJECT_DIR ".opencode/skills/gates/$gate/SKILL.md"
    if (Test-Path $src) {
        Copy-Item $src $dest -Force
        $gateCount++
    }
}
Write-OK "Gate skills installed: $gateCount"

# Career
$careerSkills = @("star-stories", "resume-bullets")
foreach ($skill in $careerSkills) {
    $src = Join-Path $BASE_DIR ".opencode/skills/career/$skill/SKILL.md"
    $dest = Join-Path $PROJECT_DIR ".opencode/skills/career/$skill/SKILL.md"
    if (Test-Path $src) {
        Copy-Item $src $dest -Force
    }
}
Write-OK "Career extraction skills installed"

# Create .gitkeep for learned
$gitkeepPath = Join-Path $PROJECT_DIR ".opencode/skills/learned/.gitkeep"
Set-Content -Path $gitkeepPath -Value "# Auto-generated skills go here - from /own-retro"

# ============================================================================
# STEP 6: Learning Registry Note
# ============================================================================

Write-Info "Learning Registry..."

$learningDir = Join-Path $BASE_DIR "learning"
if (Test-Path $learningDir) {
    Write-OK "Using global registry at ~/ownyourcode/learning/"
} else {
    Write-Warn "Global learning registry not found. Run base-install.ps1 to create it."
}

# ============================================================================
# STEP 7: Copy guides
# ============================================================================

Write-Info "Copying guides..."

$srcGuides = Join-Path $BASE_DIR "guides"
$destGuides = Join-Path $PROJECT_DIR "ownyourcode/guides"

if (Test-Path $srcGuides) {
    $files = Get-ChildItem -Path $srcGuides -Filter "*.md" -ErrorAction SilentlyContinue
    foreach ($file in $files) {
        Copy-Item $file.FullName -Destination $destGuides -Force
    }
    Write-OK "Guides copied"
} else {
    Write-Info "No guides to copy"
}

# ============================================================================
# STEP 8: Create product templates
# ============================================================================

Write-Info "Creating product templates..."

$productDir = Join-Path $PROJECT_DIR "ownyourcode/product"

$nl = [Environment]::NewLine
$missionLines = @(
    "# Project Mission",
    "",
    "> Run ``/own-init`` to define your project vision.",
    "",
    "## The Problem",
    "",
    "<!-- What problem are you solving? Describe the PROBLEM, not features. -->",
    "",
    "## Who Is This For?",
    "",
    "<!-- Who will use this? -->",
    "",
    "## Definition of Done",
    "",
    "<!-- When is this project DONE? What must work? -->"
)
Set-Content -Path (Join-Path $productDir "mission.md") -Value ($missionLines -join $nl)

$stackLines = @(
    "# Technology Stack",
    "",
    "> Run ``/own-init`` to auto-detect and document your stack.",
    "",
    "## Frontend",
    "",
    "<!-- Technologies detected or chosen -->",
    "",
    "## Backend",
    "",
    "<!-- Technologies detected or chosen -->",
    "",
    "## Why These Choices?",
    "",
    "<!-- Document your reasoning -->"
)
Set-Content -Path (Join-Path $productDir "stack.md") -Value ($stackLines -join $nl)

$roadmapLines = @(
    "# Project Roadmap",
    "",
    "> Run ``/own-init`` to create your development roadmap.",
    "",
    "## Phase 1: Foundation",
    "",
    "- [ ] Project setup",
    "- [ ] Core structure",
    "",
    "## Phase 2: Core Features",
    "",
    "- [ ] Feature 1",
    "- [ ] Feature 2",
    "",
    "## Phase 3: Polish and Deploy",
    "",
    "- [ ] Testing",
    "- [ ] Deployment"
)
Set-Content -Path (Join-Path $productDir "roadmap.md") -Value ($roadmapLines -join $nl)

Write-OK "Product templates created"

# ============================================================================
# STEP 9: Update .gitignore
# ============================================================================

$gitignorePath = Join-Path $PROJECT_DIR ".gitignore"
if (Test-Path $gitignorePath) {
    $gitignore = Get-Content $gitignorePath -Raw
    if ($gitignore -notmatch "ownyourcode/career/") {
        Add-Content -Path $gitignorePath -Value "`n# OwnYourCode - personal career tracking`nownyourcode/career/"
        Write-OK "Updated .gitignore"
    }
}

# ============================================================================
# COMPLETE
# ============================================================================

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   Installation Complete! v2.2.3-opencode                  ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-OK "OwnYourCode v2.2.3 installed successfully!"
Write-Host ""

Write-Info "What was created:"
Write-Host ""
Write-Host "  📁 ownyourcode/              — Your project docs [commit this]"
Write-Host "     ├── product/             — Mission, stack, roadmap"
Write-Host "     ├── specs/               — Feature specifications"
Write-Host "     ├── career/              — Interview stories & bullets"
Write-Host "     └── guides/              — Setup guides"
Write-Host ""
Write-Host "  📁 .opencode/               — OpenCode configuration"
Write-Host "     ├── opencode.md          — THE STRICTNESS [mentor behavior]"
Write-Host "     ├── commands/            — Slash commands"
Write-Host "     └── skills/              — Auto-invoked mentorship skills"
Write-Host "         ├── fundamentals/    — Core review skills"
Write-Host "         ├── gates/           — Mentorship gates"
Write-Host "         ├── career/          — STAR & resume extraction"
Write-Host "         └── learned/         — Auto-generated from /own-retro"
Write-Host ""
Write-Host "  📁 ~/ownyourcode/learning/  — GLOBAL Learning Flywheel"
Write-Host "     ├── LEARNING_REGISTRY.md — Your growth tracker [all projects]"
Write-Host "     ├── patterns/            — Reusable solutions"
Write-Host "     └── failures/            — Documented anti-patterns"
Write-Host ""

Write-Info "Next steps:"
Write-Host "  1. Open OpenCode in this project"
Write-Host "  2. Run: /own-init"
Write-Host ""
Write-Info "The workflow:"
Write-Host "  /own-feature  ->  Plan a new feature [creates spec, design, tasks]"
Write-Host "  /own-advise   ->  Get relevant learnings before starting a task"
Write-Host "  /own-guide    ->  Get implementation help as you code"
Write-Host "  /own-done     ->  Pass 6 Gates, code review, extract STAR story"
Write-Host "  /own-retro    ->  Capture what you learned"
Write-Host ""

Write-Info "MCP Setup [recommended]:"
Write-Host "  Context7:  opencode mcp add context7 --transport http https://mcp.context7.com/mcp"
Write-Host "  OctoCode:  https://octocode.ai/#installation"
Write-Host ""

Write-Info "To remove OwnYourCode later:"
Write-Host "  irm https://raw.githubusercontent.com/rigba/ownyourcode-opencode/main/scripts/project-uninstall.ps1 | iex"
Write-Host ""
