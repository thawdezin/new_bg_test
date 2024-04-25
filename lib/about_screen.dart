import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:june/june.dart';

import 'about_screen_state.dart';

/// The details screen
class AboutScreen extends StatelessWidget {
  /// Constructs a [AboutScreen]
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Screen')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go back to the Home screen'),
            ),
            JuneBuilder(() => CounterVM(),
                builder: (vm) => Column(
                      children: [
                        Text(" ${vm.count} is count"),
                      ],
                    )),
            ElevatedButton(
              onPressed: () {
                // You can call state from anywhere.
                var state = June.getState(CounterVM());
                state.count--;

                state.setState();
              },
              child: const Text("Decrease"),
            ),
            ElevatedButton(
              onPressed: () {
                // You can call state from anywhere.
                var state = June.getState(CounterVM());
                state.count++;

                state.setState();
              },
              child: const Text("Increase"),
            ),
          ],
        ),
      ),
    );
  }
}
