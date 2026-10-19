import 'package:updraft_flutter/base/base_page_state.dart';
import 'package:updraft_flutter/widgets/main_appbar.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/constants.dart';
import 'package:flutter/cupertino.dart';

class TermsOfUse extends StatefulWidget {
  const TermsOfUse({super.key});

  @override
  State<TermsOfUse> createState() => _TermsOfUseState();
}

class _TermsOfUseState extends BasePageState<TermsOfUse> {
  @override
  bool get bottomSafeArea => false;

  @override
  PreferredSizeWidget? get appBar => const MainAppbar(title: AppTexts.termsOfUse);

  @override
  Widget pageBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(
              AppConst.mockText + AppConst.mockText + AppConst.mockText,
              style: AppStyles.bodyL.copyWith(color: AppColors.ink),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
