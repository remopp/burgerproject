## Test Plan

### Syfte och Omfattning
Denna testplan täcker de viktigaste funktionerna i projektet, inklusive kökssidan och order-appen, för att säkerställa att de fungerar korrekt. Målet är att verifiera att alla kritiska användarflöden är pålitliga och robusta.

### Testmål
- Säkerställa att användare kan göra beställningar via order-appen.
- Säkerställa att kökspersonalen kan se och hantera inkommande beställningar via köksvyn.

### Testmiljö
- Testerna körs i en lokal utvecklingsmiljö med en konfigurerad virtuell miljö.
- Databasanrop är mockade genom `unittest.mock` för att säkerställa att testerna är oberoende av externa system.
- Docker används för att säkerställa en likvärdig miljö och korrekt konfiguration.

### Testtyper
- **Enhetstester (Unit Tests)**: Testar individuella funktioner och metoder för att säkerställa korrekt funktion.
- **Integrationstester**: Säkerställa att olika komponenter av systemet fungerar tillsammans, t.ex. att order-appen och köksvyn integreras korrekt med databasen.

### Testmetoder
- Användning av `pytest` för att köra testerna.
- Mockning av databasanrop för att undvika beroenden på en faktisk databas under testningen.

### Testkriterier
- **Godkänt**: Alla funktioner fungerar som förväntat. Beställningar läggs till och visas korrekt, och alla användarinteraktioner bearbetas utan fel.
- **Underkänt**: Om någon endpoint inte returnerar rätt statuskod eller om data inte behandlas korrekt.

### Tester som ska utföras
- **Order App**:
  - Testar att en användare kan fylla i sitt namn, välja en burgare och anpassa ingredienser.
  - Kontrollera att beställningen lagras korrekt i databasen.
- **Köksvy**:
  - Testar att kökspersonalen kan se de beställningar som finns i databasen.
  - Kontrollera att beställningarna visas med korrekta detaljer (t.ex. namn, val av burgare och ingredienser).

### Testdata
- Simulerade beställningar med testnamn och specifika burgare för att kontrollera korrekt hantering.
- Mockad databas för att hantera testdata på ett oberoende och repeterbart sätt.

### Verktyg och Tekniker
- **Verktyg**: `pytest` används för att köra testerna.
- **Mockning**: `unittest.mock` används för att mocka databasanrop och undvika beroenden på en faktisk databas.

### Vad gör vi om ett test misslyckas?
- Om ett test misslyckas kommer vi först att köra om det för att säkerställa att det inte rör sig om ett intermittent problem.
- Vid fortsatt fel, felsöker vi den specifika funktionen och går igenom kodbasen med debug-verktyg för att identifiera och lösa problemet.

### Utförande och Dokumentation
- Testresultat dokumenteras löpande i ingenjörsdagboken och sammanfattande rapporter som kan delas med gruppen.
- Eventuella buggar eller problem loggas och följs upp med en tydlig handlingsplan.

---

## Testad Funktionalitet - Köksvy

### Test: `test_kitchen_page`
- **Syfte**: Säkerställa att kökssidan hämtar och visar beställningar korrekt från databasen.
- **Metod**: Vi använde `unittest.mock` för att mocka databasanropet och testade sidan med Flask's `test_client()`.
- **Scenario**:
  - När sidan `/` begärs, simuleras en beställning (`Lilla mohammed` med en `Classic Burger`).
  - Vi kontrollerar att sidan returnerar statuskoden `200` och att den innehåller kundens namn (`Lilla mohammed`).
- **Resultat**: Testet verifierar att kökspersonalen ser beställningen korrekt när de besöker sidan.

### Kommandon för att köra testet
För att köra testet för köksvyn, använd följande kommando från projektets rotkatalog:

```sh
pytest kitchen_website/test_kitchen_app.py
```

---

## Testad Funktionalitet - Order App

### Test: `test_order_page`
- **Syfte**: Säkerställa att beställningssidan korrekt tar emot och bearbetar användarens beställningar.
- **Metod**: Vi använde `unittest.mock` för att mocka databasanropet och testade sidan med Flask's `test_client()`.
- **Scenario**:
  - När en användare fyller i sitt namn, väljer en burgare och specificerar ingredienser att lägga till eller ta bort, ska sidan bearbeta detta korrekt och lagra informationen i databasen.
  - Testet verifierar att sidan returnerar en `200` statuskod och att den korrekta informationen skickas vidare.
- **Resultat**: Testet kontrollerar att alla komponenter fungerar som förväntat vid inskick av en order, inklusive korrekt databasinteraktion.

### Kommandon för att köra testet
För att köra testet för order-appen, använd följande kommando från projektets rotkatalog:

```sh
pytest order_website/test_order_app.py
```

---

## Reflektion över Testprocessen

### Vad gick bra?
Under testningen märkte vi att användningen av `unittest.mock` var mycket effektiv för att mocka databasanropen. Detta gjorde det möjligt för oss att isolera funktionerna och undvika beroenden på externa system, vilket ökade tillförlitligheten i våra tester. Genom att använda Flask's `test_client()` kunde vi även simulera HTTP-anrop på ett enkelt sätt, vilket gav oss snabb feedback på funktionaliteten.

### Utmaningar
En av de största utmaningarna var att hantera komplexiteten i integrationen mellan olika komponenter, särskilt när vi skulle säkerställa att dataflödet mellan order-appen och köksvyn fungerade korrekt. Att mocka databasanslutningarna krävde noggrann hantering för att säkerställa att alla beroenden var korrekt simulerade.

### Förbättringsmöjligheter
Vi kunde ha lagt mer tid på att skapa fler integrationstester för att täcka fler möjliga scenarier där olika komponenter kommunicerar med varandra. Dessutom kan det vara bra att undersöka mer avancerade verktyg för end-to-end-testning för att säkerställa att hela flödet från användarens beställning till kökspersonalens vy är fullt testat.

### Lärdomar
Den största lärdomen från denna process är vikten av att mocka externa beroenden för att kunna testa individuella komponenter i isolation. Detta gjorde inte bara testerna mer pålitliga, utan också enklare att felsöka när något gick fel. Vi lärde oss också vikten av att ha en strukturerad och välplanerad teststrategi för att kunna hantera komplexiteten i projektet.

---

## Sammanfattning

Denna dokumentation beskriver de tester som har implementerats för köksvyn och order-appen. Tester har genomförts med hjälp av Flask's `test_client()` och `unittest.mock` för att verifiera korrekt funktion av både beställningsflödet och kökspersonalens vy. Testerna bidrar till att säkerställa tillförlitligheten och robustheten hos projektets nyckelfunktioner.

