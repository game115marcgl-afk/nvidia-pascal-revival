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


# 3. Sprawdzanie systemu i narzędzi
OS_TYPE=$(grep -i ^ID= /etc/os-release | cut -d'=' -f2 | tr -d '"')

echo "Wykryto system: $OS_TYPE"

if [ "$OS_TYPE" == "fedora" ]; then
    DEPENDENCIES=(gcc make dkms kernel-devel elfutils-libelf-devel)
    INSTALL_CMD="sudo dnf install"
else
    DEPENDENCIES=(gcc make dkms build-essential linux-headers-$(uname -r))
    INSTALL_CMD="sudo apt install"
fi

echo "Sprawdzanie narzędzi systemowych..."
for pkg in "${DEPENDENCIES[@]}"; do
    if rpm -q $pkg &> /dev/null || dpkg -l | grep -q "^ii  $pkg " &> /dev/null; then
        echo "  [+] $pkg jest zainstalowany."
    else
        echo "  [-] BRAK $pkg. Zalecane: $INSTALL_CMD $pkg"
    fi
done

