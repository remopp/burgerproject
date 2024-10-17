**Gemensam Sammanfattning och Reflektioner - Testning och Debugging**

### Namn på alla i teamet
- Abdallah Alhamad
- Ahmad Darwich
- Mohammad Aljubran
- Mouaz Naji

### Länk till projektets sida på Git-servern
- https://github.com/remopp/burgerproject


### Testning
För att säkerställa att vårt system fungerade som förväntat valde vi att medvetet korrumpera vissa filer för att skapa felaktiga situationer som vi sedan kunde hantera med våra tester. Genom att introducera dessa problem kunde vi simulera olika fel och verifiera att våra tester upptäckte dem korrekt.

- **Vad gick bra?**
  - Att korrumpera filerna gjorde att vi kunde skapa realistiska fel som ofta kan uppstå i utvecklingsprocessen. Våra tester kunde identifiera dessa problem, vilket stärker vårt förtroende för deras tillförlitlighet.
  - Jag fick en bättre förståelse för hur systemet reagerar under olika felaktiga scenarier och kunde justera testerna för att hantera dessa specifika fall.

- **Vad gick mindre bra?**
  - En utmaning var att återställa korrumperade filer efter testerna. Även med versionshantering tog det lite tid att säkerställa att alla teammedlemmar hade den senaste, fungerande versionen av koden.
  - Att hålla en balans mellan att introducera tillräckligt många fel och ändå ha tid för reflektion och åtgärd av dessa problem visade sig vara krävande.

### Debugging
För debuggningssessionen genomförde jag felsökning av de problem som uppstod efter att vi korrumperade vissa filer i koden. Jag satte breakpoints på kritiska punkter där jag visste att problemen skulle uppstå, och använde debugging-verktygen i VSCode för att identifiera vad som gick fel.

- **Vad gick bra?**
  - Att använda `step into` och `step over` hjälpte mig att se precis var problemen uppstod när den korrumperade koden exekverades. Detta gjorde det möjligt för mig att förstå vilka delar av koden som inte fungerade som förväntat.
  - Funktionen `watch` var mycket användbar för att bevaka värden på specifika variabler och se hur de ändrades under exekveringen.

- **Vad gick mindre bra?**
  - Eftersom korrumperade filer skapade oväntade fel blev det ibland svårt att hitta den exakta källan till problemet, särskilt när felet spreds över flera moduler. Detta innebar att jag ibland behövde sätta fler breakpoints än jag först trodde.
  - Debugging i en containeriserad miljö var en ny utmaning för mig. Jag behövde spendera tid på att konfigurera miljön rätt så att jag kunde köra debugging där.

### Reflektion
Att medvetet korrumpera filer och sedan felsöka problemen visade sig vara en värdefull övning. Det gav mig insikt i hur viktigt det är att ha ett starkt testfall för att snabbt kunna hitta och åtgärda problem. Nästa gång skulle jag förmodligen vara mer strukturerad med vilka filer jag korrumperar, och jag har fått mycket större förtroende för debugging som ett verktyg för att förstå och rätta fel i koden.


### För mer information om hur vid har debuggat och vad vi har debuggat det finns i vår ingengjör böcker