class AppConst {
  AppConst._();
  //Global
  static const bounceDuration = Duration(milliseconds: 110);

  //Database
  static const balanceStorageKey = 'balanceKey';
  static const statisticsStorageKey = 'statisticsKey';

  //Game
  static const String animationStateMachine = 'State Machine 1';
  static const String startAnimationTrigger = 'Trigger 1';
  static const String loseAnimationTrigger = 'Trigger 2';

  static const double defaultBalance = 1000;
  static const double minBetAmount = 1.0;
  static const double maxBetAmount = 100.0;
  static const double minCoef = 1.1;
  static const double maxCoef = 15.0;
  static const double valuePickerStep = 0.1;

  static const int startTimerSeconds = 3;

  static const increasingValueDelay = Duration(milliseconds: 300);
  static const increasingValueFastDelay = Duration(milliseconds: 100);
}
