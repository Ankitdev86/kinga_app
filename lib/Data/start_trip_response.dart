/// status : "1"/// msg : "Start Trip Save Successful"/// trip_id : "2"class StartTripResponse {  String status;  String msg;  String tripId;  StartTripResponse({      this.status,       this.msg,       this.tripId});  fromJson(dynamic json) {    status = json["status"];    msg = json["msg"];    tripId = json["trip_id"];  }  Map<String, dynamic> toJson() {    var map = <String, dynamic>{};    map["status"] = status;    map["msg"] = msg;    map["trip_id"] = tripId;    return map;  }}