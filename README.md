# VM Health Check

A Bash script to analyze the health of an Ubuntu virtual machine based on CPU, memory, and disk space usage.

## Usage

- **Basic check:**
  ```bash
  bash vm_health_check.sh
  ```

- **Check with explanation:**
  ```bash
  bash vm_health_check.sh explain
  ```

## Health Criteria

- If all of CPU, memory, and disk usage are at or below 60%, the VM is declared **Healthy**.
- If any of these are over 60%, the VM is declared **Not healthy**.

## Requirements

- Ubuntu virtual machine
- Uses `top`, `free`, and `df` utilities
