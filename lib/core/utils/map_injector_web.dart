// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:async';

Future<void> injectMapScript() async {
  const apiKey = String.fromEnvironment('MAPS_API_KEY');
  if (apiKey.isNotEmpty) {
    // Only inject if it hasn't been injected yet
    final existingScript = html.document.head!.children.whereType<html.ScriptElement>().where((e) => e.src.contains('maps.googleapis.com'));
    if (existingScript.isEmpty) {
      final completer = Completer<void>();
      final script = html.ScriptElement()
        ..src = 'https://maps.googleapis.com/maps/api/js?key=$apiKey'
        ..type = 'application/javascript'
        ..onLoad.listen((_) => completer.complete());
      html.document.head!.append(script);
      await completer.future;
    }
  }
}
