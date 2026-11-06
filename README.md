# Auto Junk Disassembler

Modyfikacja do gry Wiedźmin 3: Dziki Gon (Next-Gen / Remastered 4.04+).

Automatycznie rozbiera wybrane typy przedmiotów na składniki rzemieślnicze bezpośrednio po ich zebraniu ze skrzyń, worków, beczek lub ciał potworów i ludzi. Działa analogicznie do wizyty u kowala lub płatnerza, lecz bez konieczności przerywania eksploracji.

Wszystkie parametry modu można dostosować w menu gry (Opcje > Menu Modyfikacji > Auto Junk Disassembler).

---

## Główne funkcje

* **Automatyczny demontaż śmieci:** Przedmioty z kategorii Junk (wilcze i niedźwiedzie skóry, świeczniki, srebrne naczynia, liny, kubki) natychmiast zamieniają się w surowce (skóry, srebro, żelazo, meteoryt).
* **Filtrowanie rzadkości ekwipunku:** Osobne progi jakości dla broni oraz pancerzy:
  * Wyłączone (0)
  * Tylko pospolite (1, szare)
  * Do wyśmienitych (2, niebieskie)
  * Do magicznych (3, żółte)
  * Do reliktów (4, pomarańczowe)
* **Bezpieczeństwo wartościowych przedmiotów:**
  * Stała ochrona rynsztunku wiedźmińskiego (zielone przedmioty zestawowe nigdy nie zostaną zniszczone).
  * Ochrona reliktów (możliwość zablokowania rozbierania reliktów niezależnie od progu jakości).
  * Całkowite pomijanie przedmiotów fabularnych (Quest), trofeów, książek, listów, narzędzi naprawczych oraz rzędu końskiego.
  * Pomijanie skrytki gracza (Schowek) oraz stojaków w Corvo Bianco.
* **Odzyskiwanie ulepszeń:** Automatyczny zwrot osadzonych run i glifów z rozbieranego uzbrojenia bezpośrednio do ekwipunku Geralta.
* **Opcjonalna opłata rzemieślnicza:** Możliwość włączenia pobierania standardowej opłaty w koronach, identycznie jak u kowala w grze. Jeśli Geralt nie posiada wystarczającej liczby koron na opłatę, przedmiot pozostaje w całości.
* **Minimalny próg koron:** Suwak (od 0 do 10 000 koron, skok co 500) zabezpieczający oszczędności gracza. Rozbiór następuje tylko wtedy, gdy stan konta Geralta jest równy lub wyższy od ustawionego progu.
* **Graficzne i skonsolidowane powiadomienia:** Graficzny feed w lewym dolnym rogu ekranu (ikona surowca i łączna liczba w kafelku HUD) oraz zbiorczy komunikat. Przy zebraniu wielu przedmiotów naraz powiadomienie jest łączone w jedno, bez zaśmiecania ekranu.

---

## Opcje w menu gry

Menu znajduje się w: `Opcje > Mody > Auto Junk Disassembler`.

| Opcja | Domyślnie | Opis |
|---|---|---|
| Aktywacja modu | Włączone | Główny przełącznik działania modyfikacji. |
| Rozbieraj śmieci (Junk) | Włączone | Rozbiera przedmioty użytkowe i śmieci (skóry, naczynia, itp.). |
| Maksymalna rzadkość broni | Pospolite (1) | Maksymalny tier broni podlegający rozbiórce. |
| Maksymalna rzadkość pancerzy | Pospolite (1) | Maksymalny tier pancerzy podlegający rozbiórce. |
| Ochrona: Rynsztunek wiedźmiński | Włączone | Chroni wszystkie elementy zestawów wiedźmińskich. |
| Ochrona: Przedmioty reliktowe | Włączone | Zabezpiecza relikty przed przypadkowym zniszczeniem. |
| Odzyskuj osadzone runy i glify | Włączone | Zwraca zamontowane ulepszenia do ekwipunku. |
| Pobieraj korony za rozbiór | Wyłączone | Pobiera opłatę w koronach zgodną z cennikiem kowalskim. |
| Minimalna liczba koron do rozbioru | 0 | Suwak limitu portfela (0-10000, co 500). Poniżej limitu rozbiór jest wstrzymany. |
| Powiadomienia o rozbiorze | Włączone | Przełącznik powiadomień graficznych i tekstowych o otrzymanych surowcach. |

---

## Instalacja

1. Pobierz zawartość repozytorium.
2. Skopiuj folder `modAutoJunkDisassembler` do katalogu `Mods` w folderze gry:
   ```text
   The Witcher 3 Wild Hunt/Mods/modAutoJunkDisassembler
   ```
3. Skopiuj plik z folderu `bin` do konfiguracji menu gry:
   ```text
   The Witcher 3 Wild Hunt/bin/config/r4game/user_config_matrix/pc/modAutoJunkDisassembler.xml
   ```
4. Jeżeli używasz innych modyfikacji modyfikujących skrypty gry, uruchom program **Script Merger** i połącz ewentualne konflikty.
5. Uruchom grę i dostosuj opcje w menu głównym.

---

## Kompatybilność

* Działa z wersją **Wiedźmin 3: Dziki Gon Remastered / Next-Gen (v4.04+)**.
* Modyfikacja ingeruje wyłącznie w wywołanie transferu przedmiotu w pliku `inventoryComponent.ws`, co minimalizuje ryzyko kolizji z innymi modami.
* W pełni kompatybilna z modami do interfejsu ekwipunku oraz modyfikacjami lootowania.
