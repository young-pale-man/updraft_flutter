import 'package:updraft_flutter/blocs/statistics_bloc/statistics_bloc.dart';
import 'package:updraft_flutter/data/models/round_record.dart';
import 'package:updraft_flutter/res/colors.dart';
import 'package:updraft_flutter/res/dimens.dart';
import 'package:updraft_flutter/res/styles.dart';
import 'package:updraft_flutter/res/texts.dart';
import 'package:updraft_flutter/utils/coins.dart';
import 'package:updraft_flutter/widgets/machine/tag.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryStrip extends StatelessWidget {
  const HistoryStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final flights = context.select((StatisticsBloc bloc) => bloc.state.recentFlights);
    return SizedBox(
      height: AppSpacing.xl + AppSpacing.xs,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: flights.length + 1,
        separatorBuilder: (_, index) => SizedBox(width: index == 0 ? AppSpacing.sm : AppSpacing.xs + 2),
        itemBuilder: (context, index) =>
            index == 0 ? const Center(child: Tag(AppTexts.lastFlights)) : _FlightChip(flight: flights[index - 1]),
      ),
    );
  }
}

class _FlightChip extends StatelessWidget {
  const _FlightChip({required this.flight});

  final RoundRecord flight;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.screen,
        borderRadius: BorderRadius.circular(AppRadii.slab),
        border: Border.all(color: AppColors.ink, width: AppSizes.hairline),
      ),
      child: Text(
        Coins.formatMultiplier(flight.crash!),
        style: AppStyles.caption.copyWith(color: flight.jumped ? AppColors.positive : AppColors.negative),
      ),
    );
  }
}
