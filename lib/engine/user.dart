part of engine;

class _User extends PertaminaEngine {
  @override
  // TODO: implement tag
  String get tag => "User";

  Future<bool> login(BuildContext context,
      {String username, String password, String grantType, CancelToken token}) async {
    String url = PertaminaEngine.baseUrl + "/auth/login";
    var uri = Uri.parse(url);
    Map<String, dynamic> params = Map();
    if (username != null) params.putIfAbsent("username", () => username);
    if (password != null) params.putIfAbsent("password", () => password);
    if (grantType != null)params.putIfAbsent("grant_type", () => grantType);
//    if (application.tokenFirebase != null) params.putIfAbsent("pntoken", () => application.tokenFirebase);

    var result = await _process(
        requestType: RequestType.post,
        context: context,
        url: uri.toString(),
        param: params,
        needToken: false,
        token: token,
        processName: "login"
    );

    if (result == null || (result as Map).isEmpty) return false;

    if (result["error_message"] != "") {
      Toast.showToast(context, "Error : ${result["error_message"]}");
      return false;
    }
    await AccountHelper.saveUserInfo(username, result);
    //await registerTokenFirebase(context, tokenFirebase: application.tokenFirebase);


    return true;
  }

}
