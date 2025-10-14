// import 'package:flutter/material.dart';
// import '../utils/app_colors.dart';
// import '../routes/route_animations.dart';
// import 'home_screen.dart';
//
// class IntroScreen extends StatelessWidget {
//   const IntroScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(28.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset('assets/med_intro.png', height: 260),
//                 const SizedBox(height: 40),
//                 const Text(
//                   'Never Miss a Dose!',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   'Set reminders for your medicines, stay healthy and consistent.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//                 const SizedBox(height: 40),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16)),
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
//                   ),
//                   onPressed: () => Navigator.of(context)
//                       .pushReplacement(_bottomUpRoute(const HomeScreen())),
//                   child: const Text(
//                     'Get Started',
//                     style: TextStyle(fontSize: 16, color: Colors.white),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:medicine_reminder/main.dart';

import '../utils/app_colors.dart';
import '../widgets/gradient_button.dart';
import 'home_screen.dart';




// ---------- INTRO SCREEN ----------
class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 60),
                // Decorative rounded card with illustration
                Expanded(
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Placeholder for 3D illustration
                          SizedBox(
                            height: 220,
                            child: Image.asset(
                              'assets/medicine.png',
                              fit: BoxFit.contain,
                              // if asset missing, provide fallback container
                              errorBuilder: (context, e, s) => const Icon(
                                Icons.access_alarm_rounded,
                                size: 140,
                                color: AppColors.primary,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),
                          Text(
                            'We take care of your regular medication',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Keep yourself and loved ones safe and never forget to take your meds, supplements and vitamins',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                    )
                    // subtle scale animation
                        .animate()
                        .scale(delay: 100.ms, duration: 700.ms),
                  ),
                ),

                const SizedBox(height: 12),

                // Get Started Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 28.0),
                  child: GradientButton(
                    text: 'Get Started',
                    onPressed: () {
                      Navigator.of(context).push(_createRoute());
                    },
                  )
                      .animate()
                      .fade(duration: 500.ms)
                      .slide(duration: 600.ms, begin: const Offset(0, 0.2)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom page route with fade + slide
Route _createRoute() {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 600),
    pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(begin: const Offset(0.0, 0.2), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOutCubic))
          .animate(animation);
      final fade = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(opacity: fade, child: child),
      );
    },
  );
}