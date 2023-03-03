import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../my_app.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    this.error,
    required this.stackTrace,
  });
  final Object? error;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                error.toString(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ProviderScope.containerOf(context).refresh(loadDataProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
