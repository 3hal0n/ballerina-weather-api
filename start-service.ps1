# PowerShell script to run the Ballerina weather API with environment variable
# Load API key from .env file and start the service

# Read API key from .env file
$envFile = ".\.env"
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match "OPENWEATHER_API_KEY=(.+)") {
            $env:OPENWEATHER_API_KEY = $Matches[1].Trim('"')
            Write-Host "✅ API key loaded from .env file" -ForegroundColor Green
        }
    }
} else {
    Write-Host "❌ .env file not found. Please create one with OPENWEATHER_API_KEY=your_key" -ForegroundColor Red
    exit 1
}

# Verify API key is set
if (-not $env:OPENWEATHER_API_KEY) {
    Write-Host "❌ OPENWEATHER_API_KEY environment variable not set" -ForegroundColor Red
    exit 1
}

Write-Host "🚀 Starting Ballerina weather service..." -ForegroundColor Cyan
bal run