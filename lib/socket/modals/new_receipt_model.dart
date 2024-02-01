import 'dart:convert';

ReceiptResponseModel receiptResponseModelFromJson(String str) =>
    ReceiptResponseModel.fromJson(json.decode(str));

String receiptResponseModelToJson(ReceiptResponseModel data) =>
    json.encode(data.toJson());

class ReceiptResponseModel {
  dynamic response;
  String message;
  String type;
  dynamic orderId;
  ReceiptData data;

  ReceiptResponseModel({
    required this.response,
    required this.message,
    required this.type,
    required this.orderId,
    required this.data,
  });

  factory ReceiptResponseModel.fromJson(Map<String, dynamic> json) =>
      ReceiptResponseModel(
        response: json["Response"],
        message: json["message"],
        type: json["type"],
        orderId: json["OrderID"],
        data: ReceiptData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "Response": response,
        "message": message,
        "type": type,
        "OrderID": orderId,
        "data": data.toJson(),
      };
}

class ReceiptData {
  dynamic id;
  String startAddress;
  String endAddress;
  dynamic distance;
  dynamic paymentMethod;
  dynamic estimatedTime;
  dynamic actualTime;
  DateTime createdAt;
  dynamic total;
  dynamic pendingAmount;
  dynamic driverId;
  String carModel;
  dynamic insuranceNumber;
  String name;
  String image;
  dynamic longitude;
  dynamic latitude;
  dynamic phone;
  String plateNumber;
  String vehicleName;
  dynamic driverRating;
  dynamic extraDistance;
  dynamic extraDistancePrice;
  dynamic extraTime;
  dynamic extraTimePrice;
  dynamic newTotal;

  ReceiptData({
    required this.id,
    required this.startAddress,
    required this.endAddress,
    required this.distance,
    required this.paymentMethod,
    required this.estimatedTime,
    required this.actualTime,
    required this.createdAt,
    required this.total,
    required this.pendingAmount,
    required this.driverId,
    required this.carModel,
    required this.insuranceNumber,
    required this.name,
    required this.image,
    required this.longitude,
    required this.latitude,
    required this.phone,
    required this.plateNumber,
    required this.vehicleName,
    required this.driverRating,
    required this.extraDistance,
    required this.extraDistancePrice,
    required this.extraTime,
    required this.extraTimePrice,
    required this.newTotal,
  });

  factory ReceiptData.fromJson(Map<String, dynamic> json) => ReceiptData(
        id: json["id"],
        startAddress: json["start_address"],
        endAddress: json["end_address"],
        distance: json["distance"],
        paymentMethod: json["payment_method"],
        estimatedTime: json["estimated_time"],
        actualTime: json["actual_time"],
        createdAt: DateTime.parse(json["created_at"]),
        total: json["total"] ?? "0.0",
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_address": startAddress,
        "end_address": endAddress,
        "distance": distance,
        "payment_method": paymentMethod,
        "estimated_time": estimatedTime,
        "actual_time": actualTime,
        "created_at": createdAt.toIso8601String(),
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
      };
}
