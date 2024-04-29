import 'package:april/about_screen.dart';
import 'package:april/location/location_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'detail_screen.dart';
import 'main.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MyHomePage(),
      routes: <RouteBase>[
        GoRoute(
          path: 'details',
          builder: (BuildContext context, GoRouterState state) {
            return const DetailsScreen();
          },
        ),
        GoRoute(
          path: 'about',
          builder: (BuildContext context, GoRouterState state) {
            return const AboutScreen();
          },
        ),
        GoRoute(
          path: 'location',
          builder: (BuildContext context, GoRouterState state) {
            return const LocationPage();
          },
        ),
      ],
    ),
  ],
  debugLogDiagnostics: true,
);