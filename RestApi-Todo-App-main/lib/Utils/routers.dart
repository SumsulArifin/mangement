import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageNavigator {
  PageNavigator({this.ctx});
  BuildContext? ctx;

  ///Navigator to next page
  Future nextPage({Widget? page}) {
    return Navigator.push(
        ctx!, CupertinoPageRoute(builder: ((context) => page!)));
  }

  Future<void> nextPageOnly({Widget? page}) async {
    await Navigator.pushReplacement(
      ctx!,
      MaterialPageRoute(builder: (context) => page!),
    );
  }


}
