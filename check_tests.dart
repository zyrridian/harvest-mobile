import 'package:path/path.dart' as p;
import 'dart:io';

void main() {
  final libDir = Directory('lib');
  final testDir = Directory('test');

  // We usually don't test generated files (.g.dart, .freezed.dart)
  final ignoredExtensions = ['.g.dart', '.freezed.dart'];

  if (!libDir.existsSync() || !testDir.existsSync()) return;

  final libFiles = libDir.listSync(recursive: true).whereType<File>().where(
      (f) =>
          f.path.endsWith('.dart') &&
          !ignoredExtensions.any((ext) => f.path.endsWith(ext)));

  int missingCount = 0;

  for (var file in libFiles) {
    // Convert lib/features/... to test/features/..._test.dart
    final relativePath = p.relative(file.path, from: libDir.path);
    final expectedTestPath = p.join(
      testDir.path,
      relativePath.replaceAll(RegExp(r'\.dart$'), '_test.dart'),
    );

    if (!File(expectedTestPath).existsSync()) {
      print('Missing test for: $relativePath');
      missingCount++;
    }
  }

  print('\nTotal missing test files: $missingCount');
}
