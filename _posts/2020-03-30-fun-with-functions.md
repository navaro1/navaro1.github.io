---
title: "Zabawa, zabawa, funkcje - FP Ladder 03"
excerpt: "Funkcje małe i duże, funkcja dla każdego"
categories: [scala, fp, fp-ladder, functions]
classes: wide
---
Będzie to kolejny dłuższy wpis, _skierowany do osób, które są bardzo początkujące_ w świecie programowania funkcyjnego. Ważnym jednak jest dla mnie, żeby taki wpis znalazł się na moim blogu.

Funkcje są tak elementarnym konceptem w programowaniu _funkcyjnym_, że aż znajdują się w nazwie. Dobrze więc wiedzieć czym funkcje są, czym funkcje nie są i jak mogą smakować odrobinę lepiej.

## Powtórka ze szkoły

Podstawową - i w naszym wypadku zupełnią wystarczającą - definicję _funkcji_ można znaleźć na [wiki](https://pl.wikipedia.org/wiki/Funkcja). 

Żeby określić funkcję musimy zacząć od _dwóch zbiorów_ $\boldsymbol{\text{In}}$ i $\boldsymbol{\text{Out}}$. Funkcja jest _przyporządkowaniem_ **każdemu** elementowi zbioru $\boldsymbol{\text{In}}$ **dokładnie jednego** elementu zbioru $\boldsymbol{\text{Out}}$. Gdy ten warunek nie jest spełniony możemy co najwyżej mówić o [relacji](https://pl.wikipedia.org/wiki/Relacja_(matematyka)). Klasyczny zapis funkcji to $f: \boldsymbol{\text{In}} \rightarrow \boldsymbol{\text{Out}}$

Zanim przejdziemy do konkretnych przykładów musimy jeszcze wprowadzić nadtechnikę, prawdziwego killera, a nie żadną popierdółkę wśród konceptów w świecie programowania funkcyjnego. Nie da się chyba wystarczająco mocno podkreślić wagi tego konceptu, a mianowicie _złożenie funkcji_ (ang. function composition).

Żeby zdefiniować złożenie potrzebujemy dwóch funkcji: $f: \boldsymbol{A} \rightarrow \boldsymbol{B}$ oraz $g: \boldsymbol{B} \rightarrow \boldsymbol{C}$. Jako, że _oczywiście lubimy_ statyczne typowanie, to od razu nasuwa się pytanie, czy możemy te dwie funkcje złożyć, intuicja podpowiada, że to się "skompiluje". Rzeczywiście tak jest, możemy określić funkcję $h: \boldsymbol{A} \rightarrow \boldsymbol{C}$ w następujący sposób: 
> Przekstałćmy najpierw element ze zbioru $\boldsymbol{A}$ w element zbioru $\boldsymbol{B}$ przy pomocy funkcji $f$, a następnie zastosujmy na wyniku funkcję $g$ ostatecznie otrzymując element zbioru $\boldsymbol{C}$.

Nie wydaje mi się, żeby koncept był mylący. W matematyce kompozycję zwyczajowo oznaczamy $\circ$. Dla mnie dość długo mylący był zapis, który należy czytać _od prawej do lewej_  
$$
h = g \circ f
$$
Zapis ten był dla mnie mylący, gdyż najpierw będziemy używać funkcji $f$, a dopiero na jej wyniku funkcji $g$. Nie jest to trudne do zapmiętania, ale mnie myliło (ze względu na ograniczone moce przerobowe mojego mózgu, najpewniej) - później starałem się pamiętać, że $g$ w zapisie stoi bliżej wynkowego $h$, więc będzie też później używane. 

### A kiedy mi się to przyda w życiu?

Jeżeli jesteś na tym blogu, to mam nadzieję, że niedługo, gdyż będziecie podbijali świat programowania podążając _jedyną słuszną drogą_ programowania funkcyjnego. 

Jedną z kluczowych technik, czy też zasad, w programowaniu funkcyjnym jest dzielenie problemu na wystarczająco małe podproblemiki, które następnie będziemy mogli swobodnie komponować, by ostatecznie uzyskać cały działający program. Ważne jest, żeby pisać w taki sposób, by Twoje funkcje się komponowały, ale też by całe _moduły_ (np. w prostej aplikacji może to być moduł autoryzacji oraz moduł dostępu do danych) również się komponowały. Kompozycja od dołu do góry i od góry do dołu. Kompozycja pozwola na łatwą wymianę funkcji, czy też modułów. Ta technika jest tak potężna, że stoi za wieloma bardziej zaawansowanymi technikami w FP, które nierzadko służą do utrzymania lub uzyskania kompozycji przy różnych, czasem niesprzyjających warunkach. Gdy będziecie je poznawali (monady, kleisli czy inne funktory), to miejcie w głowie, że gdzieś w tle czai się komponowanie.

Po krótkim wstępie, czas zajrzeć jak to wszystko wygląda w Scali, żeby utrwalić te koncepty.

> Sprostowanie "z góry": ten wpis jest skierowany do bardzo początkującego czytelnika, więc pewne elementy są celowo pomijane, nie będziemy tutaj mówić o curry'ingu, czy też częściowej aplikacji funkcji. Wpis ten ma tylko zbudować i utrwalić pewną intuicję i wskazać na pewne problemy - niekoniecznie podając pełen wachlarz rozwiązań.

## Funkcje nie gorsze niż wartości

Zaczniemy od bardzo prostej funkcji, które będzie przypisywała wartościom `Int` swoją wartość podniesioną do kwadratu. W Scali możemy określić następująco:
```scala
scala> val square: Int => Int = x => x * x
square: Int => Int = $$Lambda$4526/927668509@bade836

scala> def squareMethod(x: Int) = x * x
squareMethod: (x: Int)Int

scala> val squareValueFromMethod = squareMethod _
squareValueFromMethod: Int => Int = $$Lambda$4572/25358100@4f5080c1
```

