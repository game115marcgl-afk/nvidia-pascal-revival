#!/bin/bash
# Marcel's NVIDIA Pascal Revival Patcher v1.0
# Licencja: MIT

# Twoje ID karty GTX 1050 (prawdopodobnie 1c81, ale skrypt to zweryfikuje)
DEVICE_ID=$(lspci -n | grep "10de" | cut -d':' -f4 | cut -d' ' -f1 | head -n 1)

echo "--- Inicjalizacja Marcel's Pascal Patcher ---"
echo "Wykryte ID Twojej karty: $DEVICE_ID"

# Ścieżka do rozpakowanego sterownika
DRIVER_DIR="NVIDIA-Linux-x86_64-570.124.04"

if [ ! -d "$DRIVER_DIR" ]; then
    echo "[BŁĄD] Nie znaleziono folderu $DRIVER_DIR. Rozpakuj sterownik najpierw!"
    exit 1
fi

echo "Patchowanie tabeli PCI w kernelu..."

# Lokalizacja pliku z listą wspieranych kart
PCI_TABLE_FILE="$DRIVER_DIR/kernel/nvidia/nv-pci-table.c"

# Sprawdzamy, czy nasze ID już tam jest, jeśli nie - dopisujemy
if grep -q "$DEVICE_ID" "$PCI_TABLE_FILE"; then
    echo "[OK] Twoja karta jest już na liście wspieranych."
else
    echo "[MOD] Dodawanie wsparcia dla Pascala ($DEVICE_ID) do tabeli..."
    # Wstrzyknięcie ID Twojej karty do kodu źródłowego sterownika
    sed -i "/{ 0x10de, 0x1cb1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },/a \    { 0x10de, 0x$DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }," "$PCI_TABLE_FILE"
    echo "[OK] Karta dopisana pomyślnie."
fi

echo "--- Patchowanie zakończone. Możesz teraz uruchomić ./nvidia-installer ---"
