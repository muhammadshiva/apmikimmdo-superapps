import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;

class BsUnggahFoto {
  upload(BuildContext context, {Function() onTapCamera, Function() onTapGaleri}) {
    return showModalBottomSheet(
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, right: 16, left: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: 7,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(7.5 / 2),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Unggah Foto",
                  style: AppTypo.body2.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Divider(),
              ListTile(
                onTap: onTapCamera,
                leading: Icon(Icons.camera_alt, color: Colors.red,),
                title: Text(
                  "Kamera",
                  style: AppTypo.caption,
                ),
              ),
              ListTile(
                onTap: onTapGaleri,
                leading: Icon(Icons.image, color: Colors.red,),
                title: Text(
                  "Galeri",
                  style: AppTypo.caption,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}