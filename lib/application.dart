import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:updraft_flutter/blocs/round_bloc/round_bloc.dart';
import 'package:updraft_flutter/blocs/statistics_bloc/statistics_bloc.dart';
import 'package:updraft_flutter/pages/preloader/preloader_page.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/res/theme.dart';
import 'package:updraft_flutter/utils/dependency_initializer.dart';
import 'package:updraft_flutter/utils/generate_routes.dart';
import 'package:updraft_flutter/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Application extends StatefulWidget {
  const Application({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    final dependencies = widget.dependencies;
    return RepositoryProvider.value(
      value: dependencies,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => BalanceBloc(storage: dependencies.balanceStorage)),
          BlocProvider(create: (context) => StatisticsBloc(storage: dependencies.roundsStorage)),
          BlocProvider(
            create: (context) => RoundBloc(
              balanceBloc: context.read<BalanceBloc>(),
              statisticsBloc: context.read<StatisticsBloc>(),
              random: dependencies.random,
              ticks: dependencies.ticks,
              clock: dependencies.clock,
            ),
          ),
        ],
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: MaterialApp(
              title: AppTexts.appName,
              debugShowCheckedModeBanner: false,
              initialRoute: route(PreloaderPage),
              routes: generateRoutes(),
              theme: mainAppTheme,
              darkTheme: mainAppTheme,
            ),
          ),
        ),
      ),
    );
  }
}
