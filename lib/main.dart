import 'package:chat_server/di_container/register_dependencies.dart';
import 'package:chat_server/server/server.dart';

Future<void> main() async {
  final ChatServer server = await registerDependencies();

  await server.run();
}
