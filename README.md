
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

