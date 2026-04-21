import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahadiamond_flutter_task/themes/app_theme.dart';
import 'bloc/watchlist_bloc.dart';
import 'bloc/watchlist_event.dart';
import 'screens/watchlist_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const TradingApp());
}

class TradingApp extends StatelessWidget {
  const TradingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WatchlistBloc()..add(const WatchlistLoaded()),
      child: MaterialApp(
        title: '021 Trade — Watchlist',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const WatchlistScreen(),
      ),
    );
  }
}
