import 'package:flutter/material.dart';
import 'package:marketplace/ui/screens/new_screens/notification/widgets/notification_list.dart';

class NotificationBody extends StatefulWidget {
  const NotificationBody({Key key}) : super(key: key);

  @override
  _NotificationBodyState createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<NotificationBody> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          NotificationList(
            statusName: 'Pesanan Selesai',
            statusMessage:
                'Pesanan INV/20210412/1827182 telah selesai. klik disini untuk menilai pesanan.',
            dates: '18 Maret 2022 15:32',
            image: 'images/img_error.png',
          ),
        ],
      ),
    );
  }
}
