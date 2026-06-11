# ════════════════════════════════════════════════════════════════════════════
# COP'IQ — Démarrage du pipeline en mode nuit (autonome)
# ════════════════════════════════════════════════════════════════════════════
#
# Lance le pipeline en boucle infinie avec rotation des 3 IA.
# Tourne jusqu'à ce que tu fasses Ctrl+C OU que toutes les tables atteignent
# le cap de 500 000 questions.
#
# Usage :
#   .\start_overnight.ps1                          # OpenAI + DeepSeek + Claude
#   .\start_overnight.ps1 -Providers deepseek      # DeepSeek seul (low cost)
#   .\start_overnight.ps1 -Cap 100000              # Cap perso à 100k
#   .\start_overnight.ps1 -BatchSize 30            # 30 par batch (au lieu de 50)
#   .\start_overnight.ps1 -DryRun                  # Test sans écrire en BDD
#
# Conseil : avant de dormir, lance ce script puis verrouille ta session
#          (touche Windows + L). Le script continue en arrière-plan.
# ════════════════════════════════════════════════════════════════════════════

param(
    [string]$Providers  = "openai",
    [int]   $Cap        = 500000,
    [int]   $BatchSize  = 50,
    [int]   $Pause      = 3,
    [int]   $CyclePause = 15,
    [switch]$DryRun
)

# Aller dans le dossier du script
Set-Location -Path $PSScriptRoot

# Forcer UTF-8 pour les emojis et accents
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding           = [System.Text.Encoding]::UTF8

# Vérifs basiques
if (-not (Test-Path ".env")) {
    Write-Host "❌ Fichier .env introuvable dans $PSScriptRoot" -ForegroundColor Red
    Write-Host "   Crée-le à partir de .env.example puis relance." -ForegroundColor Yellow
    exit 1
}
if (-not (Test-Path "generate_and_insert.py")) {
    Write-Host "❌ generate_and_insert.py introuvable." -ForegroundColor Red
    exit 1
}

# Construire les arguments
$pyArgs = @(
    "generate_and_insert.py"
    "--forever"
    "--providers";    $Providers
    "--cap";          $Cap
    "--batch-size";   $BatchSize
    "--pause";        $Pause
    "--cycle-pause";  $CyclePause
)
if ($DryRun) { $pyArgs += "--dry-run" }

# Banner d'accueil
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║   COP'IQ — Pipeline psycho v3 — démarrage MODE NUIT              ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""
Write-Host "  Providers   : $Providers"   -ForegroundColor White
Write-Host "  Batch       : $BatchSize"    -ForegroundColor White
Write-Host "  Cap / table : $Cap"          -ForegroundColor White
Write-Host "  Pause       : ${Pause}s entre appels, ${CyclePause}s entre cycles" -ForegroundColor White
Write-Host "  Dry-run     : $DryRun"       -ForegroundColor White
Write-Host ""
Write-Host "  Logs persistants : .\logs\pipeline.log" -ForegroundColor DarkGray
Write-Host "  Réponses IA      : .\out\"             -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Pour arrêter proprement : Ctrl+C"      -ForegroundColor Yellow
Write-Host ""

# Lancer le pipeline
python @pyArgs
