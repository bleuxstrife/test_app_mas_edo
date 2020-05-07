
import 'package:flutter/material.dart';
import 'package:fluttertestapp/boilerplates/view.dart';
import 'package:fluttertestapp/utilities/localization.dart';

import 'mixins/add.dart';


abstract class Presenter {
  final View _view;
  BuildContext _context;

  View get view => _view;

  PertaminaDict get dict => view.dict;

  BuildContext get context => _context;

  Presenter(this._context, this._view) {
    if (_view is AddMixin) {
      (_view as AddMixin).initMixin(this);
    }

    Future.delayed(Duration(milliseconds: 100)).then((_) {
      init();
    });
  }

  void init();
}