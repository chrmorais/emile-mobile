function isValidLoginForm() {
    if (email.text === "Email" || email.text.length === 0) {
        alert("Error!", "Enter your Email!");
        return false;
    } else if (!Util.isValidEmail(email.text)) {
        alert("Error!", "Invalid Email!");
        return false;
    } else if (password.text === "Password" || password.text.length === 0) {
        alert("Error!", "Enter your password!");
        return false;
    }
    return true;
}

function loginCallback(responseText, status) {
    switch (status) {
    case 404:
        alert("Error!", "Email or password is invalid. Try again!");
        break;
    case 200:
        var objectTemp = resultText.user;
        window.userProfileData = objectTemp;
        console.log("window.userProfileData: " + JSON.stringify(window.userProfileData));
        window.isUserLoggedIn = true;
        loginPopShutdown.start();
        break;
    default:
        alert(qsTr("Error!"), qsTr("Failed to connect to the server!"))
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
    jsonListModel.debug = true;
    jsonListModel.requestMethod = "POST";
    jsonListModel.contentType = "application/json";
    jsonListModel.requestParams = JSON.stringify(params);
    jsonListModel.source += "login";
    jsonListModel.load(loginCallback);
}
