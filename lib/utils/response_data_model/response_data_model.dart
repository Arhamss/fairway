class ResponseDataModel<T> {
  ResponseDataModel({
    required this.statusCode,
    required this.responseMessage,
    required this.isSuccess,
    this.responseData,
  });

  factory ResponseDataModel.error(String message, {int statusCode = 400}) {
    return ResponseDataModel(
      statusCode: statusCode,
      responseMessage: message,
      isSuccess: false,
    );
  }

  factory ResponseDataModel.success(T? data, String message) {
    return ResponseDataModel(
      statusCode: 200,
      responseMessage: message,
      responseData: data,
      isSuccess: true,
    );
  }

  final int statusCode;
  final String responseMessage;
  final T? responseData;
  final bool isSuccess;
}
