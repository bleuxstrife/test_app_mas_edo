import 'dart:async';

import '../presenter.dart';

mixin AddMixin<T extends Object> {
  Presenter _presenter;

  void initMixin(Presenter presenter) {
    _presenter = presenter;
  }

  void add() async {
    var x = await addExecution();

    postAdd(x);
    _presenter.view.refresh();
  }

  Future<T> addExecution();

  void postAdd(T value);
}
