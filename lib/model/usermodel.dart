import 'package:flutter/material.dart';

class UserModel {
  String userName,
      userEmail,
      userGender,
      userPhoneNumber,
      userImage,
      userAddress,
      fatherName,
      Cnic,
      City,
      parentId,
      earning,
      progress,
  usertransactionImage;

  int selectedPackage;


  UserModel(
      {@required this.userEmail,
      @required this.userImage,
      @required this.userAddress,
      @required this.userGender,
      @required this.userName,
      @required this.userPhoneNumber,
      @required this.parentId, this.fatherName, this.City, this.Cnic, this.selectedPackage, this.earning, this.usertransactionImage, this.progress,
      });
}
