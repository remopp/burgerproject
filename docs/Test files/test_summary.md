## Tester i Projektet

För att köra testerna i projektet, använd `pytest`.

### Köra alla tester
```sh
pytest
```

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

## Sammanfattning

Denna dokumentation beskriver de tester som har implementerats för köksvyn och order-appen. Tester har genomförts med hjälp av Flask's `test_client()` och `unittest.mock` för att verifiera korrekt funktion av både beställningsflödet och kökspersonalens vy. Testerna bidrar till att säkerställa tillförlitligheten och robustheten hos projektets nyckelfunktioner.


