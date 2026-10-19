import 'dart:async';

class FakeTicks {
  final List<StreamController<Duration>> _sources = [];

  Stream<Duration> call() {
    final source = StreamController<Duration>();
    _sources.add(source);
    return source.stream;
  }

  bool get isListening => _sources.isNotEmpty && _sources.last.hasListener && !_sources.last.isClosed;

  int get subscriptions => _sources.length;

  void push(Duration elapsed) => _sources.last.add(elapsed);

  Future<void> tick(Duration elapsed) async {
    push(elapsed);
    await settle();
  }

  Future<void> seconds(double seconds) => tick(Duration(microseconds: (seconds * 1000000).round()));
}

Future<void> settle() async {
  for (var i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}
