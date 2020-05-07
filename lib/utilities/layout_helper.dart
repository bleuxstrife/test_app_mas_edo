class LayoutHelper {
  static final double idealSquareSize = dp(70);
  static final double potraitMinWidth = 300.0;
  static final double dialogMaxWidth = dp(300.0);
  static final double potraitMaxWidth = 500.0; //just for phone that is about to be landscape

  static final double _designWidth = 320;
  static final double _designHeight = 568;

  static double screenWidth;
  static double screenHeight;
//
//  static get scaleWidth => screenWidth / _designWidth;
//
//  static get scaleHeight => screenHeight / _designHeight;
//
//  static setWidth(num width) => width * scaleWidth;
//
//  static setHeight(num height) => height * scaleHeight;
}

double dp(double px) {
  if (px == null) return px;

  if (LayoutHelper.screenWidth == null || LayoutHelper.screenHeight == null) return px;

  return px *
      (LayoutHelper.screenWidth * LayoutHelper.screenHeight) /
      (LayoutHelper._designWidth * LayoutHelper._designHeight);
}
