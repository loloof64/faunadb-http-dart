import 'package:faunadb_http/src/events/stream_event.dart';
import 'package:json_annotation/json_annotation.dart';

part 'error_event.g.dart';

@JsonSerializable()
class ErrorEvent extends StreamEvent {
  ErrorEvent(int txn) : super(txn);

  factory ErrorEvent.fromJson(Map<String, dynamic> json) =>
      _$ErrorEventFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorEventToJson(this);
}
