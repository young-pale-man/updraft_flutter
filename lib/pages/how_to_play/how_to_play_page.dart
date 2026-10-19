import 'package:updraft_flutter/base/base_page_state.dart';
import 'package:updraft_flutter/pages/how_to_play/widgets/fairness_table.dart';
import 'package:updraft_flutter/pages/how_to_play/widgets/payout_example.dart';
import 'package:updraft_flutter/pages/how_to_play/widgets/rule_section.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/widgets/main_appbar.dart';
import 'package:flutter/widgets.dart';

class HowToPlayPage extends StatefulWidget {
  const HowToPlayPage({super.key});

  @override
  State<HowToPlayPage> createState() => _HowToPlayPageState();
}

class _HowToPlayPageState extends BasePageState<HowToPlayPage> {
  @override
  bool get bottomSafeArea => false;

  @override
  PreferredSizeWidget? get appBar => const MainAppbar(title: AppTexts.howToPlay);

  @override
  Widget pageBuilder(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        MediaQuery.paddingOf(context).bottom + AppSpacing.xl,
      ),
      children: const [
        RuleSection(title: AppTexts.theRound, note: AppTexts.theRoundNote),
        RuleSection(
          title: AppTexts.jumping,
          note: AppTexts.jumpingNote,
          child: Column(
            children: [PayoutExample(entry: 1000, multiplier: 150), PayoutExample(entry: 1000, multiplier: 342)],
          ),
        ),
        RuleSection(title: AppTexts.autoJump, note: AppTexts.autoJumpNote),
        RuleSection(
          title: AppTexts.fairSkies,
          note: AppTexts.fairSkiesRule,
          child: FairnessTable(targets: [150, 200, 500, 1000]),
        ),
        RuleSection(title: AppTexts.leaving, note: AppTexts.leavingNote),
      ],
    );
  }
}
