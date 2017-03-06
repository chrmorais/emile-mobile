.import "../../qml/js/Utils.js" as Util

function isValidLoginForm() {
    var message = "";
    if (email.text.length === 0)
        message = qsTr("Enter your Email!");
    else if (!Util.isValidEmail(email.text))
        message = qsTr("Enter a valid Email!");
    else if (password.text.length === 0)
        message = qsTr("Enter your password!");
    if (message.length > 0) {
        alert(qsTr("Error!"), message);
        return false;
    }
    return true;
}

function loginCallback(result, status) {
    switch (status) {
    case 404:
        alert(qsTr("Error!"), qsTr("Email or password is invalid. Try again!"));
        break;
    case 200:
        toast.show(qsTr("Login done successfully!"));
        requestResult = result.user;
        loginPopShutdown.start();
        break;
    default:
        alert(qsTr("Error!"), qsTr("Failed to connect to the server!"));
    }
}

function requestLogin() {
    if (!isValidLoginForm())
        return;
    var params = {
        "login": {
            "email": email.text,
            "password": password.text
        }
    };
    jsonListModel.requestMethod = "POST";
    jsonListModel.contentType = "application/json";
    jsonListModel.requestParams = JSON.stringify(params);
    jsonListModel.source += "login";
    jsonListModel.load(loginCallback);
}
