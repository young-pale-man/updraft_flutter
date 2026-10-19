import 'dart:math';

class FixedRandom implements Random {
  FixedRandom(this.values);

  final List<double> values;
  int _next = 0;

  @override
  double nextDouble() => values[_next++ % values.length];

  @override
  bool nextBool() => throw UnimplementedError();

  @override
  int nextInt(int max) => throw UnimplementedError();
}
