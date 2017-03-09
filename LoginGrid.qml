import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.2

Grid {
	columns: 2
	rows: 4
	spacing: 5

	anchors.horizontalCenter: parent.horizontalCenter
	anchors.verticalCenter: parent.verticalCenter

	signal loggedIn()
	signal goBack()

	Text {
		text: "Login: "
	}
	TextField {
		id: login
		width: 180
	}
	Text {
		text: "Password: "
	}
	TextField {
		id: password
		echoMode: TextInput.Password
		width: 180
	}

	Item { width: 5; height: 5}
	Item { width: 5; height: 5}

	Button {
		text: "Go back"
		onClicked: goBack();
	}
	Button {
		text: "Log in!"

		width: 180

		onClicked: {
			if (login.text == "foo" && password.text == "bleh") {
				loggedIn();
			}
		}
	}
}

