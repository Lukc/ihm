import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

Button {
	signal onClicked(int index)

	width: 150
	text: "Alarm"
	//onClicked: alarmValve(parent.index)
	style: ButtonStyle {
		background: Rectangle {
			color: checked ? "#FF0000" : "#00FF00"
		}
		label: Text {
			color: checked ? "#FFFFFF" : "#000000"
			text: checked ? "ALARMED" : "Ok"
		}
	}
}
