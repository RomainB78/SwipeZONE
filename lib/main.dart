import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swipezone/screens/home_page.dart';
import 'package:swipezone/screens/planning_page.dart';
import 'package:swipezone/screens/select_page.dart';
import 'package:swipezone/screens/itinerary_page.dart';
import 'package:swipezone/splash_screen.dart';
import 'package:swipezone/nfc.dart';
import 'package:swipezone/visited.dart';

void main() {
  runApp(const MyApp());
}

final List<String> visitedPlaces = [];

final GoRouter _router = GoRouter(
  initialLocation: '/splash', // Démarre par le SplashScreen
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(title: 'HomePage'),
      routes: [
        GoRoute(
          path: 'planningpage',
          builder: (context, state) => const PlanningPage(title: 'Page de Planning'),
        ),
        GoRoute(
          path: 'selectpage',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const SelectPage(title: 'Page de sélection'),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const Offset begin = Offset(1.0, 0.0); // La page commence hors écran à droite
              const Offset end = Offset.zero; // La page termine au centre de l'écran
              const Curve curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: 'itinerarypage',
          builder: (context, state) => const ItineraryPage(title: 'Votre Itinéraire'),
        ),
        GoRoute(
          path: 'NFCScanner',
          builder: (context, state) => NFCScanner(
            title: 'Tags NFC',
            onAddVisitedPlace: (place) {
              visitedPlaces.add(place); // Ajoute le lieu à la liste partagée
              if (kDebugMode) {
                print('Lieu visité ajouté : $place');
              }
            },
          ),
        ),
        GoRoute(
          path: 'VisitedPlacesPage',
          builder: (context, state) => VisitedPlacesPage(
            title: 'Lieux Visités',
            visitedPlaces: visitedPlaces, // Passe la liste partagée
          ),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '3S2_SWIPEZONE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
