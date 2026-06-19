// no flutter import

import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  int changedFiles = 0;
  for (final file in files) {
    String content = file.readAsStringSync();
    if (content.contains('GoogleFonts.playfairDisplay') || content.contains('GoogleFonts.dmSans') || content.contains('GoogleFonts.lora') || content.contains('GoogleFonts.merriweather')) {
      content = content.replaceAll('GoogleFonts.playfairDisplay', 'GoogleFonts.inter');
      content = content.replaceAll('GoogleFonts.dmSans', 'GoogleFonts.inter');
      content = content.replaceAll('GoogleFonts.lora', 'GoogleFonts.inter');
      content = content.replaceAll('GoogleFonts.merriweather', 'GoogleFonts.inter');
      file.writeAsStringSync(content);
      changedFiles++;
    }
  }
  print('Updated fonts in $changedFiles files.');
}
