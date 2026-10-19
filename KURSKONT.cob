       IDENTIFICATION DIVISION.
       PROGRAM-ID. KURSKONT.
       AUTHOR. Tom Kramer.
       DATE-WRITTEN. 2026-10-19.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  FORDERUNGSTABELLE.
           05 TEMP-FORDERUNG OCCURS 3 TIMES.
              10 TEMP-FORDERUNGSNUMMER PIC 9(6).
              10 TEMP-TEILNEHMERNAME PIC X(30).
              10 TEMP-KURSGEBUEHR PIC 9(5)V99 COMP-3.
              10 TEMP-ZAHLUNGSUMME PIC 9(6)V99 COMP-3.
              10 TEMP-RESTBETRAG PIC S9(6)V99 COMP-3.
              10 TEMP-STATUS PIC X(8).
               
       01 FORDERUNG.
           05 FORDERUNGSNUMMER PIC 9(6) VALUE 1.
           05 TEILNEHMERNAME PIC X(30)
               VALUE "Mara Beispiel".
           05 KURSGEBUEHR PIC 9(5)V99 COMP-3 VALUE 150.
           05 ZAHLUNGSBETRAG PIC 9(5)V99 COMP-3 VALUE 0.
           05 ZAHLUNGSUMME PIC 9(6)V99 COMP-3 VALUE 0.
           05 RESTBETRAG PIC S9(6)V99 COMP-3 VALUE 0.
           05 FORDERUNGSSTATUS PIC X(8) VALUE SPACES.

       01 KURSGEBUEHR-ANZEIGE PIC ZZZZ9.99.
       01 RESTBETRAG-ANZEIGE PIC ------9.99.
       01 ZAHLUNGSUMME-ANZEIGE PIC ZZZZZ9.99.

       01 ZAHLUNGSBETRAG-EINGABE PIC X(80) VALUE SPACES.
       01 ANZAHLUNGEN-EINGABE PIC X(80) VALUE SPACES.
       01 ZAHLUNGSANZAHL PIC 9 VALUE 0.
       01 ZAHLUNGSZAEHLER PIC 9(2) VALUE 0.

       01 EINGABE-STATUS PIC 9 VALUE 0.
           88 EINGABE-GUELTIG VALUE 1.

       01 FORDERUNGSANZAHL PIC 9 VALUE 2.
       01 FORDERUNGSZAEHLER PIC 9 VALUE 0.

       PROCEDURE DIVISION.
           INITIALIZE FORDERUNGSTABELLE

           MOVE 1 TO TEMP-FORDERUNGSNUMMER(1)
           MOVE "Mara Beispiel" TO TEMP-TEILNEHMERNAME(1)
           MOVE 150 TO TEMP-KURSGEBUEHR(1)

           MOVE 2 TO TEMP-FORDERUNGSNUMMER(2)
           MOVE "Alex Muster" TO TEMP-TEILNEHMERNAME(2)
           MOVE 200 TO TEMP-KURSGEBUEHR(2)

           PERFORM VARYING FORDERUNGSZAEHLER FROM 1 BY 1
               UNTIL FORDERUNGSZAEHLER > FORDERUNGSANZAHL

               INITIALIZE FORDERUNG

               MOVE TEMP-FORDERUNGSNUMMER(FORDERUNGSZAEHLER)
                   TO FORDERUNGSNUMMER
               MOVE TEMP-TEILNEHMERNAME(FORDERUNGSZAEHLER)
                   TO TEILNEHMERNAME
               MOVE TEMP-KURSGEBUEHR(FORDERUNGSZAEHLER)
                   TO KURSGEBUEHR

               PERFORM FORDERUNG-ABRECHNEN
               MOVE ZAHLUNGSUMME
                   TO TEMP-ZAHLUNGSUMME(FORDERUNGSZAEHLER)
               MOVE RESTBETRAG
                   TO TEMP-RESTBETRAG(FORDERUNGSZAEHLER)
               MOVE FORDERUNGSSTATUS
                   TO TEMP-STATUS(FORDERUNGSZAEHLER)
           END-PERFORM

           PERFORM ABSCHLUSS-ANZEIGEN

           STOP RUN.

       ANZAHLUNGEN-EINLESEN.
           MOVE 0 TO EINGABE-STATUS

           PERFORM UNTIL EINGABE-GUELTIG
               DISPLAY "Anzahl der Zahlungen (0-9) eingeben"
               ACCEPT ANZAHLUNGEN-EINGABE

               IF FUNCTION LENGTH(
                   FUNCTION TRIM(ANZAHLUNGEN-EINGABE)) = 1

                   IF ANZAHLUNGEN-EINGABE(1:1) IS NUMERIC
                       COMPUTE ZAHLUNGSANZAHL =
                           FUNCTION NUMVAL(
                               ANZAHLUNGEN-EINGABE(1:1))
                       SET EINGABE-GUELTIG TO TRUE
                   ELSE
                       DISPLAY "Genau eine Ziffer erwartet."
                   END-IF
               ELSE
                   DISPLAY "Genau ein Zeichen erforderlich."
               END-IF
           END-PERFORM.

       ZAHLUNG-EINLESEN.
           MOVE 0 TO EINGABE-STATUS

           PERFORM UNTIL EINGABE-GUELTIG
               DISPLAY "Zahlung: 7 Ziffern in Cent eingeben"
               ACCEPT ZAHLUNGSBETRAG-EINGABE

               IF FUNCTION LENGTH(
                   FUNCTION TRIM(ZAHLUNGSBETRAG-EINGABE)) = 7

                   IF ZAHLUNGSBETRAG-EINGABE(1:7) IS NUMERIC
                       COMPUTE ZAHLUNGSBETRAG =
                           FUNCTION NUMVAL(
                               ZAHLUNGSBETRAG-EINGABE(1:7)) / 100

                       IF ZAHLUNGSBETRAG > 0
                           SET EINGABE-GUELTIG TO TRUE
                       ELSE
                           DISPLAY "Zahlung muss positiv sein."
                       END-IF
                   ELSE
                       DISPLAY "Genau 7 Ziffern erwartet."
                   END-IF
               ELSE
                   DISPLAY "Genau 7 Zeichen erforderlich."
               END-IF
           END-PERFORM.

       FORDERUNG-BERECHNEN.
           COMPUTE RESTBETRAG = KURSGEBUEHR - ZAHLUNGSUMME

           EVALUATE TRUE
               WHEN RESTBETRAG > 0
                   MOVE "OFFEN" TO FORDERUNGSSTATUS
               WHEN RESTBETRAG = 0
                   MOVE "BEZAHLT" TO FORDERUNGSSTATUS
               WHEN OTHER
                   MOVE "GUTHABEN" TO FORDERUNGSSTATUS
           END-EVALUATE.

       FORDERUNG-ABRECHNEN.
           DISPLAY "Kurskontodaten:"
           DISPLAY "-------------------"
           DISPLAY "Forderungsnummer: " FORDERUNGSNUMMER
           DISPLAY "Teilnehmername: " TEILNEHMERNAME

           MOVE KURSGEBUEHR TO KURSGEBUEHR-ANZEIGE
           DISPLAY "Kursgebuehr: " KURSGEBUEHR-ANZEIGE " EUR"

           PERFORM ANZAHLUNGEN-EINLESEN

           MOVE 0 TO ZAHLUNGSUMME
           PERFORM VARYING ZAHLUNGSZAEHLER FROM 1 BY 1
               UNTIL ZAHLUNGSZAEHLER > ZAHLUNGSANZAHL

               DISPLAY "Zahlung Nr.: " ZAHLUNGSZAEHLER
               PERFORM ZAHLUNG-EINLESEN
               ADD ZAHLUNGSBETRAG TO ZAHLUNGSUMME
           END-PERFORM

           PERFORM FORDERUNG-BERECHNEN

           MOVE ZAHLUNGSUMME TO ZAHLUNGSUMME-ANZEIGE
           MOVE RESTBETRAG TO RESTBETRAG-ANZEIGE

           DISPLAY "Zahlungssumme: "
               ZAHLUNGSUMME-ANZEIGE " EUR"
           DISPLAY "Forderungsstatus: " FORDERUNGSSTATUS
           DISPLAY "Restbetrag: " RESTBETRAG-ANZEIGE " EUR".

       ABSCHLUSS-ANZEIGEN.
           DISPLAY "=== Abschlussuebersicht ==="

           PERFORM VARYING FORDERUNGSZAEHLER FROM 1 BY 1
               UNTIL FORDERUNGSZAEHLER > FORDERUNGSANZAHL

               MOVE TEMP-RESTBETRAG(FORDERUNGSZAEHLER)
                   TO RESTBETRAG-ANZEIGE

               DISPLAY "Forderung: "
                   TEMP-FORDERUNGSNUMMER(FORDERUNGSZAEHLER)
               DISPLAY "Name: "
                   TEMP-TEILNEHMERNAME(FORDERUNGSZAEHLER)
               DISPLAY "Status: "
                   TEMP-STATUS(FORDERUNGSZAEHLER)
               DISPLAY "Restbetrag: "
                   RESTBETRAG-ANZEIGE " EUR"
           END-PERFORM.


