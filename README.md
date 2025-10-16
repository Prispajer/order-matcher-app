# Order Matcher App

Aplikacja mobilna napisana we Flutterze, której celem jest ułatwienie obsługi zamówień przesyłanych w formie tekstu (np. treści maila od klienta).  
Użytkownik kopiuje treść zamówienia i wkleja ją w aplikacji, a ta:

- pobiera listę produktów z serwisu [dummyjson.com](https://dummyjson.com/products?limit=50),
- wysyła tekst zamówienia do modelu językowego (Gemini – Google AI),
- otrzymuje listę pozycji (nazwa + ilość),
- dopasowuje je do produktów z listy,
- oblicza sumy cząstkowe i sumę całkowitą,
- prezentuje wynik w tabeli, oznaczając wyraźnie pozycje niedopasowane.

---

## 📱 Funkcjonalności

- Ekran **Produkty** – lista pobranych produktów (tytuł i cena)  
- Ekran **Zamówienie** – pole do wklejenia tekstu, analiza przez AI, tabela wynikowa  
- Tabela zawiera: Nazwa produktu | Ilość | Cena jednostkowa | Suma  
- Suma całkowita na dole  
- Pozycje niedopasowane oznaczone jako „Niedopasowane”  
- Obsługa błędów: brak internetu, błąd API, brak/niepoprawny klucz AI  

---

## 🧠 Architektura

- Clean Architecture + BLoC  
- Brak lokalnej bazy danych – dane przechowywane w pamięci procesu  
- Modułowa struktura: `features`, `core`, `assets`

---

## 🔑 Konfiguracja klucza AI (Gemini – Google AI)

Aplikacja korzysta z modelu językowego Gemini dostarczanego przez Google.  
Aby uruchomić analizę zamówień, potrzebujesz własnego klucza API powiązanego z projektem w Google Cloud.

### 🔧 Krok po kroku:

1. Wejdź na [Google Cloud Console](https://console.cloud.google.com/) i zaloguj się  
2. Utwórz nowy projekt (np. `order-matcher-app`)  
3. Przejdź do [Google AI Studio](https://aistudio.google.com/api-keys)  
4. Wygeneruj nowy klucz API i powiąż go z utworzonym projektem  
5. Skopiuj plik `assets/config/app_config.example.json` i zmień jego nazwę na `app_config.json`  
6. Wklej swój klucz API w miejsce `"PASTE_YOUR_KEY_HERE"`

### 📁 Przykład pliku `app_config.json`:

```json
{
  "ai_key": "YOUR_GEMINI_API_KEY"
}
```

## 🔑 Uruchomienie projektu

1. Zainstaluj Flutter SDK.
2. Pobierz zależności:
```console
flutter pub get
```
3. Uruchom aplikację:
```console
flutter run
```
## 🧪 Dane testowe

- Poproszę 2 Bułki, 4 jabłka i 6 pojemników na proch.
- Poproszę 2 IPhone 9 oraz 1x Samsung Universe 9. Dodatkowo 3 sztuki jabłek.

## 📂 Struktura projekt

- features/product – logika produktów (data/domain/presentation),
- features/order – logika zamówień (AI datasource, repozytorium, bloc, ekran),
- assets – pliki konfiguracyjne (app_config.example.json, lokalny app_config.json),
- core/config - logika pobierania klucza API.



