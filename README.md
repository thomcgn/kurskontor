# KursKontor

Ein COBOL-Lernprojekt zur Abrechnung von Kursgebühren eines fiktiven
Bildungsträgers.

Das Programm erfasst Zahlungen über die Konsole, summiert sie und
berechnet den offenen Betrag oder ein Guthaben.

## Projektziel

KursKontor entsteht schrittweise anhand eines fiktiven Kundenauftrags
mit Lasten- und Pflichtenheft.

Dabei werden grundlegende COBOL-Konzepte praktisch erarbeitet:
Datenbeschreibungen, Dezimalarithmetik, Eingabeprüfung, Schleifen
und die Strukturierung des Programms in Absätze.

## Aktueller Funktionsumfang

- Eine fest hinterlegte Forderung über 150 Euro
- Eingabe der Zahlungsanzahl von 0 bis 9
- Erfassung einzelner Zahlungen als siebenstellige Centbeträge
- Prüfung von Eingabelänge, Ziffern und positivem Zahlungsbetrag
- Erneute Abfrage bei ungültiger Eingabe
- Summierung aller erfassten Zahlungen
- Berechnung des Restbetrags
- Ermittlung des Forderungsstatus:
  - `OFFEN`: Restbetrag größer als null
  - `BEZAHLT`: Restbetrag gleich null
  - `GUTHABEN`: Restbetrag kleiner als null
- Formatierte Ausgabe der Geldbeträge

## Voraussetzungen

- GnuCOBOL, entwickelt mit Version 3.2
- Alternativ eine Docker-Umgebung mit installiertem GnuCOBOL

Der Quelltext verwendet COBOL Fixed Format.

## Kompilieren und starten

Im Projektverzeichnis mit lokal installiertem GnuCOBOL:

```bash
cobc -x -fixed -o kurskont KURSKONT.cob
./kurskont
```

Bei Verwendung von Docker müssen die Befehle innerhalb des Containers
im eingebundenen Projektverzeichnis ausgeführt werden.

## Bedienung

Zuerst wird die Anzahl der Zahlungen abgefragt. `0` bedeutet, dass
keine Zahlung erfasst wird.

Einzelzahlungen werden als genau sieben Ziffern in Cent eingegeben,
ohne Dezimaltrennzeichen oder Währungszeichen:

| Eingabe | Betrag |
|---|---:|
| `0000001` | 0,01 Euro |
| `0002500` | 25,00 Euro |
| `0005000` | 50,00 Euro |
| `0015000` | 150,00 Euro |

Eine einzelne Zahlung von null Euro ist nicht zulässig.

### Beispiel

Bei einer Kursgebühr von 150 Euro werden zwei Zahlungen erfasst:

```text
Anzahl der Zahlungen (0-9) eingeben
2
Zahlung Nr.: 01
Zahlung: 7 Ziffern in Cent eingeben
0005000
Zahlung Nr.: 02
Zahlung: 7 Ziffern in Cent eingeben
0002500
Zahlungssumme:     75.00 EUR
Forderungsstatus: OFFEN
Restbetrag:       75.00 EUR
```

Die genaue Ausrichtung hängt von den verwendeten Ausgabefeldern ab.
Geldbeträge werden derzeit mit Dezimalpunkt ausgegeben.

## Programmstruktur

| Absatz | Aufgabe |
|---|---|
| `ANZAHLUNGEN-EINLESEN` | Zahlungsanzahl einlesen und prüfen |
| `ZAHLUNG-EINLESEN` | Einzelzahlung einlesen und prüfen |
| `FORDERUNG-BERECHNEN` | Restbetrag und Status ermitteln |

Der Hauptablauf steuert die Aufrufe, summiert die Zahlungen
und gibt das Ergebnis aus.

## Verwendete COBOL-Konzepte

- Datengruppen mit den Ebenen `01` und `05`
- Datenbeschreibung mit `PIC`
- Dezimale Festkommafelder mit `V` und `COMP-3`
- Vorzeichenbehaftete Felder mit `S`
- Aufbereitete Ausgabefelder mit `Z` und gleitendem Minuszeichen
- Bedingungsnamen mit Ebene `88`
- `ACCEPT`, `DISPLAY` und `MOVE`
- Berechnungen mit `COMPUTE` und `ADD`
- Bedingungen mit `IF` und `EVALUATE TRUE`
- Schleifen mit `PERFORM UNTIL` und `PERFORM VARYING`
- Absatzaufrufe mit `PERFORM`
- Funktionen `TRIM`, `LENGTH` und `NUMVAL`
- Teilfeldzugriffe wie `(1:7)`

## Manuelle Prüffälle

Die Fälle jeweils in einem neuen Programmlauf ausführen:

| Anzahl | Zahlungen in Euro | Erwartetes Ergebnis |
|---:|---|---|
| 0 | keine | 150 Euro offen |
| 1 | 150 | bezahlt |
| 2 | 50 und 25 | 75 Euro offen |
| 1 | 170 | 20 Euro Guthaben |

Zusätzlich werden ungültige Eingaben wie `A`, eine mehrstellige
Zahlungsanzahl, falsche Betragslängen und Nullzahlungen geprüft.

## Grenzen des aktuellen Stands

- Es wird nur eine fest hinterlegte Forderung verarbeitet.
- Daten bleiben nur während des Programmlaufs im Speicher.
- Es gibt noch keine Dateiverarbeitung.
- Die Konsoleneingabe verwendet feste Textpuffer mit 80 Zeichen.
  Beliebig lange Eingabezeilen werden nicht vollständig abgesichert.
- Ein Ratenplan, Fälligkeiten und Zahlungsverzug werden nicht verwaltet.

Das Projekt verwendet ausschließlich fiktive Daten und ist eine
Lernanwendung, keine produktive Finanzbuchhaltung.

## Geplante Erweiterungen

- Mehrere Forderungen mit `OCCURS` verwalten
- Forderungen und Zahlungen aus Dateien einlesen
- Zahlungen über Forderungsnummern zuordnen
- Fehlerprotokoll und Abrechnungsbericht erzeugen
- Datei- und Rechenfehler kontrolliert behandeln

## Autor

Tom Kramer
