
class VerifyOTP {
  String otp;
  String status;


  VerifyOTP({this.otp});

  fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['status'] = this.status;
    return data;
  }
}


class SignUpResponse {
  String status;
  String msg;
  String user_id;

  SignUpResponse({this.status, this.msg, this.user_id});

  fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    status = json['status'];
    user_id = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['status'] = this.status;
    data['user_id'] = this.user_id;
    return data;
  }
}

class LoginResponse {
  String status;
  String msg;
  String user_id;

  LoginResponse({this.status, this.msg, this.user_id});

  fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    status = json['status'];
    user_id = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['status'] = this.status;
    data['user_id'] = this.user_id;
    return data;
  }
}

