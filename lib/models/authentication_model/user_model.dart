class UserModel {
  String? name;
  String? email;
  String? dob;
  String? gender;
  String? age;
  String? height;
  String? weight;
  String? profileImageUrl;
  String? nonVegetarian;
  String? token;
  String? dateForRegister;
  String? time;
  String? timeStamp;

  // 'date': formattedDate,
  // 'time': '${now.hour}:${now.minute}:${now.second}',
  // 'timeStamp': now.millisecondsSinceEpoch.toString(),

  UserModel({
    this.name,
    this.email,
    this.dob,
    this.age,
    this.gender,
    this.height,
    this.weight,
    this.profileImageUrl,
    this.nonVegetarian,
    this.token,
    this.dateForRegister,
    this.time,
    this.timeStamp,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'] ?? " ",
        email: json['email'] ?? " ",
        dob: json['dob'] ?? " ",
        age: json['age'] ?? " ",
        gender: json['gender'] ?? " ",
        height: json['height'] ?? " ",
        weight: json['weight'] ?? " ",
        profileImageUrl: json['profile_image'] ?? " ",
        nonVegetarian: json['nonVegetarian'] ?? " ",
        token: json['token'] ?? " ",
        dateForRegister: json['date'] ?? " ",
        time: json['time'] ?? " ",
        timeStamp: json['timeStamp'] ?? " ",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "dob": dob,
        "age": age,
        "gender": gender,
        "height": height,
        "weight": weight,
        "profile_image": profileImageUrl,
        "nonVegetarian": nonVegetarian,
        "token": token,
        "date": dateForRegister,
        "time": time,
        "timeStamp": timeStamp
      };
}
