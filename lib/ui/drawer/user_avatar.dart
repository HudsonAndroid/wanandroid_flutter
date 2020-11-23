import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid_flutter/common/common_util.dart';
import 'package:wanandroid_flutter/common/state/account_provider.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';

class UserAvatar extends StatefulWidget {
  @override
  _UserAvatarState createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    AccountProvider accountModel = Provider.of<AccountProvider>(context);
    accountModel.initAvatar();
    double radius = 37.0;
    return GestureDetector(
      onTap: () {
        _showPicker(context);
      },
      child: CircleAvatar(
          radius: 40.0,
          backgroundColor: Colors.amberAccent, // 圆形头像的外边框
          child: CircleAvatar(
              radius: radius,
              child: accountModel.avatar != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(radius),
                      child: Image.file(
                        File(accountModel.avatar),
                        width: radius * 2,
                        height: radius * 2,
                        fit: BoxFit.fitWidth,
                      ))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(radius),
                      child: Image.asset(
                        assetsImg('icon_default_user', fileType: 'jpg'),
                        width: radius * 2,
                        height: radius * 2,
                        fit: BoxFit.fill,
                      )))),
    );
  }

  _pickImage(ImageSource imageSource) async {
    AccountProvider accountModel = Provider.of<AccountProvider>(context, listen: false);
    PickedFile image =
        await picker.getImage(source: imageSource, imageQuality: 50);
    setState(() {
      if (image != null) {
        accountModel.changeAvatarPath(image.path);
      } else {
        print('No image selected!');
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text(S.of(context).image_source_gallery),
                      onTap: () {
                        _pickImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text(S.of(context).image_source_camera),
                    onTap: () {
                      _pickImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
