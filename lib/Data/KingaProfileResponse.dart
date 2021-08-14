class KingaProfileResponse {
  String status;
  String msg;
  KingaProfileDetails kingaProfileDetails;

  KingaProfileResponse({this.status, this.msg, this.kingaProfileDetails});

  fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    kingaProfileDetails = json['Kinga_Profile_Details'] != null
        ? new KingaProfileDetails.fromJson(json['Kinga_Profile_Details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.kingaProfileDetails != null) {
      data['Kinga_Profile_Details'] = this.kingaProfileDetails.toJson();
    }
    return data;
  }
}

class KingaProfileDetails {
  String userId;
  String wristBandNo;
  String bloodGroup;
  String allergy;
  String insurer;
  String policyNo;
  String nHIFNo;

  KingaProfileDetails(
      {this.userId,
        this.wristBandNo,
        this.bloodGroup,
        this.allergy,
        this.insurer,
        this.policyNo,
        this.nHIFNo});

  KingaProfileDetails.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    wristBandNo = json['wrist_band_no'];
    bloodGroup = json['blood_group'];
    allergy = json['allergy'];
    insurer = json['insurer'];
    policyNo = json['policy_no'];
    nHIFNo = json['NHIF_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['wrist_band_no'] = this.wristBandNo;
    data['blood_group'] = this.bloodGroup;
    data['allergy'] = this.allergy;
    data['insurer'] = this.insurer;
    data['policy_no'] = this.policyNo;
    data['NHIF_no'] = this.nHIFNo;
    return data;
  }
}

