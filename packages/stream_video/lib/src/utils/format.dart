const _sizes = ['B', 'Kb', 'Mb', 'Gb'];

String bytesCountToReadableString(int bytesCount) {
  if (bytesCount < 1024) {
    return '$bytesCount B';
  }
  var doubleBytes = bytesCount.toDouble();
  var sizeIndex = 0;
  while (doubleBytes >= 1024 && sizeIndex < _sizes.length - 1) {
    doubleBytes /= 1024;
    sizeIndex++;
  }
  return '${doubleBytes.toStringAsFixed(2)} ${_sizes[sizeIndex]}';
}
