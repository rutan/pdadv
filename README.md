# Pdadv

> PDF Adventure game framework

*It's a joke framework :)*

## Installation

```bash
$ gem install pdadv
```

## Usage

(1) make scenario file

```
%setGlobal Size, 1280, 960
%setGlobal Frame, ./assets/frame.png
%setGlobal Font, ./assets/myFont.ttf
%setGlobal TextColor, #ffffff
%setGlobal TextSize, 40
%setGlobal MessageArea, 360, 570, 570, 350
%setGlobal MessageWindow, ./assets/message_window.png

%register back, ./assets/back.jpg
%register myCharacter, ./assets/myCharacter.png

%back title

## start

%back back
%show 1, myCharacter

Hello, Pdadv!

- [Hello!](hello)
- [Good Bye!](end)

## hello

%back back
%show 1, myCharacter

Game Clear!

## end
%back back

Game Over...

- [Retry!](start)
```

(2) convert scenario to PDF

```bash
pdadv -o output.pdf scenario.txt
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
