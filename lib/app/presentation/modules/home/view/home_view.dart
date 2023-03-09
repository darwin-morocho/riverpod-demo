import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bloc/home_bloc.dart';
import 'widgets/chart/chart_tile.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final cryptos = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: const Color(0xffd2d2d2),
      body: ListView.separated(
        itemBuilder: (_, index) => ChartTile(
          crypto: cryptos[index],
        ),
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemCount: cryptos.length,
      ),
    );
  }
}
