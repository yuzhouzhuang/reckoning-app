import 'package:flutter/material.dart';
import 'package:flutterApp/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

/*
  Navigator.of(context)
      .push(new MaterialPageRoute(builder: (_) {
    return new Browser(
      url: "https://paypal.me/yuzhouzhuang/" + "45.7",
    );
  }));
*/


class Browser extends StatelessWidget {

  const Browser({Key key, this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: MyColors.primaryColorLight.withAlpha(20),
            ),
            child: Icon(
              Icons.arrow_back_ios,
              color: MyColors.primaryColor,
              size: 16,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Pay the bill',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
//        elevation: 0,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
