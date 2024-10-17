**Gemensam Sammanfattning och Reflektioner - Implementering och Dokumentation**

### Namn på alla i teamet
- Abdallah Alhamad
- Ahmad Darwich
- Mohammad Aljubran
- Mouaz Naji

### Länk till projektets sida på Git-servern
- https://github.com/remopp/burgerproject

### Kort sammanfattning om vad vi har implementerat
Vi har utvecklat ett system för att beställa hamburgare, som inkluderar flera komponenter: BurgerOrderer (kundens webgränssnitt), MenuStore (databas med information om varor) och KitchenView (gränssnitt för kökspersonalen).
- **BurgerOrderer** gör det möjligt för kunder att se de olika varutyperna, anpassa sina hamburgare och skicka sin beställning till köket via ett REST-API.
- **MenuStore** är en databas som innehåller information om alla varor, inklusive anpassningsalternativ för hamburgare. Denna används av BurgerOrderer för att presentera menyn för kunden.
- **KitchenView** tar emot beställningar från BurgerOrderer och visar dem för kökspersonalen på ett enkelt, textbaserat sätt.

### Erfarenheter om hur projektet gick att genomföra
- **Vad gick bra?**
  - Vi fick till ett bra samarbete kring implementeringen genom att dela upp ansvaret för de olika modulerna. Genom tydlig modulär uppdelning kunde vi arbeta parallellt och undvika att kliva in på varandras områden.
  - Arbetet med REST-API:t mellan BurgerOrderer och KitchenView fungerade smidigt, och vi fick det att kommunicera bra mellan de olika containers.

- **Vad gick mindre bra?**
  - Initialt hade vi vissa svårigheter med att definiera gränssnitten mellan modulerna tydligt nog. Detta ledde till viss omarbetning av koden när vi insåg att våra gränssnitt inte var tillräckligt flexibla.
  - Container-konfigurationen tog längre tid än planerat eftersom vi stötte på problem med beroenden som behövde installeras för varje container.

- **Hur löste vi svårigheterna?**
  - Vi förbättrade kommunikationen inom teamet genom att ha regelbundna stand-ups där vi diskuterade gränssnitten och planerade ändringar. Detta hjälpte oss att snabbt fånga upp problem och lösa dem gemensamt.
  - För container-konfigurationen använde vi dokumentation och diskussionsforum för att identifiera problem och hitta de bästa lösningarna för våra beroenden.

- **Vad lyckades vi inte lösa? Varför inte?**
  - Vi hade svårigheter med att få till en smidig skalbarhet i KitchenView. Det var tänkt att flera beställningar skulle kunna hanteras samtidigt med en interaktiv vy, men vi hade inte tid att slutföra detta eftersom det visade sig vara mer komplext än vi först trodde.

### Erfarenheter om att arbeta med containers
- **Vad gick bra?**
  - Vi lyckades sätta upp och konfigurera Docker-containrar för varje delsystem vilket gjorde det enkelt att separera funktionaliteten. Det underlättade också felsökning eftersom vi kunde isolera problem till specifika containers.

- **Vad gick mindre bra?**
  - I början hade vi problem med att förstå hur några av de beroenden vi använde skulle hanteras inom container-miljön, vilket ledde till flera omstarter och konfigurationsändringar innan vi fick allting att fungera.

- **Hur löste vi svårigheterna?**
  - Vi använde oss av Docker Compose för att samordna uppstart av containrarna och skapa en enklare startprocess. Genom att gå igenom officiell dokumentation och tutorial-videor fick vi slutligen till en stabil lösning.

- **Vad lyckades vi inte lösa? Varför inte?**
  - Vi lyckades inte optimera containerstorlekarna så mycket som vi velat. Containers blev större än planerat på grund av onödiga beroenden som vi inte hann identifiera och ta bort, eftersom fokus var på att få funktionaliteten att fungera snarare än att optimera storlek och prestanda.

