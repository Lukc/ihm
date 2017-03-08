
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
		status: "no-op",
		alarm: false
	},
	{
		open: 0.,
		status: "no-op",
		alarm: false
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
			console.log("Alarm?");

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

	console.log("Updated. " + gates[0].open);
	console.log(getGateProgress(0) + ":" + getGateStatus(0) + ":" + getGateAlarm(0))
}

function getWaterLevel() {
	return waterLevel - waterLevel % 1;
}

function getValveAlarm(index) {
	console.log("Alarm of " + index + "…")
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

