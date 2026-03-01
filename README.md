
# NVIDIA Pascal Revival (Series 590+)
Przedłużamy życie legendarnym kartom z serii GTX 10 (Pascal) na systemie Linux.
Cel projektu
NVIDIA oficjalnie kończy wsparcie "Game Ready" dla architektury Pascal wraz z gałęzią sterowników 590. Ten projekt ma na celu adaptację najnowszych sterowników dla starszych GPU, optymalizację ich pod kątem nowoczesnych monitorów oraz odblokowanie ukrytych funkcji zwiększających wydajność.
Kluczowe funkcje (Marcel's Optimizer):
Wsparcie 240Hz+: Optymalizacja synchronizacji dla monitorów o wysokim odświeżeniu.
Auto-Coolbits: Automatyczne odblokowanie kontroli wentylatorów i overclockingu w Panelu NVIDIA.
Maximum Performance: Wymuszenie agresywnego trybu PowerMizer (zapobieganie spadkom taktowania).
GSP Fix: Skrypt automatycznie wyłącza GSP Firmware, który nie jest wspierany przez serię 10xx, a który powoduje błędy w nowych sterownikach.


---

# 📜 INSTRUKCJA INSTALACJI (KROK PO KROKU)

### ⚠️ ZANIM ZACZNIESZ:
Zrób kopię zapasową systemu (np. programem **Timeshift**). Jeśli coś pójdzie nie tak, kopia pozwoli Ci wrócić do sprawnych sterowników w 5 minut.

---

## 1️⃣ ETAP: Przygotowanie systemu
Wklej te komendy do terminala, aby zainstalować niezbędne narzędzia:

```bash
sudo apt update
sudo apt install build-essential dkms git wget -y
```

Następnie pobierz pliki projektu:
```bash
git clone https://github.com/game115marcgl-afk/nvidia-pascal-revival
cd nvidia-pascal-revival
chmod +x *.sh
```

---

## 2️⃣ ETAP: Pobranie i wypakowanie sterownika
Pobieramy bazę sterownika (wersja 570), którą przerobimy na wersję dla Twojego Pascala:

```bash
wget https://us.download.nvidia.com/XFree86/Linux-x86_64/570.124.04/NVIDIA-Linux-x86_64-570.124.04.run
chmod +x NVIDIA-Linux-x86_64-570.124.04.run
./NVIDIA-Linux-x86_64-570.124.04.run -x
```

---

## 3️⃣ ETAP: Modyfikacja (Patchowanie)
Teraz uruchamiamy mój skrypt, który dopisze Twoją kartę do listy wspieranych urządzeń:

```bash
sudo ./patch_nvidia.sh
```

---

## 4️⃣ ETAP: Instalacja (Wymaga wyłączenia pulpitu)
**To jest najtrudniejszy krok. Przeczytaj go do końca zanim zaczniesz!**

1. Naciśnij klawisze: **`CTRL + ALT + F3`** (pulpit zniknie, zobaczysz tekstową konsolę).
2. Zaloguj się (wpisz swój login i naciśnij Enter, potem hasło i Enter).
3. Wpisz komendę wyłączającą grafikę:
   ```bash
   sudo service lightdm stop
   ```
4. Wejdź do folderu ze sterownikiem i go zainstaluj:
   ```bash
   cd NVIDIA-Linux-x86_64-570.124.04
   sudo ./nvidia-installer --no-cc-version-check
   ```
5. Podczas instalacji wybieraj **YES** (szczególnie przy pytaniu o DKMS).

---

## 5️⃣ ETAP: Krytyczna poprawka (BEZ TEGO SYSTEM NIE WSTanie)
Karty Pascal (seria 10) nie obsługują nowej funkcji GSP. Musisz ją wyłączyć przed restartem! 

**Będąc nadal w czarnej konsoli, wpisz:**

```bash
echo "options nvidia NVreg_EnableGpuFirmware=0" | sudo tee /etc/modprobe.d/nvidia-gsp.conf
sudo update-initramfs -u
```

---

## 6️⃣ ETAP: Finał
Teraz możesz bezpiecznie zrestartować komputer:

```bash
sudo reboot
```

Po ponownym uruchomieniu sprawdź, czy wszystko działa, wpisując w terminalu:
**`nvidia-smi`**

---

### 💡 CO ZROBIĆ, GDYBY BYŁ CZARNY EKRAN?
Jeśli po restarcie nie widzisz pulpitu:
1. Naciśnij **`CTRL + ALT + F3`**.
2. Zaloguj się.
3. Wpisz: `sudo apt remove --purge nvidia*` – to usunie sterownik i pozwoli Ci wrócić do pulpitu, aby spróbować ponownie.

---
*Instrukcja stworzona dla projektu: **NVIDIA Pascal Revival***
