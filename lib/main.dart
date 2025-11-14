import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'routes.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/driver/driver_active_ride_screen.dart';
import 'screens/driver/driver_activation_screen.dart';
import 'screens/driver/driver_requests_screen.dart';
import 'screens/driver/driver_review_screen.dart';
import 'screens/driver/driver_routes_screen.dart';
import 'screens/home/role_selection_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/passenger/passenger_approved_ride_screen.dart';
import 'screens/passenger/passenger_request_screen.dart';
import 'screens/passenger/passenger_review_screen.dart';
import 'screens/passenger/passenger_search_screen.dart';
import 'screens/profile/profile_setup_screen.dart';
import 'screens/settings/settings_screen.dart';

void main() {
  runApp(const ShareRouteApp());
}

class ShareRouteApp extends StatelessWidget {
  const ShareRouteApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShareRoute',
      theme: buildAppTheme(),
      initialRoute: AppRoutes.onboarding,
      routes: {
        AppRoutes.onboarding: (context) => const OnboardingScreen(),
        AppRoutes.auth: (context) => const AuthScreen(),
        AppRoutes.profile: (context) => const ProfileSetupScreen(),
        AppRoutes.driverActivation: (context) => const DriverActivationScreen(),
        AppRoutes.home: (context) => const RoleSelectionScreen(),
        AppRoutes.driverRoutes: (context) => const DriverRoutesScreen(),
        AppRoutes.driverRequests: (context) => const DriverRequestsScreen(),
        AppRoutes.driverActiveRide: (context) => const DriverActiveRideScreen(),
        AppRoutes.driverReview: (context) => const DriverReviewScreen(),
        AppRoutes.passengerSearch: (context) => const PassengerSearchScreen(),
        AppRoutes.passengerRequest: (context) => const PassengerRequestScreen(),
        AppRoutes.passengerApproved: (context) => const PassengerApprovedRideScreen(),
        AppRoutes.passengerReview: (context) => const PassengerReviewScreen(),
        AppRoutes.settings: (context) => const SettingsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.passengerRequest) {
          return MaterialPageRoute(
            builder: (_) => const PassengerRequestScreen(),
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}
