#!/bin/bash
# =================================================================
# MARCEL'S NVIDIA PASCAL REVIVAL - MASTER BUILDER v1.5
# Cel: Adaptacja sterowników serii 500+ dla architektury Pascal
# Autor: Marcel (game115marcgl-afk)
# =================================================================

# Kolory
R='\033[0;31m'
G='\033[0;32m'
Y='\033[1;33m'
B='\033[0;34m'
NC='\033[0m'

# Wersja bazowa sterownika (możesz tu wpisać nowszą, np. z serii 590 gdy wyjdzie)
BASE_DRIVER="570.124.04"
DRIVER_FILE="NVIDIA-Linux-x86_64-$BASE_DRIVER.run"
DRIVER_URL="https://us.download.nvidia.com/XFree86/Linux-x86_64/$BASE_DRIVER/$DRIVER_FILE"
EXTRACT_DIR="NVIDIA-Pascal-Revival-Source"

echo -e "${B}=====================================================${NC}"
echo -e "${Y}       MARCEL'S NVIDIA PASCAL REVIVAL BUILDER        ${NC}"
echo -e "${B}=====================================================${NC}"

# 1. Sprawdzenie uprawnień
if [ "$EUID" -ne 0 ]; then 
  echo -e "${R}[BŁĄD] Uruchom skrypt przez sudo!${NC}"
  exit 1
fi

# 2. Wykrywanie ID karty Pascal
echo -e "${Y}[1/6] Wykrywanie sprzętu...${NC}"
DEVICE_ID=$(lspci -n | grep "10de:" | grep -E "0300|0302" | cut -d':' -f4 | cut -c1-4 | head -n 1)

if [ -z "$DEVICE_ID" ]; then
    echo -e "${R}[BŁĄD] Nie wykryto karty NVIDIA Pascal!${NC}"
    exit 1
fi
echo -e "${G}[OK] Wykryto Pascal ID: 0x$DEVICE_ID${NC}"

# 3. Instalacja zależności
echo -e "${Y}[2/6] Instalowanie narzędzi kompilacji...${NC}"
apt update && apt install -y build-essential dkms wget libglvnd-dev pkg-config mokutil

# 4. Pobieranie sterownika
if [ ! -f "$DRIVER_FILE" ]; then
    echo -e "${Y}[3/6] Pobieranie oficjalnego sterownika $BASE_DRIVER...${NC}"
    wget "$DRIVER_URL"
else
    echo -e "${G}[3/6] Sterownik jest już pobrany.${NC}"
fi

# 5. Rozpakowywanie
echo -e "${Y}[4/6] Rozpakowywanie instalatora...${NC}"
rm -rf "$EXTRACT_DIR"
./"$DRIVER_FILE" -x --target "$EXTRACT_DIR"

# 6. PATCHOWANIE (Sercem projektu)
echo -e "${Y}[5/6] Modyfikacja kodu źródłowego (PCI Table)...${NC}"
PCI_TABLE_FILE="$EXTRACT_DIR/kernel/nvidia/nv-pci-table.c"

if [ -f "$PCI_TABLE_FILE" ]; then
    # Wstrzykujemy Twoje ID karty do tabeli wspieranych urządzeń
    sed -i "/nvidia_pci_device_id_table\[\] = {/a \    { 0x10de, 0x$DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }," "$PCI_TABLE_FILE"
    echo -e "${G}[OK] Karta 0x$DEVICE_ID została dopisana do sterownika.${NC}"
else
    echo -e "${R}[BŁĄD] Nie znaleziono pliku tabeli PCI!${NC}"
    exit 1
fi

# 7. TWORZENIE KONFIGURACJI OPTYMALIZACYJNEJ
echo -e "${Y}[6/6] Generowanie poprawek wydajności (Coolbits, GSP Fix)...${NC}"
CONF_FILE="/etc/modprobe.d/nvidia-pascal-revival.conf"

cat <<EOF > "$CONF_FILE"
# Wygenerowane przez Marcel's Pascal Revival
options nvidia NVreg_EnableGpuFirmware=0
options nvidia "NVreg_RegistryDwords=Coolbits=28"
options nvidia "NVreg_RegistryDwords=PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerDefaultAC=0x1"
EOF

echo -e "${G}[OK] Konfiguracja zapisana w $CONF_FILE${NC}"

# Sprawdzenie Secure Boot
if mokutil --sb-state 2>/dev/null | grep -q "enabled"; then
    echo -e "${R}!!! UWAGA: SECURE BOOT JEST WŁĄCZONY !!!${NC}"
    echo -e "${Y}Sterownik nie zadziała, jeśli go nie podpiszesz lub nie wyłączysz Secure Boot w BIOS.${NC}"
fi

echo -e "${B}=====================================================${NC}"
echo -e "${G}         PROCES ZAKOŃCZONY SUKCESEM!                 ${NC}"
echo -e "${B}=====================================================${NC}"
echo -e "Aby zainstalować sterownik, wykonaj teraz te kroki:"
echo -e "1. Przejdź do konsoli TTY (CTRL+ALT+F3)"
echo -e "2. Zatrzymaj pulpit: ${Y}sudo service lightdm stop${NC}"
echo -e "3. Uruchom instalację: ${Y}sudo $EXTRACT_DIR/nvidia-installer${NC}"
echo -e "4. Po instalacji zrestartuj komputer.${NC}"
