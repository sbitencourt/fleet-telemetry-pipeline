#!/bin/bash

# --- Settings ---
# Exit immediately if a command exits with a non-zero status
set -e
set -o pipefail

# --- Variables ---
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
BASE_DIR="$(dirname -- "${SCRIPT_DIR}")"
LOG_DIR="${BASE_DIR}/logs"
RAW_DIR="${BASE_DIR}/data/raw"
ZIP_FILE="${BASE_DIR}/taxi-trajectory.zip"
DATA_URL="https://www.kaggle.com/api/v1/datasets/download/crailtap/taxi-trajectory"

# --- Logging Setup ---

# 1. Create log directory if it doesn't exist 
mkdir -p "${LOG_DIR}"

# 2. Define log file names with timestamps
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="${LOG_DIR}/download_dataset_${TIMESTAMP}.log"
ERR_FILE="${LOG_DIR}/download_dataset_${TIMESTAMP}.err"

# 3. Redirect stdout and stderr to log files
exec > >(tee -a "${LOG_FILE}") 
exec 2> >(tee -a "${ERR_FILE}" >&2)

# --- Main Script ---

echo "=================================================="
echo "Starting download-dataset script at: ${TIMESTAMP}"
echo "Output log (stdout) in: ${LOG_FILE}"
echo "Error log (stderr) in: ${ERR_FILE}"
echo "=================================================="

echo "Step 1: Downloading data from ${DATA_URL}..."
curl -L -f -o "${ZIP_FILE}" "${DATA_URL}"
echo "Download completed."

echo "Step 2: Extracting data to ${RAW_DIR}..."
unzip -o "${ZIP_FILE}" -d "${RAW_DIR}"
echo "Extraction completed."

echo "Step 3: Cleaning up temporary files..."
rm "${ZIP_FILE}"
echo "Cleanup completed."

echo "=================================================="
echo "Script successfully completed."
echo "=================================================="