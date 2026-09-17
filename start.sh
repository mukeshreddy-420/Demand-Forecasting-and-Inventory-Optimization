#!/usr/bin/env bash
set -e

echo "=========================================================="
echo "🚀 Starting Stocl Backend API (Production AWS Server)"
echo "=========================================================="

# Default port to 8000 if not set
PORT="${PORT:-8000}"
WORKERS="${WORKERS:-4}"

echo "Binding to 0.0.0.0:${PORT} with ${WORKERS} Gunicorn workers..."

exec gunicorn app.main:app \
    --workers "${WORKERS}" \
    --worker-class uvicorn.workers.UvicornWorker \
    --bind "0.0.0.0:${PORT}" \
    --timeout 120 \
    --access-logfile - \
    --error-logfile -
