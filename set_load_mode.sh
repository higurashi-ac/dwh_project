#!/bin/bash
set -e

# Usage:
#   ./set_load_mode.sh FULL
#   ./set_load_mode.sh INCREMENTAL

if [ -z "$1" ]; then
  echo "❌ Please provide a mode: FULL or INCREMENTAL"
  exit 1
fi

MODE=$(echo "$1" | tr '[:lower:]' '[:upper:]')

if [[ "$MODE" != "FULL" && "$MODE" != "INCREMENTAL" ]]; then
  echo "❌ Invalid mode: $MODE. Allowed values: FULL or INCREMENTAL"
  exit 1
fi

dims=(
  partner
  ,employee
  ,sale_order
  ,sale_order_line
  ,purchase_order
  ,purchase_order_line
  ,planning_slot
  ,payment_justify
  ,account_move
  ,account_journal
)

for dim in "\${dims[@]}"; do
  airflow variables set load_mode_dim_\${dim} "$MODE"
  echo "✅ Set load_mode_dim_\${dim} = $MODE"
done

echo "🎉 All dimensions switched to $MODE mode"
