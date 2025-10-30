Write-Host "Full reset — this will DELETE all Postgres and Airflow data."
$confirm = Read-Host "Type 'reset' to confirm"
if ($confirm -eq 'reset') {
  docker compose down -v
  Write-Host "All containers and volumes removed."
} else {
  Write-Host "Cancelled reset."
}
