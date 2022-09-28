//given a list split the list into sublists at at given indexes
List<List<T>> splitAt<T>(List<T> list, List<int> indexes) {
  var result = <List<T>>[];
  var start = 0;
  for (var index in indexes) {
    result.add(list.sublist(start, index));
    start = index;
  }
  result.add(list.sublist(start));
  return result;
}

// find the indexes of the media lines
List<int> mediaIndexes(List<String> lines) {
  final mediaIndexes = <int>[];
  lines.asMap().forEach((i, el) {
    if (el.startsWith("m")) {
      mediaIndexes.add(i);
    }
  });
  return mediaIndexes;
}