
class CountyListResponse {
  String msg;
  String status;
  List<String> county_list;


  CountyListResponse({this.status, this.msg, this.county_list});

  fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    status = json['status'];
    county_list = json['county_list'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['status'] = this.status;
    data['county_list'] = this.county_list;
    return data;
  }
}


class SubCountyListResponse {
  String msg;
  String status;
  List<String> sub_county_list;


  SubCountyListResponse({this.status, this.msg, this.sub_county_list});

  fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    status = json['status'];
    sub_county_list = json['sub_county_list'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['status'] = this.status;
    data['sub_county_list'] = this.sub_county_list;
    return data;
  }
}

class SaccoListREsponse {
  String msg;
  String status;
  List<String> sacco_list;


  SaccoListREsponse({this.status, this.msg, this.sacco_list});

  fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    status = json['status'];
    sacco_list = json['sacco_list'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['status'] = this.status;
    data['sacco_list'] = this.sacco_list;
    return data;
  }
}

class ModelListREsponse {
  String msg;
  String status;
  List<String> model_list;


  ModelListREsponse({this.status, this.msg, this.model_list});

  fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    status = json['status'];
    model_list = json['model_list'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['status'] = this.status;
    data['model_list'] = this.model_list;
    return data;
  }
}


