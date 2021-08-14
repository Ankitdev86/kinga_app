class GetBikeData {
  String status;
  String msg;
  BikeDetails bikeDetails;

  GetBikeData({this.status, this.msg, this.bikeDetails});

  fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    bikeDetails = json['Bike_Details'] != null
        ? new BikeDetails.fromJson(json['Bike_Details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.bikeDetails != null) {
      data['Bike_Details'] = this.bikeDetails.toJson();
    }
    return data;
  }
}

class BikeDetails {
  String userId;
  String bikePhoto;
  String numberPlate;
  String year;
  String model;
  String color;

  BikeDetails(
      {this.userId,
        this.bikePhoto,
        this.numberPlate,
        this.year,
        this.model,
        this.color});

  BikeDetails.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    bikePhoto = json['bike_photo'];
    numberPlate = json['number_plate'];
    year = json['year'];
    model = json['model'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['bike_photo'] = this.bikePhoto;
    data['number_plate'] = this.numberPlate;
    data['year'] = this.year;
    data['model'] = this.model;
    data['color'] = this.color;
    return data;
  }
}

