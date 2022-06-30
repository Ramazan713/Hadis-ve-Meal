

class KeyTypeModel<T>{
  final String key;
  final T defaultValue;
  const KeyTypeModel({required this.key,required this.defaultValue});

  Type get type{
    return T;
  }

}