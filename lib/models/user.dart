import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 2)
class ApiUser extends HiveObject {
  @HiveField(3)
  String name;

  @HiveField(4)
  String email;

  @HiveField(6)
  String photoUrl;

  @HiveField(7)
  String firebaseUid;

  @HiveField(8)
  String phoneNumber;

  ApiUser({this.email, this.firebaseUid, this.name, this.phoneNumber, this.photoUrl});

  factory ApiUser.fromJson(json) {
    return ApiUser(
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      firebaseUid: json['firebaseUid'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson(ApiUser user) {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['name'] = user.name;
    data['email'] = user.email;
    data['photoUrl'] = user.photoUrl;
    data['firebaseUid'] = user.firebaseUid;
    data['phoneNumber'] = user.phoneNumber;

    return data;
  }
}
