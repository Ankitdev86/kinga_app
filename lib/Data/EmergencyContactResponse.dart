class GetEmergencyContact {
  String status;
  String msg;
  List<Colleague> colleague;
  List<Colleague> nextOfKin;

  GetEmergencyContact({this.status, this.msg, this.colleague, this.nextOfKin});

  fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['colleague'] != null) {
      colleague = new List<Colleague>();
      json['colleague'].forEach((v) {
        colleague.add(new Colleague.fromJson(v));
      });
    }
    if (json['Next_of_kin'] != null) {
      nextOfKin = new List<Colleague>();
      json['Next_of_kin'].forEach((v) {
        nextOfKin.add(new Colleague.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.colleague != null) {
      data['colleague'] = this.colleague.map((v) => v.toJson()).toList();
    }
    if (this.nextOfKin != null) {
      data['Next_of_kin'] = this.nextOfKin.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Colleague {
  String userId;
  String name;
  String contactNo;

  Colleague({this.userId, this.name, this.contactNo});

  Colleague.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    contactNo = json['Contact_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['Contact_no'] = this.contactNo;
    return data;
  }
}

