# scripts/start.ps1
$ErrorActionPreference = 'Stop'
Write-Host "== Stocks + News + Sentiment: start =="

# 1) Build Streamlit image (skip if unchanged)
docker compose build streamlit

# 2) Start Postgres
docker compose up -d db

# 3) Wait for DB to be healthy (pg_isready exit code == 0)
Write-Host "Waiting for Postgres..."
for ($i=0; $i -lt 30; $i++) {
  docker compose exec -T db pg_isready -U app -d warehouse -h 127.0.0.1 *> $null
  if ($LASTEXITCODE -eq 0) { Write-Host "✓ Postgres is ready."; break }
  Start-Sleep -Seconds 2
  if ($i -eq 29) { throw "Postgres not ready after timeout." }
}

# 4) Apply DDL + seeds (pipe files so no container mounts needed)
if (Test-Path .\warehouse\sql\schema.sql) {
  Get-Content .\warehouse\sql\schema.sql -Raw | docker compose exec -T db psql -U app -d warehouse -v ON_ERROR_STOP=1
  Write-Host "✓ Applied schema.sql"
}

if (Test-Path .\warehouse\sql\calendar_generate.sql) {
  Get-Content .\warehouse\sql\calendar_generate.sql -Raw | docker compose exec -T db psql -U app -d warehouse -v ON_ERROR_STOP=1
  Write-Host "✓ Applied calendar_generate.sql"
}

if (Test-Path .\warehouse\sql\seed_data.sql) {
  Get-Content .\warehouse\sql\seed_data.sql -Raw | docker compose exec -T db psql -U app -d warehouse -v ON_ERROR_STOP=1
  Write-Host "✓ Applied seed_data.sql"
}

# 5) Initialize Airflow (idempotent)
docker compose run --rm airflow-init

# 6) Start web apps
docker compose up -d streamlit airflow-webserver airflow-scheduler

# 7) Show status + urls
docker compose ps
Write-Host ""
Write-Host "Streamlit → http://localhost:8501"
Write-Host "Airflow   → http://localhost:8080"
Write-Host ""
Write-Host "== All services running =="
