class searchData{
  String FirstName='';
  String LastName='';
  String State='';
  String BirthCity='';
  String LiveCity='';
  bool isSeyed=true;
  bool isNotSeyed=true;
  int fromAge=0;
  int toAge=100;
}

class Kids {
  List<Madadjous> madadjous;

  Kids({this.madadjous});

  Kids.fromJson(Map<String, dynamic> json) {
    if (json['Madadjous'] != null) {
      madadjous = new List<Madadjous>();
      json['Madadjous'].forEach((v) {
        madadjous.add(new Madadjous.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.madadjous != null) {
      data['Madadjous'] = this.madadjous.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Madadjous {
  List<String> images;
  String firstName;
  String lastName;
  int code;
  int id;
  bool isSeyed;
  String statusName;
  int gen;
  String note;
  String imageUrl;
  String birth;
  String birthPlace;
  String city;

  Madadjous(
      {this.images,
        this.firstName,
        this.lastName,
        this.code,
        this.id,
        this.isSeyed,
        this.statusName,
        this.gen,
        this.note,
        this.imageUrl,
        this.birth,
        this.birthPlace,
        this.city});

  Madadjous.fromJson(Map<String, dynamic> json) {
    images = json['images'].cast<String>();
    firstName = json['FirstName'];
    lastName = json['LastName'];
    code = json['Code'];
    id = json['Id'];
    isSeyed = json['isSeyed'];
    statusName = json['StatusName'];
    gen = json['Gen'];
    note = json['Note'];
    imageUrl = json['ImageUrl'];
    birth = json['Birth'];
    birthPlace = json['BirthPlace'];
    city = json['City'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['images'] = this.images;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['Code'] = this.code;
    data['Id'] = this.id;
    data['isSeyed'] = this.isSeyed;
    data['StatusName'] = this.statusName;
    data['Gen'] = this.gen;
    data['Note'] = this.note;
    data['ImageUrl'] = this.imageUrl;
    data['Birth'] = this.birth;
    data['BirthPlace'] = this.birthPlace;
    data['City'] = this.city;
    return data;
  }
}