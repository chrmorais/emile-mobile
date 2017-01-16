function isDeveloperLogin() {
    var fixBindArray = {};
    if (email.text === "aluno@teste.com" && password.text === "lkjlkj") {
        fixBindArray.id = 2;
        fixBindArray.role = "student";
        fixBindArray.name = "enoquejoseneas";
        fixBindArray.email = "enoquejoseneas@ifba.edu.br";
        window.userProfileData = fixBindArray;
        window.isUserLoggedIn = true;
        loginPopShutdown.start();
        return true;
    } else if (email.text === "professor@teste.com" && password.text === "lkjlkj") {
        fixBindArray.id = 2;
        fixBindArray.role = "teacher";
        fixBindArray.name = "enoquejoseneas";
        fixBindArray.email = "enoquejoseneas@ifba.edu.br";
        window.userProfileData = fixBindArray;
        window.isUserLoggedIn = true;
        loginPopShutdown.start();
        return true;
    }
    return false;
}

function requestLogin() {
    if (!isValidLoginForm())
        return;
    if (isDeveloperLogin())
        return;
    jsonListModel.requestMethod = "POST"
    jsonListModel.requestParams = JSON.stringify({"email":email.text,"password":password.text})
    jsonListModel.source += "login/"
    jsonListModel.load()
}

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
