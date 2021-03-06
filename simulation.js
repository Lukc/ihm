
var waterLevel = 0;

var valves = [
	{
		open: false,
		alarm: false
	},
	{
		open: false,
		alarm: false
	}
];

var gates = [
	{
		open: 0.,
		status: "closed",
		alarm: false,
		green: false,
		red: false
	},
	{
		open: 1.,
		status: "open",
		alarm: false,
		green: false,
		red: false
	}
];

function openValve(id) {
	if (valves[id].alarm)
		return false;

	valves[id].open = true
}

function closeValve(id) {
	if (valves[id].alarm)
		return false;

	valves[id].open = false
}

function openGate(id) {
	if (gates[id].alarm)
		return false;

	gates[id].status = "opening";
}

function closeGate(id) {
	if (gates[id].alarm)
		return false;

	gates[id].status = "closing";
}

function update() {
	var speed = valves[0].open && valves[1].open ? 0.1 : 0.5;

	if (valves[1].open) {
		if (valves[0].open) {
			if (waterLevel > 5) {
				waterLevel -= speed

				if (waterLevel < 5)
					waterLevel = 5;
			}
		} else {
			waterLevel -= speed;

			if (waterLevel < 0)
				waterLevel = 0;
		}
	}

	if (valves[0].open) {
		if (valves[1].open) {
			if (waterLevel < 5) {
				waterLevel += speed;

				if (waterLevel > 5)
					waterLevel = 5;
			}
		} else {
			waterLevel += speed;

			if (waterLevel > 10)
				waterLevel = 10;
		}
	}

	for (var i = 0; i < 2; i++) {
		var gate = gates[i];

		if (gate.alarm) {
			continue;
		}

		if (gate.status == "opening") {
			gate.open += 0.05

			if (gate.open > 1) {
				gate.open = 1;

				gate.status = "open"
			}
		} else if (gate.status == "closing") {
			gate.open -= 0.05

			if (gate.open < 0) {
				gate.open = 0;

				gate.status = "closed"
			}
		}
	}
}

function getWaterLevel() {
	return waterLevel - waterLevel % 1;
}

function getValveOpened(index) {
	return valves[index].open
}

function getValveAlarm(index) {
	return valves[index].alarm
}

function getGateAlarm(index) {
	return gates[index].alarm
}

function restoreValve(index) {
	valves[index].alarm = false
}

function restoreGate(index) {
	gates[index].alarm = false
}

function stopGate(index) {
	if (gates[index].open == 0) {
		return;
	} else if (gates[index].open == 1) {
		return;
	}
	gates[index].status = "stopped"
}

function addFailures() {
	valves[0].alarm = true
	gates[1].alarm = true
}

function getGateProgress(index) {
	return gates[index].open;
}

function getGateStatus(index) {
	return gates[index].status;
}

function lockEverything(index) {
	gates[0].alarm = true;
	gates[1].alarm = true;
	valves[0].alarm = true;
	valves[1].alarm = true;
}

function setSignal(index, signal) {
	console.log("Setting " + signal + " for the " + (index ? "lower" : "upper") + "side.");
	gates[index][signal] = true
}

function unsetSignal(index, signal) {
	console.log("Unsetting " + signal + " for the " + (index ? "lower" : "upper") + "side.");
	gates[index][signal] = false
}

