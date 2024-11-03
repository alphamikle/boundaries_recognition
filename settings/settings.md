## TODO: Что надо сделать:
- Провести тестирование по различным типам карточек, чтобы подобрать оптимальные параметры для каждого класса
- Массив настроек вместо одного параметра, чтобы подбирать лучшую опцию для любого условия
- Чекать цветовые каналы, чтобы выбирать лучший из них (из статьи на хабре)
- Дорисовывать линии, чтобы определять правильно углы карточек (пока под вопросом - ибо это уже кривые условия)
- Параллелизация (на Dart получается полная хуета, которая медленнее синхронной однопотоковой реализации)
- FFI (если параллелизация не даст нужного перфоманса) - Rust / C++ (Rust - лучше)
- Расчет площади для отсеивания слишком маленьких объектов


Best result: 75 / 132 or 56.82% with these settings: Settings {
searchMatrixSize: 2
minObjectSize: 40
distortionAngleThreshold: 3.0
skewnessThreshold: 0.1
blackWhiteThreshold: 125
grayscaleAmount: 1.0
sobelAmount: 1.5
blurRadius: 2
}

## Global tests

```
[Check with config: dark or black and light or white] Best result: 3 / 3 or 100.00% with these settings: Settings {
  searchMatrixSize: 2
  minObjectSize: 40
  distortionAngleThreshold: 3.0
  skewnessThreshold: 0.1
  blackWhiteThreshold: 125
  grayscaleAmount: 0.5
  sobelAmount: 1.0
  blurRadius: 3
}

[Check with config: light or white and dark or black] Best result: 15 / 20 or 75.00% with these settings: Settings {
  searchMatrixSize: 2
  minObjectSize: 40
  distortionAngleThreshold: 3.0
  skewnessThreshold: 0.1
  blackWhiteThreshold: 125
  grayscaleAmount: 0.5
  sobelAmount: 1.0
  blurRadius: 3
}

[Check with config: dark or black and color] Best result: 0 / 0 or NaN% with these settings: null

[Check with config: light or white and light or white] Best result: 10 / 14 or 71.43% with these settings: Settings {
  searchMatrixSize: 2
  minObjectSize: 40
  distortionAngleThreshold: 3.0
  skewnessThreshold: 0.2
  blackWhiteThreshold: 125
  grayscaleAmount: 5.0
  sobelAmount: 0.5
  blurRadius: 2
}

[Check with config: color and color] Best result: 4 / 5 or 80.00% with these settings: Settings {
  searchMatrixSize: 2
  minObjectSize: 40
  distortionAngleThreshold: 3.0
  skewnessThreshold: 0.2
  blackWhiteThreshold: 125
  grayscaleAmount: 2.0
  sobelAmount: 0.5
  blurRadius: 2
}

[Check with config: color and dark or black] Best result: 33 / 51 or 64.71% with these settings: Settings {
  searchMatrixSize: 2
  minObjectSize: 40
  distortionAngleThreshold: 3.0
  skewnessThreshold: 0.1
  blackWhiteThreshold: 125
  grayscaleAmount: 1.0
  sobelAmount: 0.5
  blurRadius: 2
}

[Check with config: color and light or white] Best result: 19 / 26 or 73.08% with these settings: Settings {
  searchMatrixSize: 2
  minObjectSize: 40
  distortionAngleThreshold: 3.0
  skewnessThreshold: 0.1
  blackWhiteThreshold: 125
  grayscaleAmount: 1.0
  sobelAmount: 1.5
  blurRadius: 2
}

[Check with config: dark or black and dark or black] Best result: 6 / 7 or 85.71% with these settings: Settings {
  searchMatrixSize: 2
  minObjectSize: 40
  distortionAngleThreshold: 3.0
  skewnessThreshold: 0.2
  blackWhiteThreshold: 125
  grayscaleAmount: 2.0
  sobelAmount: 0.5
  blurRadius: 2
}

[Check with config: light or white and color] Best result: 3 / 4 or 75.00% with these settings: Settings {
  searchMatrixSize: 2
  minObjectSize: 40
  distortionAngleThreshold: 3.0
  skewnessThreshold: 0.2
  blackWhiteThreshold: 125
  grayscaleAmount: 3.0
  sobelAmount: 0.5
  blurRadius: 2
}

```

Different settings score:

93 / 130 or 71.54%