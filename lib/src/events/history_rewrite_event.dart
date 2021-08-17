import 'package:faunadb_http/src/events/stream_event.dart';
import 'package:json_annotation/json_annotation.dart';

part 'history_rewrite_event.g.dart';

@JsonSerializable()
class HistoryRewriteEvent extends StreamEvent {
  HistoryRewriteEvent(int txn) : super(txn);

  factory HistoryRewriteEvent.fromJson(Map<String, dynamic> json) =>
      _$HistoryRewriteEventFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryRewriteEventToJson(this);
}
