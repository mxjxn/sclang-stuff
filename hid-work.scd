(
// Connect to wingman gamepad
var devices=GeneralHID.deviceList;
a = GeneralHID.open(devices[7]);
GeneralHID.startEventLoop;
a.debug_(false);
a.makeGui;
)

//Add action to a button
a.slots[1].at(296)
.action_({|val|
	if(val.value==1,
		{"hi!".postln},
		{"bye".postln})
    }
);
