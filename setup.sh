#!/bin/bash

# Marcel's NVIDIA Pascal Revival - System Check v1.2
# Licencja: MIT

# Kolory dla lepszej czytelności
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}------------------------------------------${NC}"
echo -e "${YELLOW}Inicjalizacja Marcel's NVIDIA Optimizer...${NC}"
echo -e "${YELLOW}------------------------------------------${NC}"

# 1. Sprawdzenie uprawnień root
if [ "$EUID" -ne 0 ]; then 
  echo -e "${RED}[BŁĄD] Uruchom skrypt przez sudo: sudo ./setup.sh${NC}"
  exit 1
fi

# 2. Wykrywanie karty graficznej za pomocą ID (bardziej niezawodne niż nazwa tekstowa)
# 10de = NVIDIA, 1b00-1cff = Zakres architektury Pascal (GTX 10xx, Quadro P, itp.)
GPU_INFO=$(lspci -nn | grep -i "VGA\|3D" | grep "10de")
PASCAL_DETECTED=$(echo "$GPU_INFO" | grep -E "1b[0-8]|1c[0-8]")

if [ -z "$GPU_INFO" ]; then
  echo -e "${RED}[BŁĄD] Nie znaleziono żadnej karty NVIDIA!${NC}"
elif [ -z "$PASCAL_DETECTED" ]; then
  echo -e "${YELLOW}[OSTRZEŻENIE] Wykryto kartę NVIDIA, ale może to nie być seria Pascal.${NC}"
  echo -e "Wykryty sprzęt: $GPU_INFO"
else
  echo -e "${GREEN}[OK] Wykryto kartę z serii Pascal:${NC}"
  echo "    $PASCAL_DETECTED"
fi

# 3. Sprawdzanie systemu
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_TYPE=$ID
else
    OS_TYPE="unknown"
fi

echo -e "\nSystem operacyjny: ${GREEN}$NAME $VERSION${NC}"

# Definicja zależności w zależności od dystrybucji
case "$OS_TYPE" in
    fedora)
        DEPENDENCIES=(gcc make dkms kernel-devel elfutils-libelf-devel libglvnd-devel)
        CHECK_CMD="rpm -q"
        INSTALL_SUGGESTION="sudo dnf install"
        ;;
    ubuntu|debian|pop|linuxmint)
        DEPENDENCIES=(gcc make dkms build-essential "linux-headers-$(uname -r)" libglvnd-dev pkg-config)
        CHECK_CMD="dpkg -s"
        INSTALL_SUGGESTION="sudo apt install"
        ;;
    arch|manjaro)
        DEPENDENCIES=(base-devel dkms "linux-headers" libglvnd)
        CHECK_CMD="pacman -Qs"
        INSTALL_SUGGESTION="sudo pacman -S"
        ;;
    *)
        echo -e "${YELLOW}[!] Nieobsługiwana dystrybucja do automatycznego sprawdzenia.${NC}"
        DEPENDENCIES=(gcc make dkms)
        CHECK_CMD="which"
        INSTALL_SUGGESTION="zainstaluj ręcznie"
        ;;
esac

echo -e "Sprawdzanie narzędzi kompilacji..."
MISSING_PKGS=()

for pkg in "${DEPENDENCIES[@]}"; do
    if $CHECK_CMD "$pkg" &> /dev/null; then
        echo -e "  [${GREEN}+${NC}] $pkg"
    else
        echo -e "  [${RED}-${NC}] $pkg (BRAK)"
        MISSING_PKGS+=("$pkg")
    fi
done

# 4. Sprawdzenie konfliktów (Nouveau)
NOUVEAU_CHECK=$(lsmod | grep nouveau)
if [ ! -z "$NOUVEAU_CHECK" ]; then
    echo -e "\n${RED}[ALARM] Sterownik Nouveau jest załadowany!${NC}"
    echo "Przed instalacją sterownika NVIDIA musisz go zablokować (blacklist)."
fi

# Podsumowanie
if [ ${#MISSING_PKGS[@]} -eq 0 ]; then
    echo -e "\n${GREEN}[SUKCES] System jest gotowy do patchowania i instalacji.${NC}"
else
    echo -e "\n${YELLOW}[INFO] Aby kontynuować, zainstaluj brakujące pakiety:${NC}"
    echo -e "Komenda: ${GREEN}$INSTALL_SUGGESTION ${MISSING_PKGS[*]}${NC}"
fi

