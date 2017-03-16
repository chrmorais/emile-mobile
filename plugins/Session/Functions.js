.import "../../qml/js/Utils.js" as Util

function callbackPrograms(status, response) {
    if (status !== 200) {
        alert(qsTr("Error!", qsTr("Cannot load the available programs! Try again.")));
        return;
    }
    for (var prop in response) {
        if (!prop) return;
        var i = 0;
        programsListModel.append({"id": -1, "name": qsTr("Select the course"), "abbreviation": ""});
        while (i < response[prop].length)
            programsListModel.append(response[prop][i++]);
        programsList.currentIndex = 0;
    }
}

function appendCourseSection(id, status) {
    var arrayTemp = courseSectionsArray;
    var itemIndex = arrayTemp.indexOf(id);
    if (itemIndex === -1)
        arrayTemp.push(id);
    else if (itemIndex > -1)
        arrayTemp.splice(itemIndex, 1);
    courseSectionsArray = arrayTemp;
}

function callbackCourseSections(status, response) {
    if (status !== 200) {
        alert(qsTr("Error!"), qsTr("Cannot load the availables course sections! Try again."));
        return;
    }
    for (var prop in response) {
        if (!prop) return;
        var i = 0;
        if (courseSectionsListModel.count > 0)
            courseSectionsListModel.clear();
        while (i < response[prop].length)
            courseSectionsListModel.append(response[prop][i++]);
    }
    var model = [qsTr("Select the course sections")];
    programCourseSectionsList.model = model;
}

function callbackRegister(status, response) {
    if (status === 200)
        alert(qsTr("Success!"), qsTr("Your register account was created with success!"), "OK", function() { pageStack.pop(); }, function() { pageStack.pop(); });
    else if (status === 400)
        alert(qsTr("Ops!"), qsTr("Cannot create the account! The email is already associated to another user!"));
    else
        alert(qsTr("Ops!"), qsTr("Cannot load response from the server! Try again."));
}

function isValidRegisterForm() {
    var status = true;
    if (!username.text) {
        status = false;
        alert(qsTr("Ops!"), qsTr("Enter your name!"));
    } else if (!email.text) {
        status = false;
        alert(qsTr("Ops!"), qsTr("Enter your email!"));
    } else if (!Util.isValidEmail(email.text)) {
        status = false;
        alert(qsTr("Ops!"), qsTr("Enter a valid email!"));
    } else if (password1.text !== password2.text) {
        status = false;
        alert(qsTr("Ops!"), qsTr("These passwords don't match!"));
    } else if (courseSectionsArray.length === 0) {
        status = false;
        alert(qsTr("Ops!"), qsTr("Choose at least one course section!"));
    } else if (courseSectionsArray.length > 7) {
        status = false;
        alert(qsTr("Ops!"), qsTr("The number of course section checked is above the limit (7). Fix this and try again."));
    }

    return status;
}

function requestRegister() {
    if (isValidRegisterForm()) {
        var params = ({
          "name": username.text,
          "email": email.text,
          "password": password1.text,
          "program_id": programsList.currentIndex,
          "course_sections": courseSectionsArray
        });
        requestHttp.requestParams = JSON.stringify(params);
        requestHttp.load("add_student", callbackRegister, "POST");
    }
}

function callbackEditUser(status, response) {
    if (status === 200)
        alert(qsTr("Success!"), qsTr("Your account was edited with success!"), "OK", function() { pageStack.pop(); }, function() { pageStack.pop(); });
    else if (status === 400)
        alert(qsTr("Ops!"), qsTr("Cannot edit the account! The email is already associated to another user!"));
    else
        alert(qsTr("Ops!"), qsTr("Cannot load response from the server! Try again."));
}

function isValidEditForm() {
    var status = true;
    if (!username.text) {
        status = false;
        alert(qsTr("Ops!"), qsTr("Enter your name!"));
    } else if (!email.text) {
        status = false;
        alert(qsTr("Ops!"), qsTr("Enter your email!"));
    } else if (!Util.isValidEmail(email.text)) {
        status = false;
        alert(qsTr("Ops!"), qsTr("Enter a valid email!"));
    } /*else if (courseSectionsArray.length === 0) {
        status = false;
        alert(qsTr("Ops!"), qsTr("Choose at least one course section!"));
    } else if (courseSectionsArray.length > 7) {
        status = false;
        alert(qsTr("Ops!"), qsTr("The number of course section checked is above the limit (7). Fix this and try again."));
    }*/

    return status;
}

function requestEditUser(username, email, address, gender) {
    if (isValidEditForm()) {
        var params = ({
          "name": username,
          "email": email,
          "birth_date": "",
          "address": address,
          "type": 1,
          "gender": gender,
          "program_id": programsList.currentIndex,
          "course_sections": courseSectionsArray
        });
        requestHttp.requestParams = JSON.stringify(params);
        requestHttp.load("update_user/" + userProfileData.id, callbackEditUser, "POST");
    }
}

function loadPrograms() {
    requestHttp.load("programs", callbackPrograms);
}

function loadProgramsCourseSections(programId) {
    requestHttp.load("programs_course_sections/"+programId, callbackCourseSections);
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
