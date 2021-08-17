import 'package:faunadb_http/src/events/stream_event.dart';
import 'package:json_annotation/json_annotation.dart';

part 'start_event.g.dart';

@JsonSerializable()
class StartEvent extends StreamEvent {
  StartEvent(int txn) : super(txn);

  factory StartEvent.fromJson(Map<String, dynamic> json) =>
      _$StartEventFromJson(json);

  Map<String, dynamic> toJson() => _$StartEventToJson(this);
}
