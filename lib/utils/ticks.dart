typedef TickSource = Stream<Duration> Function();

Stream<Duration> frameTicks() async* {
  final watch = Stopwatch()..start();
  while (true) {
    await Future<void>.delayed(const Duration(milliseconds: 16));
    yield watch.elapsed;
  }
}
