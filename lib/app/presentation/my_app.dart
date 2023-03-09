import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'modules/home/view/home_view.dart';
import 'modules/splash/view/splash_view.dart';
import 'repositories.dart';

final intialDataProvider = FutureProvider(
  (ref) async {
    final result = await ref.read(Repositories.exchange).getPrices(
      [
        'bitcoin',
        'ethereum',
        'tether',
        'binance-coin',
        'monero',
        'litecoin',
        'usd-coin',
        'dogecoin',
      ],
    );

    return result.when(
      left: (failure) => throw failure,
      right: (cryptos) => cryptos,
    );
  },
);

final router = Provider(
  (ref) => GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const HomeView(),
      ),
    ],
  ),
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return ref.watch(intialDataProvider).when(
          skipLoadingOnRefresh: false,
          data: (_) => MaterialApp.router(
            routerConfig: ref.read(router),
          ),
          error: (error, stackTrace) => Directionality(
            textDirection: TextDirection.ltr,
            child: Material(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(error.toString()),
                    ElevatedButton(
                      onPressed: () =>
                          ProviderScope.containerOf(context).refresh(
                        intialDataProvider,
                      ),
                      child: const Text('retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          loading: () => const SplashView(),
        );
  }
}
