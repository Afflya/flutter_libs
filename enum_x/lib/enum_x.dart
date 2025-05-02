library;

mixin CodableEnum<T extends Enum> {
  T? fromStringOrNull(String str);
  String convertToString();

  T fromString(String str) {
    final v = fromStringOrNull(str);
    if (v == null) throw ArgumentError.value(str, "str", "No enum value with that str");
    return v;
  }

  T fromStringOrDefault(String str, T defaultValue) {
    return fromStringOrNull(str) ?? defaultValue;
  }
}

extension EnumToString on Enum {
  String convertToString() {
    if (this is CodableEnum) {
      return convertToString();
    }
    return name;
  }
}

extension EnumFromString<T extends Enum> on Iterable<T> {
  T? fromStringOrNull(String? str) {
    if (str == null) return null;

    if (first is CodableEnum) {
      return (first as CodableEnum).fromStringOrNull(str) as T?;
    }

    for (final value in this) {
      if (value.name == str) return value;
    }

    return null;
  }

  T fromString(String str) {
    final v = fromStringOrNull(str);
    if (v == null) throw ArgumentError.value(str, "str", "No enum value with that str");
    return v;
  }

  T fromStringOrDefault(String str, T defaultValue) {
    return fromStringOrNull(str) ?? defaultValue;
  }
}
