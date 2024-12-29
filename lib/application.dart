import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:updraft_flutter/blocs/game_bloc/game_bloc.dart';
import 'package:updraft_flutter/blocs/statistics_bloc/statistics_bloc.dart';
import 'package:updraft_flutter/pages/preloader/preloader_page.dart';
import 'package:updraft_flutter/res/theme.dart';
import 'package:updraft_flutter/utils/dependency_initializer.dart';
import 'package:updraft_flutter/utils/device_info.dart';
import 'package:updraft_flutter/utils/generate_routes.dart';
import 'package:updraft_flutter/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => injector<BalanceBloc>(),
        ),
        BlocProvider(
          create: (context) => injector<StatisticsBloc>(),
        ),
        BlocProvider(
          lazy: true,
          create: (context) => GameBloc(),
        ),
      ],
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: MaterialApp(
            title: 'updraft',
            debugShowCheckedModeBanner: false,
            initialRoute: route(PreloaderPage),
            routes: generateRoutes(),
            theme: mainAppTheme,
            darkTheme: mainAppTheme,
            builder: (context, child) {
              DeviceInfo.initializeDeviceInfo(context);
              return child ?? const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
