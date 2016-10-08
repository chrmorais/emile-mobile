import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QMob.Meg 1.0 as Meg

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    property string username

    Meg.JSONListModel {
        id: jsonListModel
        source: "http://127.0.0.1:5000/login"
        requestMethod: "POST"
        onStateChanged: {
            if (jsonListModel.state === "ready")
                username = jsonListModel.model.get(0)['attributes']['displayName'].toString()
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent

        Item {
            ColumnLayout {
                anchors.centerIn: parent

                Label {
                    font.pixelSize: 30
                    text: "Emile"
                    Layout.preferredWidth: login.width
                    horizontalAlignment: Text.AlignHCenter
                }
                TextField {
                    id: login
                    placeholderText: qsTr("Login")
                }
                TextField {
                    id: password
                    placeholderText: qsTr("Password")
                    echoMode: TextInput.Password
                }
                Label {
                    id: errorMessage
                    color: "red"
                    Layout.preferredWidth: login.width
                    horizontalAlignment: Text.AlignHCenter
                    text: (jsonListModel.httpStatus == 401) ? "Login failed!" : (jsonListModel.count > 0) ? "Welcome " + username + "!" : ""
                }
                Button {
                    id: loginButton
                    Layout.preferredWidth: login.width
                    text: "login"
                    onClicked: {
                        jsonListModel.requestParams = "email=" + login.text + "&password=" + password.text
                        jsonListModel.load()
                    }
                }
                BusyIndicator {
                    anchors.horizontalCenter: loginButton.horizontalCenter
                    running: jsonListModel.state === "loading"
                }
            }
        }
    }
}
