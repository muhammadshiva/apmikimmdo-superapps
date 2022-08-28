import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/bottom_nav/bottom_nav_cubit.dart';
import 'package:marketplace/ui/widgets/loading_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;

class PaymentMidtransScreen extends StatefulWidget {
  final String link;

  PaymentMidtransScreen({Key key, @required this.link}) : super(key: key);

  @override
  _PaymentMidtransScreenState createState() => _PaymentMidtransScreenState();
}

class _PaymentMidtransScreenState extends State<PaymentMidtransScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  bool _isLoading;
  bool _isInit;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _isInit = true;
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  List<JavascriptChannel> _javascriptChannel(BuildContext context) {
    return [
      JavascriptChannel(
          name: 'SUCCESS',
          onMessageReceived: (JavascriptMessage message) async {
            BlocProvider.of<BottomNavCubit>(context).navItemTapped(3);
            AppExt.popUntilRoot(context);
          }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              WebView(
                navigationDelegate: (action) async {
                  var url = action.url;
                  // handle gojek & shopee payment deeplinks
                  // https://docs.midtrans.com/en/other/faq/technical?id=flutter
                  if (url.startsWith("gojek") || url.startsWith("shopeeid")) {
                    if (await canLaunch(url)) {
                      await launch(url);
                      return NavigationDecision.prevent;
                    }
                  }
                  return NavigationDecision.navigate;
                },
                onPageStarted: (url) => setState(() {
                  _isLoading = true;
                }),
                onPageFinished: (finish) {
                  setState(() {
                    _isLoading = false;
                    _isInit = false;
                  });
                },
                initialUrl: "${widget.link}",
                javascriptMode: JavascriptMode.unrestricted,
                javascriptChannels: _javascriptChannel(context).toSet(),
                onWebViewCreated: (WebViewController webViewController) {
                  webViewController.clearCache();
                  final cookieManager = CookieManager();
                  cookieManager.clearCookies();

                  _controller.complete(webViewController);
                },
              ),
              _isLoading && _isInit
                  ? AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: _isLoading ? 1 : 0,
                      child: Container(
                        color: Colors.white,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    )
                  : Stack(),
            ],
          ),
        ),
      ),
    );
  }
}
