class GetPersonalData {
  String status;
  String msg;
  PersonalDetails personalDetails;

  GetPersonalData({this.status, this.msg, this.personalDetails});

  fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    personalDetails = json['Personal_Details'] != null
        ? new PersonalDetails.fromJson(json['Personal_Details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.personalDetails != null) {
      data['Personal_Details'] = this.personalDetails.toJson();
    }
    return data;
  }
}

class PersonalDetails {
  String userId;
  String profileImg;
  String gender;
  String birthDate;
  String county;
  String subCounty;
  String sacco;
  String password;
  String bakNo;

  PersonalDetails(
      {this.userId,
        this.profileImg,
        this.gender,
        this.birthDate,
        this.county,
        this.subCounty,
        this.sacco,
        this.password,
        this.bakNo});

  PersonalDetails.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    profileImg = json['profile_img'];
    gender = json['gender'];
    birthDate = json['birth_date'];
    county = json['county'];
    subCounty = json['sub_county'];
    sacco = json['sacco'];
    password = json['password'];
    bakNo = json['bak_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['profile_img'] = this.profileImg;
    data['gender'] = this.gender;
    data['birth_date'] = this.birthDate;
    data['county'] = this.county;
    data['sub_county'] = this.subCounty;
    data['sacco'] = this.sacco;
    data['password'] = this.password;
    data['bak_no'] = this.bakNo;
    return data;
  }
}

