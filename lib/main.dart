import 'package:flutter/material.dart';
import 'package:hangman/ui/colorcitos.dart';
import 'package:hangman/ui/widget/figure_image.dart';
import 'package:hangman/ui/widget/letter.dart';
import 'package:hangman/utils/game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  //Elegir la palabra
  String word = "vaca".toUpperCase();
  bool victoria = false;

  List<String> alphabet = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: const Text("Ahorcado"),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              children: [
                //La figuritas cambiaran en base al numero de intentos
                figureImage(Game.tries >= 0, "assets/hang.png"),
                figureImage(Game.tries >= 1, "assets/head.png"),
                figureImage(Game.tries >= 2, "assets/body.png"),
                figureImage(Game.tries >= 3, "assets/ra.png"),
                figureImage(Game.tries >= 4, "assets/la.png"),
                figureImage(Game.tries >= 5, "assets/rl.png"),
                figureImage(Game.tries >= 6, "assets/ll.png"),
              ],
            ),
          ),

          //------------Widget para crear la palabra oculta--------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                word //Dividimos cada letra de la cadena de texto ingresada en la palabra que se va a adivinar y lo pasamos a una lista
                    .split("")
                    .map((e) => letter(e.toUpperCase(),
                        !Game.selectedChar.contains(e.toUpperCase())))
                    .toList(),
          ),
          //-------------Widget para el teclado-----------------
          SizedBox(
            width: double.infinity,
            height: 250.0,
            child: GridView.count(
              crossAxisCount: 7,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              padding: const EdgeInsets.all(8.0),
              children: alphabet.map((e) {
                return RawMaterialButton(
                  //--------------La logica del juego al dar en un boton----------------
                  onPressed: Game.selectedChar.contains(e)
                      ? null //Verificamos que no se halla seleccionado ningun boton
                      : () {
                          setState(() {
                            //Agregamos la letra a la lista de palabras seleccionadas
                            Game.selectedChar.add(e);

                            //Si no se elige la letra de la palabra se suma un intento
                            if (!word.split('').contains(e.toUpperCase())) {
                              Game.tries++;

                              //Si se le acaban los intentos reinicia el juego
                              if (Game.tries == 7) {
                                Game.tries = 0;
                                Game.selectedChar
                                    .clear(); //Limpiamos la lista de palabras seleccionadas pasando a ser cero
                              }
                            } else {
                              Game.triesWin++;
                              //word.length == Game.selectedChar.length && Game.triesWin != 0
                            }

                            //SI GANA
                            if (word.length == Game.selectedChar.length &&
                                Game.triesWin != 0) {
                              //print("Ganaste");
                              Game.selectedChar.clear();
                              Game.tries = 0;
                              Game.triesWin = 0;
                            }
                          });
                        },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    e,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  fillColor: Game.selectedChar.contains(
                          e) //Cambiamos el color de la palabra seleccionada
                      ? Colors.blue
                      : AppColor.primaryColorDark,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
