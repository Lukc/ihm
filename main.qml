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

			var waterLevel = Simulation.getWaterLevel();

			waterLevelIndicator.value = 1. * waterLevel/10;
			waterLevelAutoIndicator.value = 1. * waterLevel / 10
			waterLevelText.text = (waterLevel * 10) + " %"

			upperSide.isValveOpened = Simulation.getValveOpened(0);
			lowerSide.isValveOpened = Simulation.getValveOpened(1);
			upperSide.isValveAlarmed = Simulation.getValveAlarm(0);
			lowerSide.isValveAlarmed = Simulation.getValveAlarm(1);

			upperSide.isGateAlarmed = Simulation.getGateAlarm(0);
			lowerSide.isGateAlarmed = Simulation.getGateAlarm(1);

			upperSide.gateProgress = Simulation.getGateProgress(0);
			lowerSide.gateProgress = Simulation.getGateProgress(1);

			upperGateProgressBar.value = 1 - Simulation.getGateProgress(0);
			lowerGateProgressBar.value = 1 - Simulation.getGateProgress(1);

			upperSide.gateStatus = Simulation.getGateStatus(0);
			lowerSide.gateStatus = Simulation.getGateStatus(1);

			if (automatic.visible) {
				if (upperSideAutomaticButton.checked) {
					if (waterLevel == 10) {
						Simulation.openGate(0)

						if (Simulation.getGateProgress(0) == 1) {
							upperSideAutomaticButton.checked = false;

							Simulation.setSignal(0, "green");
							Simulation.unsetSignal(0, "red");
							Simulation.setSignal(1, "red");
							Simulation.unsetSignal(1, "green");
							Simulation.closeValve(0);
						}
					} else if (waterLevel == 0) {
						Simulation.closeGate(1);

						if (Simulation.getGateProgress(1) == 0) {
							Simulation.openValve(0);
						}
					}
				} else if (lowerSideAutomaticButton.checked) {
					if (waterLevel == 10) {
						Simulation.closeGate(0);

						if (Simulation.getGateProgress(0) == 0) {
							Simulation.openValve(1);
						}
					} else if (waterLevel == 0) {
						Simulation.openGate(1)

						if (Simulation.getGateProgress(1) == 1) {
							lowerSideAutomaticButton.checked = false;

							Simulation.setSignal(1, "green");
							Simulation.unsetSignal(1, "red");
							Simulation.setSignal(0, "red");
							Simulation.unsetSignal(0, "green");
							Simulation.closeValve(1);
						}
					}
				}
			}
		}
	}

	Column {
		id: automatic
		visible: true

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

				ProgressBar {
					id: lowerGateProgressBar
					width: parent.width
					height: parent.height - 20
					anchors.bottom: parent.bottom
					orientation: Qt.Vertical
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

				ProgressBar {
					id: upperGateProgressBar
					width: parent.width
					height: parent.height - 20
					anchors.bottom: parent.bottom
					orientation: Qt.Vertical
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
					id: lowerValve

					height: 120
					width: 180

					Button {
						id: lowerSideAutomaticButton
						text: "⇐"

						height: parent.height - 20
						width: parent.width
						anchors.bottom: parent.bottom
						checkable: true

						onClicked: {
							if (upperSideAutomaticButton.checked)
								checked = false
							else {
								Simulation.setSignal(0, "red")
								Simulation.setSignal(1, "red")
								Simulation.unsetSignal(0, "green")
								Simulation.unsetSignal(1, "green")
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
					id: upperValve

					height: 120
					width: 180

					Button {
						id: upperSideAutomaticButton
						text: "⇐"

						height: parent.height - 20
						width: parent.width
						anchors.bottom: parent.bottom
						checkable: true

						onClicked: {
							if (lowerSideAutomaticButton.checked)
								checked = false
						}
					}
				}
			}
		}
		Item {
			width: 1
			height: 20
		}
		Button {
			text: "Manual Control"
			onClicked: {
				automatic.visible = false
				loginGrid.visible = true
			}
		}
	}

	LoginGrid {
		id: loginGrid
		visible: false
		onGoBack: {
			loginGrid.visible = false;
			automatic.visible = true;
		}
		onLoggedIn: {
			loginGrid.visible = false;
			manual.visible = true;
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

					onSetSignal: Simulation.setSignal(index, signalColor);
					onUnsetSignal: Simulation.unsetSignal(index, signalColor);

					openGateCondition: function() {
						return Simulation.getWaterLevel() == 10
					}
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

					onSetSignal: Simulation.setSignal(index, signalColor);
					onUnsetSignal: Simulation.unsetSignal(index, signalColor);

					openGateCondition: function() {
						console.log(" // " + Simulation.getWaterLevel() == 0)
						return Simulation.getWaterLevel() == 0
					}
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

