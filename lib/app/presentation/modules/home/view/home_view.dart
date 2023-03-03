import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bloc/home_bloc.dart';
import 'widgets/crypto_tile.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const routeName = 'home';
  static const routePath = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd3d3d3),
      body: SafeArea(
        child: Consumer(
          builder: (_, ref, __) {
            final cryptos = ref.watch(homeProvider);
            return ListView.separated(
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, index) => CryptoTile(
                crypto: cryptos[index],
              ),
              itemCount: cryptos.length,
            );
          },
        ),
      ),
    );
  }
}
