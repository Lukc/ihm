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
	signal stopGate(int id)

	signal setSignal(int id, string signal)
	signal unsetSignal(int id, string signal)

	property string signalColor: "red"

	ColumnLayout {
		width: 800

		Rectangle {
			Layout.minimumHeight: 80
			Layout.preferredWidth: parent.width
			Layout.topMargin: 30

			Row {
				anchors.verticalCenter: parent.verticalCenter
				spacing: 5

				Text {
					width: 100

					text: "Valve"
				}
				ExclusiveGroup {
					id: valveGroup
				}
				Button {
					text: "Open"
					width: 153
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
					checked: gateProgress == 1
					exclusiveGroup: valveGroup
				}
				Button {
					text: "Close"
					width: 152
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
					checked: gateProgress == 0
					exclusiveGroup: valveGroup
				}
				AlarmButton {
					checked: isValveAlarmed
					onClicked: alarmValve(index)
				}
			}
		}
		Rectangle {
			Layout.minimumHeight: 120
			Layout.preferredWidth: parent.width

			Row {
				spacing: 5

				Text {
					width: 100

					text: "Gate"
				}

				Column {
					Layout.row: 2
					spacing: 5

					ExclusiveGroup {
						id: gateGroup
					}

					Item {
						width: 1
						height: 5
					}

					Row {
						spacing: 5

						Button {
							text: "Open"
							width: 100
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
							text: "Stop"
							width: 100
							checkable: true
							checked: false
							exclusiveGroup: gateGroup
							onClicked: {
								isGateOpening = false
								stopGate(index)
							}
						}
						Button {
							text: "Close"
							width: 100
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
						spacing: 5

						ProgressBar {
							id: gateProgressBar
							Layout.preferredWidth: parent.width
							value: gateProgress
							height: 40
						}
						Text {
							id: gateStatusText
							text: gateStatus
							anchors.verticalCenter: parent.verticalCenter
						}
					}
				}
				Item {
					width: 5
					height: 1
				}
				ColumnLayout {
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
							onClicked: {
								signalColor = "red"

								if (checked) {
									setSignal(index, "red")
								} else {
									unsetSignal(index, "red")
								}
							}
						}
						Button {
							text: "Green"
							checkable: true
							onClicked: {
								signalColor = "green"

								if (checked) {
									setSignal(index, "green")
								} else {
									unsetSignal(index, "green")
								}
							}
						}
					}
				}
			}
		}
	}
}

