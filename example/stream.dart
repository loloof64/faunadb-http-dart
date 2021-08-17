import 'package:faunadb_http/faunadb_http.dart';
import 'package:faunadb_http/query.dart';
import 'package:faunadb_http/stream.dart';

/*
* `dart ./stream.dart <your_secret_here> <collection> <id>`
* */
void main(List<String> arguments) async {
  final config = FaunaConfig.build(
    secret: arguments[0],
  );
  final client = FaunaClient(config);
  final stream =
      await client.stream(Ref(Collection(arguments[1]), arguments[2]));
  stream.start();
  await stream.on<VersionEvent>().forEach((element) {
    print("updated doc");
  });
  client.close();
}
