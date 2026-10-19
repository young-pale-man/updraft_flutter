class AppConst {
  AppConst._();
  static const bounceDuration = Duration(milliseconds: 110);

  static const balanceStorageKey = 'balanceKey';
  static const statisticsStorageKey = 'statisticsKey';

  static const String animationStateMachine = 'State Machine 1';
  static const String startAnimationTrigger = 'Start';
  static const String loseAnimationTrigger = 'Finish';

  static const double defaultBalance = 500.0;
  static const double minBetAmount = 1.0;
  static const double maxBetAmount = 25.0;
  static const double minCoef = 1.1;
  static const double maxCoef = 15.0;
  static const double valuePickerStep = 0.1;
  static const double coefIncreasingStep = 0.1;

  static const int startTimerSeconds = 3;

  static const startGameDelay = Duration(seconds: 2);
  static const finishGameDelay = Duration(milliseconds: 1500);
  static const increasingValueDelay = Duration(milliseconds: 250);
  static const increasingValueFastDelay = Duration(milliseconds: 100);

  static const String mockText =
      'Lorem ipsum dolor sit amet consectetur. Eu sit aliquam sagittis amet luctus magna sem. Morbi vitae nunc netus neque sed convallis. Turpis dolor eu habitant augue ridiculus dui sit adipiscing. Sit fringilla adipiscing risus vestibulum mattis. Duis placerat viverra vulputate cras vel in nunc imperdiet cursus. Sit dignissim est eu sed quis mauris mauris ultrices. Vestibulum lacinia nunc pellentesque lorem commodo ut.\n\nSed risus amet et massa sed adipiscing gravida. Morbi tristique massa hendrerit eget. Lorem ipsum dolor sit amet consectetur. Eu sit aliquam sagittis amet luctus magna sem. Morbi vitae nunc netus neque sed convallis. Turpis dolor eu habitant augue ridiculus dui sit adipiscing. Sit fringilla adipiscing risus vestibulum mattis. Duis placerat viverra vulputate cras vel in nunc imperdiet cursus.\n\n Sit dignissim est eu sed quis mauris mauris ultrices. Vestibulum lacinia nunc pellentesque lorem commodo ut. Sed risus amet et massa sed adipiscing gravida. Morbi tristique massa hendrerit eget.';
}
