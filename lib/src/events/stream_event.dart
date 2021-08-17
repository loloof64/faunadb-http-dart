import 'package:json_annotation/json_annotation.dart';

class StreamEvent {
  @JsonKey(name: 'txn')
  int txn;

  StreamEvent(this.txn);
}
