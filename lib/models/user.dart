// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  int? id;
  String? email;
  String? username;
  String? password;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? type;
  String? latitude;
  String? longitude;
  bool? isOnline;
  bool? isBlocked;
  String? locationUpdatedAt;
  bool? isStaff;
  bool? isActive;
  String? access;
  String? refresh;
  String? vendor;
  String? imgUrl;
  String? storeName;
  String? preferenceList;
  String? rating;

  User(
      {this.id,
      this.vendor,
      this.email,
      this.username,
      this.password,
      this.firstName,
      this.lastName,
      this.mobileNumber,
      this.type,
      this.latitude,
      this.longitude,
      this.isOnline,
      this.isBlocked,
      this.locationUpdatedAt,
      this.isStaff,
      this.isActive,
      this.access,
      this.refresh,
      this.imgUrl,
      this.storeName,
      this.preferenceList,
      this.rating});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendor = json['vendor'];
    email = json['email'];
    username = json['username'];
    password = json['password'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobileNumber = json['mobile_number'];
    type = json['type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isOnline = json['is_online'];
    isBlocked = json['is_blocked'];
    locationUpdatedAt = json['location_updated_at'];
    isStaff = json['is_staff'];
    isActive = json['is_active'];
    access = json['access'];
    refresh = json['refresh'];
    imgUrl = json['imgUrl'] ?? "";
    storeName = json['store_name'] ?? "";
    preferenceList = json['preference_list'] ?? "";
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor'] = this.vendor;
    data['email'] = this.email;
    data['username'] = this.username;
    data['password'] = this.password;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile_number'] = this.mobileNumber;
    data['type'] = this.type;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['is_online'] = this.isOnline;
    data['is_blocked'] = this.isBlocked;
    data['location_updated_at'] = this.locationUpdatedAt;
    data['is_staff'] = this.isStaff;
    data['is_active'] = this.isActive;
    data['refresh'] = this.refresh;
    data['access'] = this.access;
    data['imgUrl'] = this.imgUrl;
    data['store_name'] = this.storeName;
    data['preference_list'] = this.preferenceList;
    data['rating'] = this.rating;
    return data;
  }

  User copyWith({
    int? id,
    String? email,
    String? username,
    String? password,
    String? firstName,
    String? lastName,
    String? mobileNumber,
    String? type,
    String? latitude,
    String? longitude,
    bool? isOnline,
    bool? isBlocked,
    String? locationUpdatedAt,
    bool? isStaff,
    bool? isActive,
    String? access,
    String? refresh,
    String? vendor,
    String? imgUrl,
    String? storeName,
    String? preferenceList,
    String? rating,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      type: type ?? this.type,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isOnline: isOnline ?? this.isOnline,
      isBlocked: isBlocked ?? this.isBlocked,
      locationUpdatedAt: locationUpdatedAt ?? this.locationUpdatedAt,
      isStaff: isStaff ?? this.isStaff,
      isActive: isActive ?? this.isActive,
      access: access ?? this.access,
      refresh: refresh ?? this.refresh,
      vendor: vendor ?? this.vendor,
      imgUrl: imgUrl ?? this.imgUrl,
      storeName: storeName ?? this.storeName,
      preferenceList: preferenceList ?? this.preferenceList,
      rating: rating ?? this.rating,
    );
  }
}
