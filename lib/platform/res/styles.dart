import 'package:flutter/material.dart';

import 'index.dart';
import 'package:flutter/widgets.dart';

class TextStyles {
  static TextStyle listTitle = TextStyle(
    fontSize: Dimens.font_sp16,
    color: XyColors.text_dark,
    fontWeight: FontWeight.bold,
  );
  static TextStyle listTitleWhite = TextStyle(
    fontSize: Dimens.font_sp16,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
  static TextStyle listTitle3 = TextStyle(
    fontSize: Dimens.font_sp16,
    color: XyColors.text_dark,
    fontWeight: FontWeight.w300,
  );
  static TextStyle listTitle2 = TextStyle(
    fontSize: Dimens.font_sp16,
    color: XyColors.text_dark,
  );
  static TextStyle dropdownTitle = TextStyle(
      color: XyColors.text_dark,
      fontSize: Dimens.font_sp18,
      fontWeight: FontWeight.w400
  );

  static TextStyle listContent = TextStyle(
    fontSize: Dimens.font_sp14,
    color: XyColors.text_normal,
  );
  static TextStyle listContentWhite = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colors.white,
  );
  static TextStyle listContent2 = TextStyle(
    fontSize: Dimens.font_sp14,
    color: XyColors.text_gray,
  );
  static TextStyle listExtra = TextStyle(
    fontSize: Dimens.font_sp12,
    color: XyColors.text_gray,
  );
  static TextStyle listExtra2 = TextStyle(
    fontSize: Dimens.font_sp12,
    color: XyColors.text_normal,
  );
  static const TextStyle appTitle = TextStyle(
    fontSize: Dimens.font_sp18,
    color: XyColors.text_dark,
  );
  static TextStyle curPlayTitle(BuildContext context){
    return TextStyle(
      fontSize: Dimens.font_sp16,
      color: Theme.of(context).accentColor,
    );
  }
  static TextStyle curPlayContent(BuildContext context){
    return TextStyle(
      fontSize: Dimens.font_sp14,
      color: Theme.of(context).accentColor,
    );
  }
}

class Decorations {
  static Decoration bottom = BoxDecoration(
      border: Border(bottom: BorderSide(width: 0.33, color: XyColors.divider)));
}

/// 间隔
class Gaps {
  /// 水平间隔
  static Widget hGap5 = new SizedBox(width: Dimens.gap_dp5);
  static Widget hGap8 = new SizedBox(width: Dimens.gap_dp8);
  static Widget hGap16 = new SizedBox(width: Dimens.gap_dp16);
  static Widget hGap30 = new SizedBox(width: Dimens.gap_dp30);

  /// 垂直间隔
  static Widget vGap5 = new SizedBox(height: Dimens.gap_dp5);
  static Widget vGap8 = new SizedBox(height: Dimens.gap_dp8);
  static Widget vGap16 = new SizedBox(height: Dimens.gap_dp16);
  static Widget vGap32 = new SizedBox(height: Dimens.gap_dp32);

  static Widget getHGap(double w) {
    return SizedBox(width: w);
  }

  static Widget getVGap(double h) {
    return SizedBox(height: h);
  }
}
