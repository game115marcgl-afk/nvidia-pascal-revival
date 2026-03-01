#!/bin/bash

# Marcel's NVIDIA Pascal Revival - System Check
# Licencja: MIT

echo "------------------------------------------"
echo "Inicjalizacja Marcel's NVIDIA Optimizer..."
echo "------------------------------------------"

# 1. Sprawdzenie uprawnień root (sudo)
if [ "$EUID" -ne 0 ]; then 
  echo "[BŁĄD] Uruchom skrypt przez sudo: sudo ./setup.sh"
  exit 1
fi

# 2. Wykrywanie karty graficznej (szukamy Pascala)
GPU_CHECK=$(lspci | grep -i nvidia | grep -E "1050|1060|1070|1080|GTX")
if [ -z "$GPU_CHECK" ]; then
  echo "[OSTRZEŻENIE] Nie wykryto karty z serii Pascal (GTX 10xx)."
else
  echo "[OK] Wykryto sprzęt: $GPU_CHECK"
fi

# 3. Sprawdzanie niezbędnych narzędzi do kompilacji
echo "Sprawdzanie narzędzi systemowych..."
DEPENDENCIES=(gcc make dkms build-essential)
for pkg in "${DEPENDENCIES[@]}"; do
    if dpkg -l | grep -q "^ii  $pkg "; then
        echo "  [+] $pkg jest zainstalowany."
    else
        echo "  [-] BRAK $pkg. Instalacja wymagana: sudo apt install $pkg"
    fi
done

echo "------------------------------------------"
echo "System gotowy do dalszych etapów prac."
