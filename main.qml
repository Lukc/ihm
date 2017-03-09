import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.2

import "simulation.js" as Simulation

ApplicationWindow {
	id: root
	visible: true

	menuBar: MenuBar {
		Menu {
			title: "Simulation Control"

			MenuItem {
				text: "Make it Fail™"
				onTriggered: Simulation.addFailures()
			}
			MenuItem {
				text: "Bleh"
			}
		}
	}

	Timer {
		interval: 100
		repeat: true
		running: true
		onTriggered: {
			Simulation.update();

			waterLevelIndicator.value = 1. * Simulation.getWaterLevel()/10;
			waterLevelAutoIndicator.value = 1. * Simulation.getWaterLevel() / 10
			waterLevelText.text = (Simulation.getWaterLevel() * 10) + " %"

			upperSide.isValveAlarmed = Simulation.getValveAlarm(0);
			lowerSide.isValveAlarmed = Simulation.getValveAlarm(1);

			upperSide.isGateAlarmed = Simulation.getGateAlarm(0);
			lowerSide.isGateAlarmed = Simulation.getGateAlarm(1);

			upperSide.gateProgress = Simulation.getGateProgress(0);
			lowerSide.gateProgress = Simulation.getGateProgress(1);

			upperSide.gateStatus = Simulation.getGateStatus(0);
			lowerSide.gateStatus = Simulation.getGateStatus(1);

			console.log("Valves: " + upperSide.isValveAlarmed + "/" + lowerSide.isValveAlarmed);
			console.log("Gates: " + upperSide.isGateAlarmed + "/" + lowerSide.isGateAlarmed);
		}
	}

	Column {
		id: automatic
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter

		Row {
			Rectangle {
				width: 180
				height: 180
				anchors.bottom: parent.bottom
			}
			GroupBox {
				title: "Gate"
				height: 220
				width: 80

				Button {
					width: parent.width
					height: parent.height - 20
					anchors.bottom: parent.bottom

					checkable: true

					// FIXME: Checkable?

					onClicked: {
						if (checked) {
							Simulation.openGate(1);
						} else {
							Simulation.closeGate(1);
						}
					}
				}
			}
			ProgressBar {
				id: waterLevelAutoIndicator
				width: 180
				height: 180
				orientation: Qt.Vertical
				anchors.bottom: parent.bottom
				value: Simulation.getWaterLevel() / 10
			}
			GroupBox {
				title: "Gate"
				height: 220
				width: 80

				Button {
					width: parent.width
					height: parent.height - 20
					anchors.bottom: parent.bottom

					checkable: true

					onClicked: {
						if (checked) {
							Simulation.openGate(0);
						} else {
							Simulation.closeGate(0);
						}
					}
				}
			}
			Rectangle {
				width: 180
				height: 180
				anchors.bottom: parent.bottom
				color: "#328CE7"
			}
		}
		Column {
			anchors.horizontalCenter: parent.horizontalCenter

			Row {
				GroupBox {
					title: "Valve"

					height: 120
					width: 180

					Button {
						text: "⇐"

						height: parent.height - 20
						width: parent.width
						anchors.bottom: parent.bottom
						checkable: true

						onClicked: {
							if (checked) {
								Simulation.openValve(1);
							} else {
								Simulation.closeValve(1);
							}
						}
					}
				}
				Item {
					width: 60
					height: 10
				}
				GroupBox {
					title: "Valve"

					height: 120
					width: 180

					Button {
						text: "⇐"

						height: parent.height - 20
						width: parent.width
						anchors.bottom: parent.bottom
						checkable: true

						onClicked: {
							if (checked) {
								Simulation.openValve(0);
							} else {
								Simulation.closeValve(0);
							}
						}
					}
				}
			}
		}
		Button {
			text: "Contrôle manuel"
			onClicked: {
				automatic.visible = false
				loginGrid.visible = true
			}

			anchors.bottom: parent.parent.bottom - 20
			anchors.left: parent.parent.left + 20
		}
	}

	Grid {
		id: loginGrid
		visible: false
		columns: 2
		rows: 3

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter

		Text {
			text: "Login: "
		}
		TextField {
			id: login
		}
		Text {
			text: "Password: "
		}
		TextField {
			id: password
			echoMode: TextField.Password
		}
		Button {
			text: "Go back"
			onClicked: {
				loginGrid.visible = false;
				automatic.visible = true;
			}
		}
		Button {
			text: "Log in!"

			onClicked: {
				if (login.text == "foo" && password.text == "bleh") {
					loginGrid.visible = false;
					manual.visible = true;
				}
			}
		}
	}

	Grid {
		id: manual
		visible: false

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter

		ColumnLayout {
			GridLayout {
				columns: 2
				rows: 2

				ValveButton {
					Layout.row: 1
					Layout.column: 1

					title: "Upper Side"
					id: upperSide

					index: 0

					onOpenValve: Simulation.openValve(index)
					onCloseValve: Simulation.closeValve(index)
					onAlarmValve: Simulation.restoreValve(index)

					onOpenGate: Simulation.openGate(index)
					onCloseGate: Simulation.closeGate(index)
					onAlarmGate: Simulation.restoreGate(index)
					onStopGate: Simulation.stopGate(index)
					gateProgress: Simulation.getGateProgress(index);
				}

				ValveButton {
					Layout.row: 2
					Layout.column: 1

					title: "Lower Side"
					id: lowerSide

					index: 1

					onOpenValve: Simulation.openValve(index)
					onCloseValve: Simulation.closeValve(index)
					onAlarmValve: Simulation.restoreValve(index)

					onOpenGate: Simulation.openGate(index)
					onCloseGate: Simulation.closeGate(index)
					onAlarmGate: Simulation.restoreGate(index)
					onStopGate: Simulation.stopGate(index)
					gateProgress: Simulation.getGateProgress(index);
				}

				ColumnLayout {
					Layout.row: 1
					Layout.column: 2
					Layout.columnSpan: 2

					GroupBox {
						title: "Water level"
						width: 80

						ProgressBar {
							height: 500
							width: parent.width

							id: waterLevelIndicator

							value: 1. * Simulation.getWaterLevel()/10

							orientation: Qt.Vertical

							Text {
								id: waterLevelText
								text: ""
							}
						}
					}
				}
			}
		
			GroupBox {
				title: "Alert management"

				RowLayout {
					Button {
						text: "Alert"
						onClicked: {
							Simulation.lockEverything();
						}
					}
					Button {
						text: "Stop alerts"
						onClicked: {
							Simulation.restoreValve(0);
							Simulation.restoreValve(1);
							Simulation.restoreGate(0);
							Simulation.restoreGate(1);
						}
					}
				}
			}
			Button {
				text: "Mode automatique"
				onClicked: {
					manual.visible = false
					automatic.visible = true
				}
			}
		}
	}

	statusBar: StatusBar {
		RowLayout {
			anchors.fill: parent

			Label {
				text: "~~ Running in simulation mode."
			}
		}
	}
}

