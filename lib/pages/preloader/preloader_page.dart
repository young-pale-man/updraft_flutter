import 'package:updraft_flutter/base/base_page_state.dart';
import 'package:updraft_flutter/blocs/balance_bloc/balance_bloc.dart';
import 'package:updraft_flutter/pages/home/home_page.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/utils/dependency_initializer.dart';
import 'package:updraft_flutter/utils/route.dart';
import 'package:updraft_flutter/utils/scaled_size.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PreloaderPage extends StatefulWidget {
  const PreloaderPage({super.key});

  @override
  State<PreloaderPage> createState() => _PreloaderPageState();
}

class _PreloaderPageState extends BasePageState<PreloaderPage> {
  final bloc = injector<BalanceBloc>();

  @override
  void initState() {
    super.initState();
    _moveToHomeScreen();
  }

  @override
  Widget pageBuilder(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 160 - MediaQuery.paddingOf(context).bottom),
          child: SpinKitRing(
            color: AppColors.accent.primary1,
            size: scaledSize(49),
          ),
        ),
      ],
    );
  }

  void _moveToHomeScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(route(HomePage));
    }
  }
}
