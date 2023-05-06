import 'dart:math';

void testInteger() {
  int a = 4;
  int b = 5;
  int c = -10;

  print(a + b);
  print(a - c);
  print(pow(a, b));
  print(sqrt(a));
}

void testString() {
  String a = "Carry on my wayward son";
  print(a.toUpperCase());
  const string = 'Adasdsa';
  print(string.padLeft(40));
}

void testList() {
  List<String> a = [];
  a.add('One');
  print(a);
  a.add('Two');
  print(a);
  a.removeAt(a.length - 1);
  print(a);
  print(a.map((e) => e.toUpperCase()).toList());
}

void testMap() {}

void main() {
  testInteger();
  testString();
  testList();
}
