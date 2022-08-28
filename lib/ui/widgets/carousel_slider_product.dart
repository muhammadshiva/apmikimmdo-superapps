import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';
import 'package:marketplace/ui/widgets/web/web.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class CarouselPromo extends StatefulWidget {
  final List<HomeSlider> sliders;
  final bool isLoading, useIndicator;

  const CarouselPromo({
    Key key,
    this.sliders,
    @required this.isLoading,
    this.useIndicator,
  }) : super(key: key);

  @override
  _CarouselPromoState createState() => _CarouselPromoState();
}

class _CarouselPromoState extends State<CarouselPromo> {
  int _current;

  @override
  void initState() {
    super.initState();
    _current = 0;
  }

  void _launchUrl(String _url) async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      showDialog(
          context: context,
          useRootNavigator: false,
          builder: (ctx) {
            return AlertFailureWeb(
                title: "Gagal mengakses halaman",
                description: "Halaman atau koneksi internet bermasalah",
                onPressClose: () {
                  AppExt.popScreen(context);
                });
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = AAppConfig.of(context);
    return Column(
      children: [
        widget.isLoading && widget.sliders == null
            ? kIsWeb
                ? Container(
                    width: double.infinity,
                    color: Colors.grey[200],
                  )
                : Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[200],
                    period: Duration(milliseconds: 1000),
                    child: Container(color: Colors.white, height: 180),
                  )
            : !widget.isLoading &&
                    (widget.sliders != null && widget.sliders.length > 0)
                ? CarouselSlider(
                    items: widget.sliders
                        .map(
                          (item) => kIsWeb
                              ? MouseRegion(
                                  cursor: item.link != ""
                                      ? SystemMouseCursors.click
                                      : SystemMouseCursors.basic,
                                  child: GestureDetector(
                                    onTap: () {
                                      item.link != ""
                                          ? _launchUrl(item.link)
                                          : null;
                                    },
                                    child: Image(
                                      image: NetworkImage(item.mobilePhoto),
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace stackTrace) {
                                        return Image.asset(
                                          AppImg.img_error,
                                          width: double.infinity,
                                          fit: BoxFit.contain,
                                        );
                                      },
                                      frameBuilder: (context, child, frame,
                                          wasSynchronouslyLoaded) {
                                        if (wasSynchronouslyLoaded) {
                                          return child;
                                        } else {
                                          return AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: frame != null
                                                ? child
                                                : Container(
                                                    width: double.infinity,
                                                    color: Colors.grey[200],
                                                  ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl: "${item.mobilePhoto}",
                                  fit: BoxFit.cover,
                                  memCacheHeight: (Get.height * 1).toInt(),
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey[300],
                                    highlightColor: Colors.grey[200],
                                    period: Duration(milliseconds: 1000),
                                    child: Container(color: Colors.white),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    AppImg.img_error,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                        )
                        .toList(),
                    options: CarouselOptions(
                        height: !context.isPhone ? 300 : 270,
                        autoPlay: true,
                        autoPlayAnimationDuration: Duration(seconds: 2),
                        viewportFraction: 1.0,
                        // aspectRatio: context.isPhone ? 512 / 230 : null,
                        disableCenter: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                  )
                : SizedBox.shrink(),
        widget.useIndicator == true
            ? !widget.isLoading &&
                    (widget.sliders != null && widget.sliders.length > 0)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: widget.sliders.asMap().entries.map((url) {
                        int index = url.key;
                        return Container(
                          width: 6.0,
                          height: 6.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == index
                                ? AppColor.primary
                                : AppColor.primary.withOpacity(0.5),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : SizedBox.shrink()
            : SizedBox.shrink()
      ],
    );
  }
}

class CarouselProduct extends StatefulWidget {
  final List<ProductPhoto> images;
  final bool isLoading;
  final double height;

  const CarouselProduct({
    Key key,
    @required this.images,
    this.height = 400,
    @required this.isLoading,
  }) : super(key: key);

  @override
  _CarouselProductState createState() => _CarouselProductState();
}

class _CarouselProductState extends State<CarouselProduct> {
  final CarouselController _controller = CarouselController();
  int _current;

  @override
  void initState() {
    super.initState();
    _current = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.isLoading && widget.images == null
              ? kIsWeb
                  ? Container(
                      width: double.infinity,
                      color: Colors.grey[200],
                    )
                  : Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[200],
                      period: Duration(milliseconds: 1000),
                      child: Container(color: Colors.white, height: 180),
                    )
              : !widget.isLoading &&
                      (widget.images != null && widget.images.length > 0)
                  ? CarouselSlider(
                      items: widget.images
                          .map(
                            (item) => GestureDetector(
                              onTap: () => showDialog(
                                context: context,
                                barrierDismissible: false,
                                barrierColor: Colors.black.withOpacity(0.9),
                                builder: (BuildContext context) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: SingleChildScrollView(
                                            child: Column(
                                          children: [
                                            CarouselSlider(
                                                items: widget.images
                                                    .map(
                                                      (data) => kIsWeb
                                                          ? Image(
                                                              image: NetworkImage(
                                                                  data.image ??
                                                                      ''),
                                                              width: double
                                                                  .infinity,
                                                              fit: BoxFit
                                                                  .contain,
                                                              errorBuilder: (BuildContext
                                                                      context,
                                                                  Object
                                                                      exception,
                                                                  StackTrace
                                                                      stackTrace) {
                                                                return Image
                                                                    .asset(
                                                                  AppImg
                                                                      .img_error,
                                                                  width: double
                                                                      .infinity,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                );
                                                              },
                                                              frameBuilder:
                                                                  (context,
                                                                      child,
                                                                      frame,
                                                                      wasSynchronouslyLoaded) {
                                                                if (wasSynchronouslyLoaded) {
                                                                  return child;
                                                                } else {
                                                                  return AnimatedSwitcher(
                                                                    duration: const Duration(
                                                                        milliseconds:
                                                                            300),
                                                                    child: frame !=
                                                                            null
                                                                        ? child
                                                                        : Container(
                                                                            width:
                                                                                double.infinity,
                                                                            color:
                                                                                Colors.grey[200],
                                                                          ),
                                                                  );
                                                                }
                                                              },
                                                            )
                                                          : CachedNetworkImage(
                                                              imageUrl:
                                                                  "${data.image ?? 'https://v1end.apmikimmdo.com/images/blank.png'}",
                                                              fit: BoxFit
                                                                  .contain,
                                                              memCacheHeight:
                                                                  (Get.height *
                                                                          1)
                                                                      .toInt(),
                                                              placeholder: (context,
                                                                      url) =>
                                                                  Shimmer
                                                                      .fromColors(
                                                                baseColor:
                                                                    Colors.grey[
                                                                        300],
                                                                highlightColor:
                                                                    Colors.grey[
                                                                        200],
                                                                period: Duration(
                                                                    milliseconds:
                                                                        1000),
                                                                child: Container(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Image.asset(
                                                                AppImg
                                                                    .img_error,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                    )
                                                    .toList(),
                                                options: CarouselOptions(
                                                    height: widget.height,
                                                    autoPlay: false,
                                                    enableInfiniteScroll: false,
                                                    viewportFraction: 1.0,
                                                    disableCenter: true,
                                                    initialPage: _current)),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              widget.images.length <= 1
                                                  ? ""
                                                  : "Geser untuk melihat foto lainnya",
                                              style: AppTypo.body1.copyWith(
                                                  color: AppColor
                                                      .textPrimaryInverted),
                                            )
                                          ],
                                        )),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Material(
                                          color: Colors.transparent,
                                          shape: CircleBorder(),
                                          child: IconButton(
                                              padding: EdgeInsets.zero,
                                              iconSize: 35,
                                              splashRadius: 20,
                                              icon: Icon(
                                                Boxicons.bx_x,
                                                color: Colors.white,
                                              ),
                                              onPressed: () =>
                                                  AppExt.popScreen(context)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              child: kIsWeb
                                  ? Image(
                                      image: NetworkImage(item.image),
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace stackTrace) {
                                        return Image.asset(
                                          AppImg.img_error,
                                          width: double.infinity,
                                          fit: BoxFit.contain,
                                        );
                                      },
                                      frameBuilder: (context, child, frame,
                                          wasSynchronouslyLoaded) {
                                        if (wasSynchronouslyLoaded) {
                                          return child;
                                        } else {
                                          return AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: frame != null
                                                ? child
                                                : Container(
                                                    width: double.infinity,
                                                    color: Colors.grey[200],
                                                  ),
                                          );
                                        }
                                      },
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: "${item.image ?? ''}",
                                      fit: BoxFit.cover,
                                      memCacheHeight: (Get.height * 1).toInt(),
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                        baseColor: Colors.grey[300],
                                        highlightColor: Colors.grey[200],
                                        period: Duration(milliseconds: 1000),
                                        child: Container(color: Colors.white),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        AppImg.img_error,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                            ),
                          )
                          .toList(),
                      carouselController: _controller,
                      options: CarouselOptions(
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                        height: widget.height,
                        autoPlay: false,
                        enableInfiniteScroll: false,
                        viewportFraction: 1.0,
                        disableCenter: true,
                      ),
                    )
                  : SizedBox.shrink(),
          !widget.isLoading &&
                  (widget.images != null && widget.images.length > 1)
              ? Container(
                  height: 80,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    itemCount: widget.images.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(width: 5),
                    itemBuilder: (BuildContext context, int index) =>
                        GestureDetector(
                      onTap: () => _controller.animateToPage(index),
                      child: Container(
                        height: 70,
                        width: 60,
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: _current == index
                                  ? AppColor.primary
                                  : Colors.white,
                              width: 2,
                              style: BorderStyle.solid),
                        ),
                        child: kIsWeb
                            ? Image(
                                image: NetworkImage(widget.images[index].image),
                                width: double.infinity,
                                fit: BoxFit.contain,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace stackTrace) {
                                  return Image.asset(
                                    AppImg.img_error,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                  );
                                },
                                frameBuilder: (context, child, frame,
                                    wasSynchronouslyLoaded) {
                                  if (wasSynchronouslyLoaded) {
                                    return child;
                                  } else {
                                    return AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: frame != null
                                          ? child
                                          : Container(
                                              width: double.infinity,
                                              color: Colors.grey[200],
                                            ),
                                    );
                                  }
                                },
                              )
                            : CachedNetworkImage(
                                imageUrl: widget.images[index].image ?? 'https://v1end.apmikimmdo.com/images/blank.png',
                                fit: BoxFit.contain,
                                memCacheHeight: (Get.height * 1).toInt(),
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey[300],
                                  highlightColor: Colors.grey[200],
                                  period: Duration(milliseconds: 1000),
                                  child: Container(color: Colors.white),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  AppImg.img_error,
                                  fit: BoxFit.contain,
                                ),
                              ),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}

// FOR PLATFROM WEB

class CarouselProductWeb extends StatefulWidget {
  final List<String> images;
  final bool isLoading;
  final double height;

  const CarouselProductWeb({
    Key key,
    @required this.images,
    this.height = 300,
    @required this.isLoading,
  }) : super(key: key);

  @override
  _CarouselProductWebState createState() => _CarouselProductWebState();
}

class _CarouselProductWebState extends State<CarouselProductWeb> {
  final CarouselController _controller = CarouselController();

  List<List<CarouselProductWebItem>> _chunks;
  List<CarouselProductWebItem> images = [];

  String photo;
  String _pinnedPhoto;

  int _current;
  int _pinnedPhotoId = 0;
  int _counter = 0;

  bool rightButtonShow = false;
  bool leftButtonShow = false;

  @override
  void initState() {
    photo = widget.images[0];
    _pinnedPhoto = widget.images[0];
    _current = 0;
    generateInList();
    _chunks = _generateChunks(images, 5, CarouselProductWebItem());
    if (widget.images.length > 5) {
      rightButtonShow = true;
    }
    super.initState();
  }

  generateInList() {
    for (var i = 0; i < widget.images.length; i++) {
      images.add(CarouselProductWebItem(id: i, image: widget.images[i]));
    }
  }

  List<List<T>> _generateChunks<T>(List<T> inList, int chunkSize, T emptyItem) {
    List<List<T>> outList = [];
    List<T> tmpList = [];
    int counter = 0;

    for (int current = 0; current < inList.length; current++) {
      if (counter != chunkSize) {
        tmpList.add(inList[current]);
        counter++;
      }
      if (counter == chunkSize || current == inList.length - 1) {
        outList.add(tmpList.toList());
        tmpList.clear();
        counter = 0;
      }
    }

    while (outList[outList.length - 1].length < chunkSize) {
      outList[outList.length - 1].add(emptyItem);
    }

    return outList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.isLoading && widget.images == null
            ? Container(
                width: double.infinity,
                color: Colors.grey[200],
              )
            : !widget.isLoading &&
                    (widget.images != null && widget.images.length > 0)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: NetworkImage(
                        "${AppConst.STORAGE_URL}/products/$photo",
                      ),
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, object, stack) => Image.asset(
                        AppImg.img_error,
                        width: double.infinity,
                        height: 300,
                      ),
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        } else {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: frame != null
                                ? child
                                : Container(
                                    width: double.infinity,
                                    height: 300,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[200],
                                    ),
                                  ),
                          );
                        }
                      },
                    ))
                : SizedBox(),
        !widget.isLoading && (widget.images != null && widget.images.length > 1)
            ? Stack(
                children: [
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      // aspectRatio: 1.0,
                      scrollPhysics: NeverScrollableScrollPhysics(),
                      enableInfiniteScroll: false,
                      height: 100,
                      enlargeCenterPage: false,
                      viewportFraction: 1,
                    ),
                    carouselController: _controller,
                    itemCount: _chunks.length,
                    itemBuilder: (context, index, realIdx) {
                      // final int first = index * 5;
                      // final int second = first + 1;
                      // final int three = second + 1;
                      // final int four = three + 1;
                      // final int five = four + 1;
                      // debugPrint("INDEX:${chunks[index]}");

                      return Row(
                        children: _chunks[index].asMap().entries.map((e) {
                          if (e.value.id == null) {
                            return Expanded(
                              child: SizedBox(),
                            );
                          }
                          return Expanded(
                              child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (value) {
                              setState(() {
                                _current = e.value.id;
                                photo = e.value.image;
                              });
                            },
                            onExit: (value) {
                              setState(() {
                                _current = null;
                                photo = _pinnedPhoto ?? e.value.image;
                              });
                            },
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _pinnedPhotoId = e.value.id;
                                  _pinnedPhoto = e.value.image;
                                });
                              },
                              child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                        color: _current == e.value.id ||
                                                _pinnedPhotoId == e.value.id
                                            ? AppColor.primary
                                            : AppColor.textPrimaryInverted,
                                        width: 2,
                                        style: BorderStyle.solid),
                                  ),
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image(
                                      image: NetworkImage(
                                          "${AppConst.STORAGE_URL}/products/${e.value.image}"),
                                      width: double.infinity,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace stackTrace) {
                                        return Image.asset(
                                          AppImg.img_error,
                                          width: double.infinity,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                      frameBuilder: (context, child, frame,
                                          wasSynchronouslyLoaded) {
                                        if (wasSynchronouslyLoaded) {
                                          return child;
                                        } else {
                                          return AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: frame != null
                                                ? child
                                                : Container(
                                                    width: 60,
                                                    height: 60,
                                                    color: Colors.grey[200],
                                                  ),
                                          );
                                        }
                                      },
                                    ),
                                  )
                                  // selectedAddress: widget.selectedAddress
                                  ),
                            ),
                          )
                              // child: Center(child: Text(imgList[idx])),
                              );
                        }).toList(),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Visibility(
                            visible: leftButtonShow,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _counter--;
                                });
                                if (_counter == 0) {
                                  setState(() {
                                    leftButtonShow = false;
                                    rightButtonShow = true;
                                  });
                                } else {
                                  setState(() {
                                    leftButtonShow = true;
                                    rightButtonShow = true;
                                  });
                                }
                                _controller.previousPage();
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 7),
                                  margin: EdgeInsets.only(left: 3),
                                  decoration: BoxDecoration(
                                      color: AppColor.primary,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5))),
                                  child: Icon(Icons.arrow_back_ios,
                                      size: 15, color: Colors.white)),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: SizedBox(),
                        ),
                        Expanded(
                          child: Visibility(
                            visible: rightButtonShow,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _counter++;
                                  leftButtonShow = true;
                                });
                                if (_counter == _chunks.length - 1) {
                                  setState(() {
                                    rightButtonShow = false;
                                  });
                                } else {
                                  setState(() {
                                    leftButtonShow = true;
                                    rightButtonShow = true;
                                  });
                                }
                                _controller.nextPage();
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 7),
                                  margin: EdgeInsets.only(right: 3),
                                  decoration: BoxDecoration(
                                      color: AppColor.primary,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5))),
                                  child: Icon(Icons.arrow_forward_ios,
                                      size: 15, color: Colors.white)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            : SizedBox.shrink()
      ],
    );
  }
}

class CarouselProductWebItem {
  final int id;
  final String image;

  CarouselProductWebItem({this.id, this.image});
}
