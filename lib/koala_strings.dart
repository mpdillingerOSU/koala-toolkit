RegExp alphanumeric = RegExp(r'[a-zA-Z0-9]');
RegExp numeric = RegExp(r'^\-?[0-9]*$');
RegExp whitespace = RegExp(r'\s+');
RegExp limitedChars = RegExp(r"[a-zA-Z0-9 \'\-]+");

String asLowercaseAlphanumeric(String value) =>
    asAlphanumeric(value).toLowerCase();

String asAlphanumeric(String value) {
  String str = '';
  for (final Match m in alphanumeric.allMatches(value)) {
    str += m[0]!;
  }
  return str;
}

String toCamelCase(String value) {
  String returnStr = '';
  List<String> splitStr = value.trim().split(whitespace);
  List<String> alphaNums = [];
  for (String str in splitStr) {
    String temp = asLowercaseAlphanumeric(str);
    if (temp != '') {
      alphaNums.add(temp);
    }
  }
  if (alphaNums.isNotEmpty) {
    returnStr += alphaNums.first;
    for (int i = 1; i < alphaNums.length; i++) {
      returnStr += capitalize(alphaNums[i]);
    }
  }
  return returnStr;
}

String toSnakeCase(String value) {
  String returnStr = '';
  List<String> splitStr = value.trim().split(whitespace);
  List<String> alphaNums = [];
  for (String str in splitStr) {
    String temp = asLowercaseAlphanumeric(str);
    if (temp != '') {
      alphaNums.add(temp);
    }
  }
  if (alphaNums.isNotEmpty) {
    returnStr += alphaNums.first;
    for (int i = 1; i < alphaNums.length; i++) {
      returnStr += '_${alphaNums[i]}';
    }
  }
  return returnStr;
}

String capitalize(String value) {
  return value.isNotEmpty ? value[0].toUpperCase() + value.substring(1) : '';
}

String uncapitalize(String value) {
  return value.isNotEmpty ? value[0].toLowerCase() + value.substring(1) : '';
}

String replaceWhitespace(String value, String replacement) =>
    value.replaceAll(whitespace, replacement);

String removeWhitespace(String value) => replaceWhitespace(value, '');

bool normativelyEqual(String val, String comp) =>
    removeWhitespace(val.toLowerCase()) == removeWhitespace(comp.toLowerCase());

String minimizeWhitespace(String value) =>
    value.trim().replaceAll(whitespace, ' ');

bool hasSubsequence(String str, String subsequence) {
  if (subsequence.isEmpty) {
    return true;
  }

  int i = 0;
  for (String char in toArray(str)) {
    if (char == subsequence[i]) {
      i++;
      if (i == subsequence.length) {
        return true;
      }
    }
  }
  return false;
}

List<String> toArray(String str) {
  List<String> list = [];
  for (int i = 0; i < str.length; i++) {
    list.add(str[i]);
  }
  return list;
}

List<String> allBetween(
  String str,
  String from,
  String to, {
  bool inclusive = true,
}) {
  List<String> list = [];
  List<String> chars = toArray(str);
  for (int i = 0; i < chars.length; i++) {
    if (chars[i] == from) {
      int depth = 1;
      String val = chars[i];
      int j = i + 1;
      for (; j < chars.length; j++) {
        val += chars[j];
        if (chars[j] == to) {
          if (--depth == 0) {
            list.add(inclusive ? val : val.substring(1, val.length - 1));
            break;
          }
        } else if (chars[j] == from) {
          depth++;
        }
      }
      if (from == to) {
        i = j;
      }
    }
  }
  return list;
}
