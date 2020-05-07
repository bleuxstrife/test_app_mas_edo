import 'dart:async';

mixin SaveMixin<T extends Object> {
  Future<bool> validate();

  Future<bool> save() async {
    bool validated = await validate();

    if (!validated) return false;

    var x = await saveExecution();

    postSave(x);
  }

  Future<T> saveExecution();

  void postSave(T value);
}