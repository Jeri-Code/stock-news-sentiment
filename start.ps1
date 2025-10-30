# Build Streamlit image (skip if unchanged)
docker compose build streamlit

# Start Postgres first
docker compose up -d db

# Wait for DB healthy
Write-Host "Waiting for Postgres to be ready..."
$max = 30
for ($i=0; $i -lt $max; $i++) {
  $ready = docker compose exec db pg_isready -U app -d warehouse 2>$null
  if ($LASTEXITCODE -eq 0) { Write-Host "Postgres is ready."; break }
  Start-Sleep -Seconds 2
  if ($i -eq ($max-1)) { throw "Postgres not ready after timeout." }
}

# Load schema + seed (uses Option B piping; works even without a mount)
if (Test-Path .\warehouse\sql\schema.sql) {
  Get-Content .\warehouse\sql\schema.sql -Raw | docker compose exec -T db psql -U app -d warehouse
  Write-Host "Applied schema.sql"
}
if (Test-Path .\warehouse\sql\seed_data.sql) {
  Get-Content .\warehouse\sql\seed_data.sql -Raw | docker compose exec -T db psql -U app -d warehouse
  Write-Host "Applied seed_data.sql"
}

# Initialize Airflow (first time) – safe to re-run
docker compose run --rm airflow-init

# Start Streamlit + Airflow
docker compose up -d streamlit airflow-webserver airflow-scheduler

docker compose ps
Write-Host ""
Write-Host "Streamlit: http://localhost:8501"
Write-Host "Airflow:   http://localhost:8080"
Write-Host ""
Write-Host "All services running."