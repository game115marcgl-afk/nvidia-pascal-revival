

# NVIDIA PASCAL REVIVAL - INSTRUKCJA OBSŁUGI

Ten projekt pozwala na zainstalowanie najnowszych sterowników NVIDIA (Seria 500+) na kartach graficznych **GTX z serii 10 (Pascal)**. Wszystko odbywa się automatycznie za pomocą jednego skryptu.

---

## KROK 1: Przygotowanie i Pobranie
Otwórz terminal na swoim pulpicie i wklej poniższe komendy, aby pobrać projekt:

```bash
git clone https://github.com/game115marcgl-afk/nvidia-pascal-revival
cd nvidia-pascal-revival
chmod +x build_pascal_driver.sh
```

---

##  KROK 2: Budowanie Twojego Sterownika
Teraz uruchomimy kreatora, który wykryje Twoją kartę, pobierze sterownik od Nvidii i "wstrzyknie" do niego wsparcie dla Pascala oraz optymalizacje wydajności.

**Uruchom to polecenie:**
```bash
sudo ./build_pascal_driver.sh
```
*Skrypt skończy pracę, gdy zobaczysz napis "PROCES ZAKOŃCZONY SUKCESEM".*

---

##  KROK 3: Instalacja (Tryb Konsoli)
**UWAGA:** Sterownika nie można zainstalować, gdy widzisz pulpit. Musisz przejść do trybu tekstowego.

1.  Naciśnij na klawiaturze: **`CTRL + ALT + F3`**.
2.  Zaloguj się (podaj login i naciśnij Enter, potem hasło i Enter).
3.  **Wyłącz pulpit** (komenda zależy od Twojego systemu):
    *   *Linux Mint / Ubuntu:* `sudo service lightdm stop`
    *   *Pop!_OS / Debian:* `sudo service gdm stop`
4.  **Uruchom instalator**, który przed chwilą stworzyliśmy:
    ```bash
    sudo ./NVIDIA-Pascal-Revival-Source/nvidia-installer
    ```
5.  Podczas instalacji wybieraj zawsze **YES** (szczególnie przy pytaniu o DKMS i 32-bit libraries).

---

##  KROK 4: Finalizacja i Optymalizacja
Gdy instalator skończy, musisz odświeżyć system, aby zapamiętał nowe ustawienia GSP (brak czarnego ekranu):

```bash
sudo update-initramfs -u
sudo reboot
```

---

## KROK 5: Sprawdzenie
Po ponownym uruchomieniu komputera sprawdź, czy Twoja karta żyje na nowym sterowniku:
1.  Otwórz terminal.
2.  Wpisz: **`nvidia-smi`**
3.  Powinieneś zobaczyć swoją kartę (np. GTX 1050) oraz wersję sterownika 570/590!

---


> ###  Co zyskałeś dzięki temu projektowi?
> *   **Najnowsze biblioteki Vulkan** dla lepszej wydajności w nowych grach.
> *   **Odblokowane Coolbits**: Możesz teraz sterować wentylatorami i podkręcać kartę w ustawieniach NVIDIA.
> *   **Tryb Max Performance**: Karta nie będzie już niepotrzebnie zwalniać pulpitu.
> *   **Brak błędu GSP**: Skrypt automatycznie naprawił problem czarnego ekranu, który występuje w nowych sterownikach na starych kartach.

---


