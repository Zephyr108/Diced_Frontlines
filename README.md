# 🎲 DICED FRONTLINES

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ 🎲  D I C E D   F R O N T L I N E S  🎲                   ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

**Roguelike turowy oparty na rzutach kością – walcz, rozwijaj się i podbijaj front!**

---

## 📖 Opis
**DICED FRONTLINES** to taktyczna gra roguelike stworzona w silniku **LOVE2D**, w której każda akcja – atak, obrona, użycie umiejętności – zależy od rzutu kością.  
Wybierz swoją klasę, staw czoła kolejnym falom przeciwników, ulepszaj ekwipunek i mierz się z potężnymi bossami co 5 bitew.

---

## ✨ Cechy gry
- 🎯 **System rzutów kością** – różne klasy mają inne typy kości (d6, d8, d12, d20...).
- ⚔ **Turowe walki** – gracz i wróg wykonują ruchy na zmianę.
- 🛒 **Sklep po każdej walce** – kupuj broń, zbroje, artefakty (a może i nowe kości).
- 👹 **Unikalne frakcje przeciwników** – nieumarli, demony, golemy mechaniczne.
- 🏆 **Bossowie co 5 walk** – każdy z własną mechaniką i wyższą trudnością.
- 🛡 **System ekwipunku** – modyfikatory rzutów, przerzuty i zmiana kości obrony.
- 🧪 **Mikstury i ulepszenia** – tymczasowe buffy i stały progres.

---

## 🕹 Klasy postaci
| Klasa         | Kość startowa | Opis |
|---------------|----------------|------|
| 🛡 **Wojownik**    | d12           | Stabilny balans ataku i obrony. |
| 🔮 **Mag**         | d8            | Silne umiejętności, słabsza obrona. |
| 🗡 **Złodziej**    | d6            | Szybkie ataki i wysoka inicjatywa. |
| 💢 **Barbarzyńca** | d20           | Potężne ciosy, ale chaotyczne. |
| 🪷 **Mnich**       | d1            | Minimalizm – wyzwanie dla weteranów. |

---

## 🛠 Instalacja i uruchomienie
**Wymagania:** [LOVE2D](https://love2d.org/) (11.x lub nowsza)

```bash
# Uruchomienie gry
love .
```

> 💡 Na Windows możesz też przeciągnąć folder na `love.exe` albo spakować projekt do `DICED_FRONTLINES.love`.

---

## 📂 Struktura projektu
```
DICED_FRONTLINES/
├── assets/         # Grafika, dźwięki, fonty
├── game/
│   ├── core/       # Logika gry (walka, gracz, wrogowie, kostki)
│   ├── data/       # Dane klas, przedmiotów, frakcji, bossów
│   ├── screens/    # Ekrany: menu, walka, sklep, game over
│   └── ui/         # Interfejs: log walki, panel statystyk, animacje kości
├── main.lua        # Główna pętla gry
└── README.md
```

---

## 🎮 Sterowanie (domyślne)
- **1-4** – wybór akcji/umiejętności
- **strzałki** – log walki
- **Esc** – pauza/wyjście do menu

---

## 📸 Zrzuty ekranu
![Menu gry](assets/screenshots/menu.png)
![Walka](assets/screenshots/battle.png)
![Sklep](assets/screenshots/shop.png)

---

## 🧠 Roadmap (w skrócie)
- [ ] Efekty statusów (krwawienie, zatrucie, ogłuszenie)
- [ ] Więcej frakcji (np. Lodowe Bestie, Kultyści)
- [ ] Rzadkie kości z modyfikatorami (np. *Cursed d20*, *Blessed d8*)
- [ ] Tryb Endless + Tablice wyników
- [ ] Lokalizacja EN/PL

---

## 📜 Licencja
Projekt dostępny na licencji **MIT**. Zobacz plik `LICENSE`.

---

## 🙌 Podziękowania
- Silnik: [LOVE2D](https://love2d.org/)
- Biblioteki: hump (gamestate), middleclass, i inne zgodnie z `game/`

> Jeśli gra Ci się podoba – ⭐ zostaw gwiazdkę i śledź rozwój!
