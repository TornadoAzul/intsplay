import 'package:flutter/material.dart';

class SignalView extends StatefulWidget {
  const SignalView({super.key});

  @override
  State<SignalView> createState() => _SignalViewState();
}

class _SignalViewState extends State<SignalView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                "INTS PLAY",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "LeaugeSpartan",
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            Text(
              "SIGNAL",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 34,
                  fontFamily: "LeaugeSpartan",
                  color: Theme.of(context).primaryColor),
            ),
            Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? "assets/images/emitir-oscuro.png"
                  : "assets/images/emitir-claro.png",
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 11),
              child: const Text(
                "Crea una lista de reproducción personalizada para ti con los pódcast que amas en un solo lugar.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, height: 1.1),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(0),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              onPressed: () {},
              child: Text(
                "\$7.99 USD",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.only(
                  top: 5,
                ),
                child: Text(
                  "y tenlo de por vida.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      height: 1.1,
                      color: Theme.of(context).colorScheme.onBackground),
                )),
          ],
        ),
      ),
    );
  }
}
