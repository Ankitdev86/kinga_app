class SendOtpForCompleteTripResponse {  String status;  String msg;  String otp;  SendOtpForCompleteTripResponse({      this.status,       this.msg,       this.otp});  fromJson(dynamic json) {    status = json['status'];    msg = json['msg'];    otp = json['otp'];  }  Map<String, dynamic> toJson() {    var map = <String, dynamic>{};    map['status'] = status;    map['msg'] = msg;    map['otp'] = otp;    return map;  }}