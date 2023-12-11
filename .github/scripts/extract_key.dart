import 'dart:io';

List<List<int>> main(List<String> args) {
  final script = File(args[0]).readAsStringSync();
  final start = script.lastIndexOf('switch');
  final end = script.indexOf('=partKey');

  final switchCaseString = script.substring(start, end);

  final regex = RegExp(r'=(\w)');

  final indexes = regex
      .allMatches(switchCaseString)
      .map((e) {
        final varRegex = RegExp(',${e.group(1)!}=(0x[0-9a-fA-F]+)');
        return varRegex.allMatches(script).last.group(1)!.toInt();
      })
      .toList()
      .getChunkedList();
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
