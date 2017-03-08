import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

GroupBox {
	property int index: 0

	property bool isValveOpened: false
	property bool isDoorClosed: true
	property bool isValveAlarmed: false

	property real gateProgress: 0
	property string gateStatus: "[status]"
	property bool isGateAlarmed: false
	property bool isGateOpening: true

	signal openValve(int id)
	signal closeValve(int id)
	signal alarmValve(int id)

	signal openGate(int id)
	signal closeGate(int id)
	signal alarmGate(int id)

	ColumnLayout {
		width: 800

		Rectangle {
			Layout.topMargin: 30

			Row {
				anchors.verticalCenter: parent.verticalCenter

				Text {
					width: 100

					text: "Valve"
				}
				ExclusiveGroup {
					id: valveGroup
				}
				Button {
					text: "Open"
					id: openValveButton
					onClicked: {
						if (isValveAlarmed) {
							checked = isValveOpened;
							closeValveButton.checked = !isValveOpened;
							return;
						}

						isValveOpened = true
						openValve(index)
					}
					checkable: true
					checked: isValveOpened;
					exclusiveGroup: valveGroup
				}
				Button {
					text: "Close"
					id: closeValveButton
					onClicked: {
						if (isValveAlarmed) {
							checked = !isValveOpened;
							openValveButton.checked = isValveOpened;
							return;
						}

						isValveOpened = false
						closeValve(index)
					}
					checkable: true
					checked: isValveClosed
					exclusiveGroup: valveGroup
				}
				AlarmButton {
					checked: isValveAlarmed
					onClicked: alarmValve(index)
				}
			}

			Layout.minimumHeight: 80
			Layout.preferredWidth: parent.width
		}
		Rectangle {
			Layout.minimumHeight: 120
			Layout.preferredWidth: parent.width
			RowLayout {
				Rectangle {
					width: 100

					Text {
						text: "Gate"
					}
				}
				Column {
					Layout.row: 2

					ExclusiveGroup {
						id: gateGroup
					}

					Row {
						Button {
							text: "Open"
							checkable: true
							exclusiveGroup: gateGroup
							onClicked: {
								if (isGateAlarmed) {
									checked = isGateOpening;
									closeGateButton.checked = !isGateOpening;
									return;
								}

								isGateOpening = true
								openGate(index)
							}
						}
						Button {
							text: "Close"
							checkable: true
							checked: true
							exclusiveGroup: gateGroup
							onClicked: {
								if (isGateAlarmed) {
									checked = !isGateOpening;
									closeGateButton.checked = !sGateOpened;
									return;
								}

								isGateOpening = false
								closeGate(index)
							}
						}
						AlarmButton {
							checked: isGateAlarmed
							onClicked: alarmGate(index)
						}
					}
					Row {
						ProgressBar {
							id: gateProgressBar
							Layout.preferredWidth: parent.width
							value: gateProgress
							height: 40
						}
						Text {
							id: gateStatusText
							text: gateStatus
						}
					}
				}
				ColumnLayout {
					Layout.row: 3

					Rectangle {
						height: 40

						Text {
							text: "Signals"
						}
					}
					RowLayout {
						Button {
							text: "Red"
							checkable: true
						}
						Button {
							text: "Green"
							checkable: true
						}
					}
				}
			}
		}
	}
}

