import 'dart:convert';

import 'package:faunadb_http/src/events/start_event.dart';
import 'package:faunadb_http/src/events/stream_event.dart';
import 'package:faunadb_http/src/events/version_event.dart';
import 'package:faunadb_http/stream.dart';

class ChunkedEventDecoder extends Converter<String, List<StreamEvent>> {
  String _buffer = '';

  @override
  List<StreamEvent> convert(String input) {
    final values = List<StreamEvent>.empty(growable: true);
    var content = _buffer + input;
    try {
      final decodedEvent = jsonDecode(content);
      values.add(convertSingle(decodedEvent));
      _buffer = '';
    } catch (_) {
      while (true) {
        final pos = content.indexOf('\n') + 1;
        if (pos <= 0) break;
        final slice = content.substring(0, pos).trim();
        if (slice.isNotEmpty) {
          final decodedEvent = jsonDecode(slice);
          try {
            values.add(convertSingle(decodedEvent));
          } catch (_) {
            // Unknown type, discard the event
          }
        }
        content = content.substring(pos);
      }
      _buffer = content;
    }
    return values;
  }

  StreamEvent convertSingle(Map<String, dynamic> map) {
    switch (map['type']) {
      case 'start':
        return StartEvent.fromJson(map);
      case 'version':
        return VersionEvent.fromJson(map);
      case 'history_rewrite':
        return HistoryRewriteEvent.fromJson(map);
      case 'error':
        return ErrorEvent.fromJson(map);
    }

    throw 'Unknown type ${map['type']}';
  }

  @override
  Sink<String> startChunkedConversion(Sink<List<StreamEvent>> sink) {
    return _StreamEventSink(this, sink);
  }
}

class _StreamEventSink extends ChunkedConversionSink<String> {
  ChunkedEventDecoder chunkedEventDecoder;
  Sink<List<StreamEvent>> sink;

  _StreamEventSink(this.chunkedEventDecoder, this.sink);

  @override
  void add(String chunk) {
    sink.add(chunkedEventDecoder.convert(chunk));
  }

  @override
  void close() {
    sink.close();
  }
}
