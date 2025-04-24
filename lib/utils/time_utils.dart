///format(11:22:333)
String getTimeStr1(DateTime dateTime) {
  return "${twoNum(dateTime.hour)}:${twoNum(dateTime.minute)}:${twoNum(dateTime.second)}";
}

///转成两位数
String twoNum(int num) {
  return num > 9 ? num.toString() : "0$num";
}
