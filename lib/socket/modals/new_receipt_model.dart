import 'dart:convert';

ReceiptResponseModel receiptResponseModelFromJson(String str) =>
    ReceiptResponseModel.fromJson(json.decode(str));

String receiptResponseModelToJson(ReceiptResponseModel data) =>
    json.encode(data.toJson());

class ReceiptResponseModel {
  dynamic response;
  String ?message;
  String? type;
  dynamic orderId;
  ReceiptData ?data;
  ReceiptData ?order;

  ReceiptResponseModel({
     this.response,
     this.message,
     this.type,
     this.orderId,
     this.data,
     this.order,
  });

  factory ReceiptResponseModel.fromJson(Map<String, dynamic> json) =>
      ReceiptResponseModel(
        response: json["Response"],
        message: json["message"],
        type: json["type"],
        orderId: json["OrderID"],
        data:json["data"] != null? ReceiptData.fromJson(json["data"]):null,
        order:json["order"] != null? ReceiptData.fromJson(json["order"]):null,
      );

  Map<String, dynamic> toJson() => {
        "Response": response,
        "message": message,
        "type": type,
        "OrderID": orderId,
        "data": data?.toJson(),
        "order":order?.toJson()
      };
}

class ReceiptData {
  dynamic id;
  String ?startAddress;
  String ?endAddress;
  dynamic distance;
  dynamic paymentMethod;
  dynamic estimatedTime;
  dynamic actualTime;
  DateTime ?createdAt;
  dynamic total;
  dynamic pendingAmount;
  dynamic driverId;
  String ?carModel;
  dynamic insuranceNumber;
  String ?name;
  String ?image;
  dynamic longitude;
  dynamic latitude;
  dynamic phone;
  String ?plateNumber;
  String ?vehicleName;
  dynamic driverRating;
  dynamic extraDistance;
  dynamic extraDistancePrice;
  dynamic extraTime;
  dynamic extraTimePrice;
  dynamic newTotal;
  dynamic baseFare;
  dynamic techFee;
  dynamic minimumFare;
  dynamic distance1;

  ReceiptData({
    this.id,
    this.startAddress,
    this.endAddress,
    this.distance,
    this.paymentMethod,
    this.estimatedTime,
    this.actualTime,
    this.createdAt,
    this.total,
    this.pendingAmount,
    this.driverId,
    this.carModel,
    this.insuranceNumber,
    this.name,
    this.image,
    this.longitude,
    this.latitude,
    this.phone,
    this.plateNumber,
    this.vehicleName,
    this.driverRating,
    this.extraDistance,
    this.extraDistancePrice,
    this.extraTime,
    this.extraTimePrice,
    this.newTotal,
    this.baseFare,
    this.minimumFare,
    this.techFee,
    this.distance1,
  });

  factory ReceiptData.fromJson(Map<String, dynamic> json) => ReceiptData(
        id: json["id"],
        startAddress: json["start_address"],
        endAddress: json["end_address"],
        distance: json["distance"],
        paymentMethod: json["payment_method"],
        estimatedTime: json["estimated_time"],
        actualTime: json["actual_time"],
        createdAt: DateTime.tryParse(json["created_at"]??DateTime.now().toUtc().toString()),
        total: json["total"] ?? "0.0",
        techFee: json["tech_fee"] ?? "0.0",
        baseFare: json["base_fare"] ?? "0.0",
        minimumFare: json["min_fare"]??json["min_price"] ?? "0.0",
        pendingAmount: json["pending_amount"],
        driverId: json["driverID"],
        carModel: json["car_model"],
        insuranceNumber: json["insurance_number"],
        name: json["name"],
        image: json["image"],
        longitude: json["Longitude"] ?? '0.0',
        latitude: json["Latitude"] ?? '0.0',
        phone: json["phone"],
        plateNumber: json["plate_number"],
        vehicleName: json["vehicle_name"],
        driverRating: json["DriverRating"],
        extraDistance: json["extra_distance"] ?? '0',
        extraDistancePrice: json["extra_distance_price"] ?? '0',
        extraTime: json["extra_time"],
        extraTimePrice: json["extra_time_price"],
        newTotal: json["new_total"] ?? '0',
        distance1: json["distance1"] ?? '0',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_address": startAddress,
        "end_address": endAddress,
        "distance": distance,
        "payment_method": paymentMethod,
        "estimated_time": estimatedTime,
        "actual_time": actualTime,
        "created_at": createdAt?.toIso8601String(),
        "total": total,
        "pending_amount": pendingAmount,
        "driverID": driverId,
        "car_model": carModel,
        "insurance_number": insuranceNumber,
        "name": name,
        "image": image,
        "Longitude": longitude,
        "Latitude": latitude,
        "phone": phone,
        "plate_number": plateNumber,
        "vehicle_name": vehicleName,
        "DriverRating": driverRating,
        "extra_distance": extraDistance,
        "extra_distance_price": extraDistancePrice,
        "extra_time": extraTime,
        "extra_time_price": extraTimePrice,
        "new_total": newTotal,
        "distance1": distance1,
      };
}
