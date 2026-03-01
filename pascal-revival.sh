#!/bin/bash
# Marcel's NVIDIA Pascal Revival Patcher v1.1
# Licencja: MIT

# 1. Sprawdzenie uprawnień (potrzebne do ewentualnych zmian w systemie)
if [ "$EUID" -ne 0 ]; then 
  echo "[BŁĄD] Uruchom skrypt jako root (sudo)!"
  exit 1
fi

# 2. Inteligentne wykrywanie ID karty
# Szukamy urządzenia VGA/3D od Nvidii (10de). 
# Wykluczamy Audio (0x0fb0 itp.) i bierzemy tylko Device ID.
DEVICE_ID=$(lspci -n | grep "10de:" | grep -E "0300|0302" | cut -d':' -f4 | cut -c1-4 | head -n 1)

if [ -z "$DEVICE_ID" ]; then
    echo "[BŁĄD] Nie wykryto karty NVIDIA Pascal!"
    exit 1
fi

echo "--- Inicjalizacja Marcel's Pascal Patcher ---"
echo "Wykryte ID Twojej karty: 0x$DEVICE_ID"

# 3. Dynamiczne sprawdzanie folderu sterownika
DRIVER_DIR=$(find . -maxdepth 1 -type d -name "NVIDIA-Linux-x86_64-*" | head -n 1)

if [ -z "$DRIVER_DIR" ]; then
    echo "[BŁĄD] Nie znaleziono rozpakowanego folderu ze sterownikiem NVIDIA!"
    echo "Pamiętaj, aby go rozpakować komendą: ./NVIDIA-Linux-x86_64-xxx.run -x"
    exit 1
fi

echo "Praca w katalogu: $DRIVER_DIR"

# 4. Patchowanie tabeli PCI (Proprietary Kernel Module)
PCI_TABLE_FILE="$DRIVER_DIR/kernel/nvidia/nv-pci-table.c"

if [ ! -f "$PCI_TABLE_FILE" ]; then
    echo "[BŁĄD] Nie znaleziono pliku $PCI_TABLE_FILE. Czy to na pewno sterownik zamknięty?"
    exit 1
fi

# Sprawdzamy, czy nasze ID już tam jest
if grep -qi "$DEVICE_ID" "$PCI_TABLE_FILE"; then
    echo "[OK] Twoja karta (0x$DEVICE_ID) jest już na liście wspieranych."
else
    echo "[MOD] Dodawanie wsparcia dla Pascala (0x$DEVICE_ID)..."
    
    # Znajdujemy miejsce po definicji jakiegoś ID (np. 1cb1, które było w twoim skrypcie)
    # Jeśli 1cb1 nie istnieje, dodajemy na początku tabeli urządzeń.
    # Używamy flagi 'i', aby ignorować wielkość liter.
    
    if grep -q "0x1cb1" "$PCI_TABLE_FILE"; then
        sed -i "/0x1cb1/a \    { 0x10de, 0x$DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }," "$PCI_TABLE_FILE"
    else
        # Jeśli nie ma 1cb1, wstawiamy po nagłówku tabeli
        sed -i "/nvidia_pci_device_id_table\[\] = {/a \    { 0x10de, 0x$DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }," "$PCI_TABLE_FILE"
    fi
    echo "[OK] Karta dopisana do tabeli."
fi

# 5. KLUCZOWY FIX: Wyłączenie wymuszania GSP (Pascal nie ma GSP!)
# W nowych sterownikach sterownik próbuje użyć procesora GSP, co na Pascalu kończy się błędem.
echo "[MOD] Patchowanie domyślnych ustawień GSP..."
OS_INTERFACE_FILE="$DRIVER_DIR/kernel/nvidia/os-interface.c"
if [ -f "$OS_INTERFACE_FILE" ]; then
    # To jest "brudny" hack, ale czasem konieczny: wymuszenie wyłączenia GSP w kodzie
    # Alternatywnie: trzeba dodać parametr 'NVreg_EnableGpuFirmware=0' przy ładowaniu modułu.
    echo "Pamiętaj: Po instalacji musisz dodać 'nvidia.NVreg_EnableGpuFirmware=0' do parametrów GRUB!"
fi

echo ""
echo "--- Patchowanie zakończone sukcesem! ---"
echo "Instrukcja dalszego postępowania:"
echo "1. Wejdź do $DRIVER_DIR"
echo "2. Uruchom: sudo ./nvidia-installer --no-cc-version-check"
echo "3. Po instalacji zrób: echo 'options nvidia NVreg_EnableGpuFirmware=0' | sudo tee /etc/modprobe.d/nvidia-gsp.conf"
echo "4. Zrestartuj komputer."
