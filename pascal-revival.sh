
#!/bin/bash
# Marcel's NVIDIA Pascal Revival Patcher v1.2
# Licencja: MIT

# Kolory dla lepszej czytelności
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}--- Inicjalizacja Marcel's Pascal Patcher v1.2 ---${NC}"

# 1. Sprawdzenie uprawnień
if [ "$EUID" -ne 0 ]; then 
  echo -e "${RED}[BŁĄD] Uruchom skrypt jako root (sudo)!${NC}"
  exit 1
fi

# 2. Inteligentne wykrywanie ID karty
# Szukamy tylko urządzeń VGA/3D NVIDIA
DEVICE_ID=$(lspci -n | grep "10de:" | grep -E "0300|0302" | cut -d':' -f4 | cut -c1-4 | head -n 1)

if [ -z "$DEVICE_ID" ]; then
    echo -e "${RED}[BŁĄD] Nie wykryto karty NVIDIA Pascal!${NC}"
    exit 1
fi

echo -e "${GREEN}[INFO] Wykryte ID Twojej karty: 0x$DEVICE_ID${NC}"

# 3. Dynamiczne sprawdzanie folderu sterownika
DRIVER_DIR=$(find . -maxdepth 1 -type d -name "NVIDIA-Linux-x86_64-*" | head -n 1)

if [ -z "$DRIVER_DIR" ]; then
    echo -e "${RED}[BŁĄD] Nie znaleziono rozpakowanego folderu ze sterownikiem!${NC}"
    echo "Użyj najpierw: ./NVIDIA-Linux-x86_64-xxx.run -x"
    exit 1
fi

# 4. Patchowanie tabeli PCI
PCI_TABLE_FILE="$DRIVER_DIR/kernel/nvidia/nv-pci-table.c"

if [ ! -f "$PCI_TABLE_FILE" ]; then
    echo -e "${RED}[BŁĄD] Brak pliku $PCI_TABLE_FILE${NC}"
    exit 1
fi

if grep -qi "$DEVICE_ID" "$PCI_TABLE_FILE"; then
    echo -e "${GREEN}[OK] Karta 0x$DEVICE_ID jest już obsługiwana.${NC}"
else
    echo -e "${YELLOW}[MOD] Patchowanie kodu źródłowego sterownika...${NC}"
    # Tworzenie backupu
    cp "$PCI_TABLE_FILE" "${PCI_TABLE_FILE}.bak"
    
    # Wstawianie ID karty po nagłówku tabeli
    sed -i "/nvidia_pci_device_id_table\[\] = {/a \    { 0x10de, 0x$DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }," "$PCI_TABLE_FILE"
    echo -e "${GREEN}[OK] ID karty pomyślnie wstrzyknięte.${NC}"
fi

# 5. AUTOMATYKA: Konfiguracja GSP, Coolbits i PowerMizer
echo -e "${YELLOW}[MOD] Generowanie konfiguracji optymalizacyjnej...${NC}"

CONFIG_PATH="/etc/modprobe.d/nvidia-pascal-revival.conf"

cat <<EOF > "$CONFIG_PATH"
# Wygenerowane przez Marcel's Pascal Revival
# 1. Wyłączenie GSP (Krytyczne dla serii 10xx)
options nvidia NVreg_EnableGpuFirmware=0

# 2. Odblokowanie Coolbits (Fan control & OC)
options nvidia "NVreg_RegistryDwords=Coolbits=28"

# 3. Wymuszenie trybu wysokiej wydajności (PowerMizer)
options nvidia "NVreg_RegistryDwords=PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerDefaultAC=0x1"
EOF

echo -e "${GREEN}[OK] Konfiguracja zapisana w $CONFIG_PATH${NC}"

# 6. Finalizacja
echo -e "\n${YELLOW}--- PROCES ZAKOŃCZONY ---${NC}"
echo "1. Przejdź do: cd $DRIVER_DIR"
echo "2. Zainstaluj: sudo ./nvidia-installer --no-cc-version-check"
echo "3. PO INSTALACJI wykonaj: sudo update-initramfs -u"
echo "4. Zrestartuj komputer."

# Bonus: Sprawdzenie Secure Boot
if mokutil --sb-state 2>/dev/null | grep -q "enabled"; then
    echo -e "\n${RED}[UWAGA] Secure Boot jest WŁĄCZONY!${NC}"
    echo "Spaczony sterownik nie uruchomi się, dopóki go nie podpiszesz lub nie wyłączysz Secure Boot w BIOS."
fi
