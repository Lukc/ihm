import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

Button {
	property bool locked: false

	id: openValveButton
	style: ButtonStyle {
		background: Rectangle {
			color: locked ? "#888888" : "#DDDDDD"
		}
	}
}

