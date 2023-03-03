import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../repositories.dart';
import 'modules/error/view/error_view.dart';
import 'modules/home/view/home_view.dart';
import 'modules/splash/view/splash_view.dart';

final loadDataProvider = FutureProvider(
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
      right: (prices) => prices,
    );
  },
);

final routerProvider = Provider(
  (ref) {
    return GoRouter(
      routes: [
        GoRoute(
          name: HomeView.routeName,
          path: HomeView.routePath,
          builder: (_, __) => const HomeView(),
        ),
      ],
    );
  },
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(loadDataProvider).when(
          data: (initialPrices) => MaterialApp.router(
            routerConfig: ref.read(routerProvider),
          ),
          error: (e, s) => ErrorView(
            error: e,
            stackTrace: s,
          ),
          skipLoadingOnRefresh: false,
          loading: () => const SplashView(),
        );
  }
}
