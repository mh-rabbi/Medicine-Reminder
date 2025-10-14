// import 'package:flutter/material.dart';
//
// Route _bottomUpRoute(Widget page) {
//   return PageRouteBuilder(
//     pageBuilder: (_, __, ___) => page,
//     transitionsBuilder: (_, animation, __, child) {
//       final tween = Tween(begin: const Offset(0, 1), end: Offset.zero)
//           .chain(CurveTween(curve: Curves.easeOutCubic));
//       return SlideTransition(position: animation.drive(tween), child: child);
//     },
//   );
// }


import 'package:flutter/material.dart';

import '../screens/home_screen.dart';



// // Custom page route with fade + slide
// Route _createRoute() {
//   return PageRouteBuilder(
//     transitionDuration: const Duration(milliseconds: 600),
//     pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       final offsetAnimation = Tween<Offset>(begin: const Offset(0.0, 0.2), end: Offset.zero)
//           .chain(CurveTween(curve: Curves.easeOutCubic))
//           .animate(animation);
//       final fade = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
//       return SlideTransition(
//         position: offsetAnimation,
//         child: FadeTransition(opacity: fade, child: child),
//       );
//     },
//   );
// }

// // Bottom-up modal route for add/edit screen
// Route _bottomUpRoute(Widget page) {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => page,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(0.0, 1.0);
//       const end = Offset.zero;
//       final curve = Curves.easeOutCubic;
//       final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//       return SlideTransition(position: animation.drive(tween), child: child);
//     },
//   );
// }