import 'package:faunadb_http/src/events/stream_event.dart';
import 'package:json_annotation/json_annotation.dart';

part 'set_event.g.dart';

@JsonSerializable()
class SetEvent extends StreamEvent {
  SetEvent(int txn) : super(txn);

  factory SetEvent.fromJson(Map<String, dynamic> json) =>
      _$SetEventFromJson(json);

  Map<String, dynamic> toJson() => _$SetEventToJson(this);
}
