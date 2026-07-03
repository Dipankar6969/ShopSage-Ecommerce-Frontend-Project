class ForgotPasswordRequestModel {
    ForgotPasswordRequestModel({
        required this.link,
        required this.message,
    });

    final String? link;
    final String? message;

    factory ForgotPasswordRequestModel.fromJson(Map<String, dynamic> json){ 
        return ForgotPasswordRequestModel(
            link: json["link"],
            message: json["message"],
        );
    }

}
