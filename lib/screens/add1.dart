import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intsplay/screens/inicio.dart';
import 'package:ionicons/ionicons.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class AnuncioUno extends StatefulWidget {
  const AnuncioUno({super.key});

  @override
  State<AnuncioUno> createState() => _AnuncioUnoState();
}

class _AnuncioUnoState extends State<AnuncioUno> {
  Timer? blinkTimer;
  bool blinking = false;

  @override
  void initState() {
    super.initState();

    blinkTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      setState(() {
        blinking = !blinking;
      });
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          blinking = !blinking;
        });
      });
    });
  }

  @override
  void dispose() {
    blinkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Center(
          child: Image.asset(
            blinking
                ? (Theme.of(context).brightness == Brightness.dark
                    ? "assets/images/ints-oscuro-parpadeo.png"
                    : "assets/images/ints-blanco-parpadeo.png")
                : (Theme.of(context).brightness == Brightness.dark
                    ? "assets/images/ints-oscuro.png"
                    : "assets/images/ints-blanco.png"),
            height: 24,
          ),
        ),
        elevation: 0,
      ),
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
                  left: 23, right: 23, top: 20, bottom: 11),
              child: const Text(
                "Descubre cientos de emisoras al instante de todo el mundo y locales sin límites ninguno.",
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
              onPressed: () async {
                try {
                  // Replace 'your_product_id' with the actual product identifier you set up in RevenueCat dashboard
                  Offerings offerings = await Purchases.getOfferings();
                  if (offerings.current != null &&
                      offerings.current!.monthly != null) {
                    final Package package = offerings.current!.monthly!;
                    await Purchases.purchasePackage(package);
                    // Purchase completed successfully, add the logic for what to do next
                    // For example, you can unlock premium features, update UI, etc.
                  } else {
                    // No available offerings or the monthly offering is not defined
                    // Handle the error accordingly
                  }
                } on PlatformException catch (error) {
                  // Handle the purchase error
                  print('Purchase error: ${error.message}');
                }
              },
              child: Text(
                "\$0.99 USD",
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
                  "y obténlo mensualmente.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      height: 1.1,
                      color: Theme.of(context).colorScheme.onBackground),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const InicioScreen()),
          );
        },
        child: Icon(
          Ionicons.close_outline,
          size: 30,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }
}
