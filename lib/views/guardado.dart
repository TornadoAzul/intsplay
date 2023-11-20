// // ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// import '../screens/find.dart';

// class GuardadoView extends StatefulWidget {
//   const GuardadoView({Key? key});

//   @override
//   State<GuardadoView> createState() => _GuardadoViewState();
// }

// class _GuardadoViewState extends State<GuardadoView> {
//   List<PodcastResult> savedPodcasts = [];

//   @override
//   void initState() {
//     super.initState();
//     getSavedPodcasts();
//   }

//   void getSavedPodcasts() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedPodcastsData = prefs.getStringList('savedPodcasts') ?? [];

//     final savedPodcastsList = savedPodcastsData
//         .map((data) => PodcastResult.fromMap(jsonDecode(data)))
//         .toList();

//     setState(() {
//       savedPodcasts = savedPodcastsList;
//     });
//   }

//   void removePodcast(PodcastResult podcast) async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedPodcastsData = prefs.getStringList('savedPodcasts') ?? [];

//     savedPodcastsData.remove(jsonEncode(podcast.toMap()));
//     prefs.setStringList('savedPodcasts', savedPodcastsData);

//     getSavedPodcasts();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               margin: const EdgeInsets.only(
//                   top: 45, left: 10, right: 10, bottom: 20),
//               child: const Align(
//                 alignment: Alignment.bottomLeft,
//                 child: Text(
//                   "Mis emisoras",
//                   style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: savedPodcasts.isNotEmpty
//                   ? ListView.builder(
//                       itemCount: savedPodcasts.length,
//                       itemBuilder: (context, index) {
//                         final podcast = savedPodcasts[index];
//                         return Dismissible(
//                           key: Key(podcast.id),
//                           direction: DismissDirection.endToStart,
//                           onDismissed: (_) {
//                             removePodcast(podcast);
//                           },
//                           background: Container(
//                             color: Theme.of(context).primaryColor,
//                             alignment: Alignment.centerRight,
//                             padding: const EdgeInsets.symmetric(horizontal: 16),
//                             child: Icon(
//                               Ionicons.trash_bin_outline,
//                               color: Theme.of(context).colorScheme.onBackground,
//                             ),
//                           ),
//                           child: GestureDetector(
//                             onTap: () {},
//                             child: ListTile(
//                               title: Text(
//                                 podcast.title,
//                                 style: const TextStyle(
//                                     fontSize: 25, fontWeight: FontWeight.bold),
//                               ),
//                               subtitle: Text(
//                                 podcast.author,
//                                 style: const TextStyle(fontSize: 19),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     )
//                   : Container(
//                       margin: const EdgeInsets.only(bottom: 80),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset(
//                             Theme.of(context).brightness == Brightness.dark
//                                 ? "assets/images/planetario-oscuro.png"
//                                 : "assets/images/planetario-claro.png",
//                           ),
//                           Text(
//                             'No hay emisoras guardadas',
//                             style: TextStyle(
//                                 fontSize: 24,
//                                 color:
//                                     Theme.of(context).colorScheme.onBackground),
//                           ),
//                         ],
//                       ),
//                     ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         elevation: 0,
//         backgroundColor: Theme.of(context).colorScheme.tertiary,
//         onPressed: () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const FindScreen()),
//           );
//         },
//         child: Icon(
//           Ionicons.search_outline,
//           size: 32,
//           color: Theme.of(context).colorScheme.onBackground,
//         ),
//       ),
//     );
//   }
// }
