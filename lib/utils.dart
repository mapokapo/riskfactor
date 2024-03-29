/// Circular shift list
List<T> shiftList<T>(List<T> list, int v) {
  if (list == null || list.isEmpty) return list;
  var i = v % list.length;
  return list.sublist(i)..addAll(list.sublist(0, i));
}
