
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

KROK PIERWSZY: Przygotowanie Systemu
Musisz zainstalować narzędzia, które pozwolą zbudować sterownik.
Wpisz w terminalu (Linux Mint / Ubuntu / Debian):
code
Bash
sudo apt update && sudo apt install build-essential dkms git -y
Następnie pobierz projekt i sprawdź kompatybilność:
code
Bash
git clone https://github.com/game115marcgl-afk/nvidia-pascal-revival
cd nvidia-pascal-revival
chmod +x check_system.sh
sudo ./check_system.sh
2️⃣ KROK DRUGI: Pobranie i Rozpakowanie Bazy
Pobieramy oficjalny sterownik NVIDIA, który będziemy modyfikować.
code
Bash
wget https://us.download.nvidia.com/XFree86/Linux-x86_64/570.124.04/NVIDIA-Linux-x86_64-570.124.04.run
chmod +x NVIDIA-Linux-x86_64-570.124.04.run
./NVIDIA-Linux-x86_64-570.124.04.run -x
3️⃣ KROK TRZECI: Patchowanie (Marcel's Patcher)
To najważniejszy moment – dodajemy wsparcie dla Twojej karty do kodu sterownika.
code
Bash
chmod +x patch_nvidia.sh
sudo ./patch_nvidia.sh
4️⃣ KROK CZWARTY: Instalacja w trybie TTY
Sterownika nie da się zainstalować, gdy pulpit jest włączony.
Naciśnij CTRL + ALT + F3 (przejdziesz do czarnego ekranu logowania).
Zaloguj się swoim loginem i hasłem.
Wyłącz interfejs graficzny:
code
Bash
sudo service lightdm stop
Wejdź do folderu sterownika i zacznij instalację:
code

 KONIEC!
Po restarcie wpisz nvidia-smi, aby zobaczyć swoją kartę na nowym sterowniku!

Bash
cd NVIDIA-Linux-x86_64-570.124.04
sudo ./nvidia-installer --no-cc-version-check
5️⃣ KROK PIĄTY: Krytyczna poprawka GSP (WAŻNE!)
Karty Pascal NIE OBSŁUGUJĄ technologii GSP. Musisz ją wyłączyć, inaczej system nie wystartuje!
Po zakończeniu instalacji, wpisz w konsoli:
code
Bash
echo "options nvidia NVreg_EnableGpuFirmware=0" | sudo tee /etc/modprobe.d/nvidia-gsp.conf
sudo update-initramfs -u
sudo reboot
