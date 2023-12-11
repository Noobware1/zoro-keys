import 'dart:io';
import 'dart:convert';

List<List<int>> main(List<String> args) {
  final script = File(args[0]).readAsStringSync();
  final start = script.lastIndexOf('switch');
  final end = script.indexOf('=partKey');

  final switchCaseString = script.substring(start, end);

  final regex = RegExp(r'=(\w+)');

  final indexes = regex
      .allMatches(switchCaseString)
      .map((e) {
        final varRegex = RegExp(',${e.group(1)!}=((?:0x)?([0-9a-fA-F]+))');

        final matches = varRegex.allMatches(script);
        print(matches.map((e) => e.group(0)));
        if (matches.isEmpty) {
          return null;
        }
        return matches.last.group(1)!.toInt();
      })
      .toList()
      .where((e) => e != null)
      .map((e) => e!)
      .toList()
      .getChunkedList();

  File('key').writeAsStringSync(jsonEncode(indexes));

  return indexes;
}

extension on String {
  int toInt() {
    if (startsWith("0x")) {
      return int.parse(substring(2), radix: 16);
    }
    return int.parse(this);
  }
}

extension on List<int> {
  List<List<int>> getChunkedList() {
    final chunked = <List<int>>[];
    for (var i = 0; i < length; i += 2) {
      chunked.add(sublist(i, i + 2));
    }
    return chunked;
  }
}
