part of 'FaunaClient.dart';

class FaunaStream {
  final FaunaClient _faunaClient;
  final FaunaConfig? _options;
  final Object _expression;
  final StreamController<StreamEvent> _streamController =
      StreamController.broadcast();

  HttpClient? _client;
  StreamSubscription<List<StreamEvent>>? _subscription;

  FaunaStream._(
    FaunaClient faunaClient,
    FaunaConfig? options,
    Object expression,
  )   : _faunaClient = faunaClient,
        _options = options,
        _expression = expression;

  Future<void> start() async {
    final config = _options ?? _faunaClient.config;
    _client = HttpClient();
    final request = await _client!.postUrl(config.baseUrl.resolve('/stream'));
    config.requestHeaders.entries.forEach((headerEntry) {
      request.headers.set(headerEntry.key, headerEntry.value);
    });
    request.add(utf8.encode(json.encode(_expression)));
    final response = await request.close();
    _subscription = await response
        .transform(utf8.decoder)
        .transform(ChunkedEventDecoder())
        .where((event) => event.isNotEmpty)
        .listen((events) {
      events.forEach((event) {
        _streamController.add(event);
      });
    });
  }

  Stream<T> on<T>() =>
      _streamController.stream.where((event) => event is T).cast();

  void close() {
    _subscription?.cancel();
    _streamController.close();
    _client?.close();
    _client = null;
  }
}
