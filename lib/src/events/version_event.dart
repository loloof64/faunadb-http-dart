import 'package:faunadb_http/src/events/stream_event.dart';
import 'package:json_annotation/json_annotation.dart';

part 'version_event.g.dart';

@JsonSerializable()
class VersionEvent extends StreamEvent {
  VersionEvent(int txn) : super(txn);

  factory VersionEvent.fromJson(Map<String, dynamic> json) =>
      _$VersionEventFromJson(json);

  Map<String, dynamic> toJson() => _$VersionEventToJson(this);
}
