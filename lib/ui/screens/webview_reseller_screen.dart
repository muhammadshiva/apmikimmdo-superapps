import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;

class WebviewResellerScreen extends StatefulWidget {
  final String link;

  WebviewResellerScreen(
      {Key key, @required this.link})
      : super(key: key);
  @override
  _WebviewResellerScreenState createState() =>
      _WebviewResellerScreenState();
}

class _WebviewResellerScreenState extends State<WebviewResellerScreen> {
  double _loadingProgress;
  bool _isLoading;
  final _flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    _loadingProgress = 0;
    _isLoading = true;

    _flutterWebviewPlugin.onProgressChanged.listen((state) async {
      setState(() {
        this._loadingProgress = state;
      });
      if (state == 1.0) {
        setState(() {
          this._isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _flutterWebviewPlugin.close();
    _flutterWebviewPlugin.cleanCookies();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      child: WebviewScaffold(
          url: "${widget.link}",
          appBar: AppBar(
            brightness: Brightness.dark,
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: AppColor.primary,
            elevation: 0,
            titleSpacing: 0,
            centerTitle: false,
            toolbarHeight: 0,
          ),
          withJavascript: true,
          allowFileURLs: true,
          hidden: true,
          withLocalStorage: true,
          initialChild: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: _isLoading ? 1 : 0,
            child: Container(
              color: Colors.white,
              child: Center(
                child: Container(
                  width: _screenWidth * (70 / 100),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${(_loadingProgress * 100).toInt()}%",
                        style: AppTypo.caption,
                      ),
                      SizedBox(height: 5),
                      LinearProgressIndicator(
                        value: _loadingProgress,
                        valueColor: AlwaysStoppedAnimation(AppColor.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
    );
  }
}
