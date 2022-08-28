import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class CommentScreen extends StatelessWidget {
  const CommentScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Penilaian",
          style: AppTypo.subtitle2,
        ),
        actions: [],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            AppExt.popScreen(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 1,
                    itemBuilder: (context, _) {
                      return Row(
                        children: [
                          Container(
                            width: 120,
                            height: 46,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: FittedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Semua",
                                    style: AppTypo.caption,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "(134)",
                                    style: AppTypo.caption
                                        .copyWith(color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 120,
                            height: 46,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: FittedBox(
                              child: Column(
                                children: [
                                  Text(
                                    "Dengan Komentar",
                                    style: AppTypo.caption,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "(100)",
                                    style: AppTypo.caption
                                        .copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 128,
                            height: 46,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: FittedBox(
                              child: Column(
                                children: [
                                  Text(
                                    "Dengan Foto/Video",
                                    style: AppTypo.caption,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "(10)",
                                    style: AppTypo.caption
                                        .copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    kToolbarHeight -
                    132,
                child: ListView.separated(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            RatingBar.builder(
                              initialRating: 4,
                              minRating: 1,
                              itemSize: 20,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              ignoreGestures: true,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (double value) {},
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text("30 Apr",
                                style: AppTypo.caption
                                    .copyWith(color: Colors.grey))
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "images/img_cs.png",
                              height: 30,
                              width: 30,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text("Rusmini"),
                          ],
                        ),
                        Text(
                          "Varian L, Merah",
                          style: AppTypo.caption.copyWith(color: Colors.grey),
                        ),
                        Text(
                          "Pengiriman cepat dan bahannya bagus banget Pengiriman cepat dan bahannya bagus banget",
                          style: AppTypo.caption,
                        )
                      ],
                    );
                  },
                  separatorBuilder: (context, _) => SizedBox(
                    height: 16,
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
