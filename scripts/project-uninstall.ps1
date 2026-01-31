# OwnYourCode Project Uninstallation Script (Windows - OpenCode Version)
# Cleanly removes OwnYourCode from a project

$ErrorActionPreference = "Stop"

# Paths
$PROJECT_DIR = Get-Location
$OPENCODE_MD = Join-Path $PROJECT_DIR ".opencode/opencode.md"
$BACKUP = Join-Path $PROJECT_DIR ".opencode/opencode.md.pre-ownyourcode"

# Colors
function Write-Info { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Blue }
function Write-OK { param($msg) Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Err { param($msg) Write-Host "[ERROR] $msg" -ForegroundColor Red; exit 1 }

# Header
Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════╗" -ForegroundColor Red
Write-Host "║     OwnYourCode Uninstallation (OpenCode Version)     ║" -ForegroundColor Red
Write-Host "╚═══════════════════════════════════════════════════════╝" -ForegroundColor Red
Write-Host ""

# ============================================================================
# STEP 0: Check if OwnYourCode is installed
# ============================================================================

$ownyourcodeDir = Join-Path $PROJECT_DIR "ownyourcode"
$commandsDir = Join-Path $PROJECT_DIR ".opencode/commands/own"

if (-not (Test-Path $ownyourcodeDir) -and -not (Test-Path $commandsDir)) {
    Write-Warn "OwnYourCode does not appear to be installed in this project."
    exit 0
}

# ============================================================================
# STEP 1: Confirm
# ============================================================================

Write-Info "This will remove OwnYourCode from: $PROJECT_DIR"
Write-Host ""
Write-Host "  Will remove:"
Write-Host "    - ownyourcode/ folder"
Write-Host "    - .opencode/commands/own/"
Write-Host "    - OwnYourCode section from opencode.md"
Write-Host ""

$confirm = Read-Host "Continue? [y/N]"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Info "Cancelled."
    exit 0
}

Write-Host ""

# ============================================================================
# STEP 2: Handle opencode.md
# ============================================================================

Write-Info "Restoring opencode.md..."

if (Test-Path $OPENCODE_MD) {
    if (Test-Path $BACKUP) {
        # Restore from backup
        Copy-Item $BACKUP $OPENCODE_MD -Force
        Remove-Item $BACKUP -Force
        Write-OK "Restored original opencode.md from backup"
    } else {
        $content = Get-Content $OPENCODE_MD -Raw
        if ($content -match "OWNYOURCODE:") {
            # Remove OwnYourCode section using markers
            $cleaned = $content -replace "# ═.*OWNYOURCODE[\s\S]*?# ═.*END OWNYOURCODE[^\n]*", ""
            $cleaned = $cleaned.Trim()
            
            if ([string]::IsNullOrWhiteSpace($cleaned)) {
                Remove-Item $OPENCODE_MD -Force
                Write-OK "Removed opencode.md (was only OwnYourCode content)"
            } else {
                Set-Content -Path $OPENCODE_MD -Value $cleaned
                Write-OK "Removed OwnYourCode section from opencode.md"
            }
        } else {
            Write-Info "No OwnYourCode section found in opencode.md"
        }
    }
} else {
    Write-Info "No opencode.md found"
}

# ============================================================================
# STEP 3: Remove commands
# ============================================================================

Write-Info "Removing commands..."

if (Test-Path $commandsDir) {
    Remove-Item -Recurse -Force $commandsDir
    Write-OK "Removed .opencode/commands/own/"
} else {
    Write-Info "No commands folder found"
}

# Clean up empty directories
$parentCommands = Join-Path $PROJECT_DIR ".opencode/commands"
if (Test-Path $parentCommands) {
    if ((Get-ChildItem $parentCommands).Count -eq 0) {
        Remove-Item $parentCommands -Force
        Write-Info "Removed empty .opencode/commands/"
    }
}

$opencodeDir = Join-Path $PROJECT_DIR ".opencode"
if (Test-Path $opencodeDir) {
    if ((Get-ChildItem $opencodeDir).Count -eq 0) {
        Remove-Item $opencodeDir -Force
        Write-Info "Removed empty .opencode/"
    }
}

# ============================================================================
# STEP 4: Remove ownyourcode folder
# ============================================================================

Write-Info "Removing ownyourcode folder..."

if (Test-Path $ownyourcodeDir) {
    $specsDir = Join-Path $ownyourcodeDir "specs/active"
    if (Test-Path $specsDir) {
        if ((Get-ChildItem $specsDir).Count -gt 0) {
            Write-Warn "You have active specs in ownyourcode/specs/active/"
            $delete_specs = Read-Host "Delete them too? [y/N]"
            if ($delete_specs -ne "y" -and $delete_specs -ne "Y") {
                $backupSpecs = Join-Path $PROJECT_DIR "ownyourcode-specs-backup"
                Move-Item (Join-Path $ownyourcodeDir "specs") $backupSpecs -Force
                Write-OK "Backed up specs to ownyourcode-specs-backup/"
            }
        }
    }

    Remove-Item -Recurse -Force $ownyourcodeDir
    Write-OK "Removed ownyourcode/"
} else {
    Write-Info "No ownyourcode folder found"
}

# ============================================================================
# COMPLETE
# ============================================================================

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║          Uninstallation Complete!                     ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-OK "OwnYourCode has been removed from this project."
Write-Host ""

Write-Info "To reinstall later:"
Write-Host "  ~/ownyourcode/scripts/project-install.ps1"
Write-Host ""
