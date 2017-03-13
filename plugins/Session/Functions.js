.import "../../qml/js/Utils.js" as Util

function callbackLoadPrograms(status, response) {
    if (!status || !response || status !== 200) {
        alert(qsTr("Error!", qsTr("Cannot load the programs available! Try again.")));
        return;
    }
    var list = [];
    for (var prop in response) {
        if (!prop)
            return;
        var i = -1;
        while (i++ < response[prop])
            list.push(response[prop].name)
    }
    programsList.model = list;
}

function loadPrograms() {
    requestHttp.load("programs/", callbackLoadPrograms);
}

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

function loginCallback(status, response) {
    switch (status) {
    case 404:
        alert(qsTr("Error!"), qsTr("Email or password is invalid. Try again!"));
        break;
    case 200:
        toast.show(qsTr("Login done successfully!"));
        requestResult = response.user;
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
    requestHttp.requestParams = JSON.stringify(params);
    requestHttp.load("login", loginCallback, "POST");
}
