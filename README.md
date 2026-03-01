# NVIDIA Pascal Revival - Marcel's Edition (v590)

### 🚀 Cel projektu
Projekt ma na celu przedłużenie życia kart graficznych opartych na architekturze **NVIDIA Pascal** (np. GTX 1050) poprzez adaptację i optymalizację nowszych sterowników serii **590** dla systemu Linux Mint.

### ✨ Główne założenia:
* **Wsparcie 240Hz**: Optymalizacja pod monitory o wysokim odświeżaniu (np. iiyama).
* **Wbudowane Coolbits**: Automatyczne odblokowanie kontroli wentylatorów i podkręcania.
* **Power Management**: Wymuszenie trybu wysokiej wydajności (PowerMizer).
* **Legacy Support**: Walka z przedwczesnym kończeniem wsparcia dla starszych GPU.

### 🛠️ Status prac:
- [x] Wybór licencji (MIT)
- [ ] Stworzenie skryptów instalacyjnych (In progress)
- [ ] Testy na maszynie wirtualnej (VM)
- [ ] Pierwsza wersja Alpha
## 🛠️ Instrukcja uruchomienia (Wersja BETA 0.1)

> **⚠️ UWAGA:** To jest wersja **BETA**. Projekt jest w fazie intensywnych testów na architekturze Pascal. Używasz na własne ryzyko!

### Krok 1: Przygotowanie środowiska
Upewnij się, że masz zainstalowane niezbędne narzędzia do budowania modułów jądra:
- Na Linux Mint: `sudo apt install build-essential dkms`
- Na Fedora: `sudo dnf install kernel-devel gcc make`

### Krok 2: Pobranie oficjalnego instalatora
Obecnie testujemy na bazie wersji sterownika: **570.124.04** (Baza pod wersję Marcel-590).
```bash
wget [https://us.download.nvidia.com/XFree86/Linux-x86_64/570.124.04/NVIDIA-Linux-x86_64-570.124.04.run](https://us.download.nvidia.com/XFree86/Linux-x86_64/570.124.04/NVIDIA-Linux-x86_64-570.124.04.run)
chmod +x NVIDIA-Linux-x86_64-570.124.04.run
./NVIDIA-Linux-x86_64-570.124.04.run -x
### ⚠️ Ostrzeżenie
Projekt jest w fazie eksperymentalnej. Używasz go na własną odpowiedzialność. Zawsze rób kopię zapasową systemu przed instalacją sterowników graficznych.
