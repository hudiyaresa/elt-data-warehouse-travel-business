#!/bin/bash

echo "========== Start dbt with Luigi Orcestration Process =========="

# Virtual Environment Path
VENV_PATH="/mnt/d/Coding/Training/Data_Warehouse/Week_07/pactravel-dataset/.venv/bin/activate"

# Activate Virtual Environment
source "$VENV_PATH"

# Set Python script
PYTHON_SCRIPT="/mnt/d/Coding/Training/Data_Warehouse/Week_07/pactravel-dataset/elt_pipeline.py"

# Run Python Script and Insert Log Process
python3 "$PYTHON_SCRIPT" >> /mnt/d/Coding/Training/Data_Warehouse/Week_07/pactravel-dataset/logs/luigi_process.log 2>&1

# Luigi info simple log
dt=$(date '+%d/%m/%Y %H:%M:%S');
echo "Luigi started at ${dt}" >> /mnt/d/Coding/Training/Data_Warehouse/Week_07/pactravel-dataset/logs/luigi_info.log

echo "========== End of dbt with Luigi Orcestration Process =========="