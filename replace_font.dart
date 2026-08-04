
import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  int count = 0;
  for (var file in files) {
    String content = file.readAsStringSync();
    if (content.contains('GoogleFonts.inter')) {
      content = content.replaceAll('GoogleFonts.inter', 'TextStyle');
      file.writeAsStringSync(content);
      count++;
    }
  }
  print('Replaced in $count files');
}

