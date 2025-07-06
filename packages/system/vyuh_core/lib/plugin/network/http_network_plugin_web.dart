import 'package:http/browser_client.dart';
import 'package:http/http.dart';

/// Creates a web client with credentials support for web platform.
Client createWebClient() {
  return BrowserClient()..withCredentials = true;
}
