
# NVIDIA Pascal Revival (Series 590+)
Przedłużamy życie legendarnym kartom z serii GTX 10 (Pascal) na systemie Linux.
Cel projektu
NVIDIA oficjalnie kończy wsparcie "Game Ready" dla architektury Pascal wraz z gałęzią sterowników 590. Ten projekt ma na celu adaptację najnowszych sterowników dla starszych GPU, optymalizację ich pod kątem nowoczesnych monitorów oraz odblokowanie ukrytych funkcji zwiększających wydajność.
Kluczowe funkcje (Marcel's Optimizer):
Wsparcie 240Hz+: Optymalizacja synchronizacji dla monitorów o wysokim odświeżeniu.
Auto-Coolbits: Automatyczne odblokowanie kontroli wentylatorów i overclockingu w Panelu NVIDIA.
Maximum Performance: Wymuszenie agresywnego trybu PowerMizer (zapobieganie spadkom taktowania).
GSP Fix: Skrypt automatycznie wyłącza GSP Firmware, który nie jest wspierany przez serię 10xx, a który powoduje błędy w nowych sterownikach.
 Status prac:

Wybór licencji (MIT)

Skrypt weryfikacji systemu (check_system.sh)

Automatyczny patcher tabel PCI (In progress)

Testy stabilności na GTX 1050/1080 Ti

Pierwsza wersja Alpha (v0.1)
Instrukcja instalacji (Wersja BETA 0.1)
[!CAUTION]
⚠️ UWAGA: To jest wersja eksperymentalna. Ryzyko czarnego ekranu (Tty only). Zawsze rób kopię zapasową (np. Timeshift) przed uruchomieniem skryptów!

Krok 1: Przygotowanie systemu
Najpierw sprawdź, czy Twój system posiada wszystkie zależności:
code
Bash
git clone https://github.com/game115marcgl-afk/nvidia-pascal-revival
cd nvidia-pascal-revival
chmod +x check_system.sh
sudo ./check_system.sh
Krok 2: Pobranie bazy sterownika
Obecnie bazujemy na wersji 570.124.04 (będącej pomostem do serii 590).
code
Bash
wget https://us.download.nvidia.com/XFree86/Linux-x86_64/570.124.04/NVIDIA-Linux-x86_64-570.124.04.run
chmod +x NVIDIA-Linux-x86_64-570.124.04.run
./NVIDIA-Linux-x86_64-570.124.04.run -x
Krok 3: Patchowanie (Marcel's Patcher)
Wstrzyknij wsparcie dla swojej karty Pascal do plików instalatora:
code
Bash
chmod +x patch_nvidia.sh
sudo ./patch_nvidia.sh
Krok 4: Instalacja sterownika
Ważne: Instalację należy przeprowadzić przy wyłączonym serwerze graficznym (tryb TTY).
Naciśnij Ctrl + Alt + F3.
Zaloguj się i wpisz: sudo service lightdm stop (lub gdm, sddm).
Uruchom instalator:
code
Bash
cd NVIDIA-Linux-x86_64-570.124.04
sudo ./nvidia-installer --no-cc-version-check
