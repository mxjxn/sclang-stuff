(
SynthDef(\LFsynth,{
	arg freq=440, amp1=0.5, amp2=0.5,
	    ff=2000, fq=2, det = 0.1, pw=0.65,
	    dur=0.5,
	    atk=0.02, dec=0.24, sus=0.05, rls=0.07;
	var halfdet = freq*det/2,
	synth = Mix.new(
		Array.fill(4,
			{|aa|LFPulse.ar(freq+Rand(0-halfdet,halfdet),0,pw,amp1)}
		) ++
		Array.fill( 4,
			{|aa|LFSaw.ar(freq+Rand(0-halfdet,halfdet),0,amp2)})
	);
	synth = synth *
	        EnvGen.kr(Env.adsr(atk,dec,sus,rls),
		      Line.kr(1,0,dur)
		      ,doneAction:2);
	synth = MoogFF.ar(synth, ff,fq);
	Out.ar(0,Pan2.ar(synth)*0.5);
}).add;
)
thisProcess.platform.recordingsDir;
s.prepareForRecord;
s.record;
s.stopRecording;
(
var octave = 5,
notes = [0,1,2,4,6,5,4,2],
    scale = Scale.minor;
TempoClock.default = TempoClock.new(80/120);
//PbindProxy
r = Pbind(
	\instrument, \LFsynth,
	\degree, Pseq(notes+.t[0,9],inf),
	\dur, Pseq([0.5],inf),
	\scale, scale,
	\octave,octave,
	\legato, 1.1,
	\rls,1,
	\atk,1,
	\dec,0.4,
	\sus,0.25,
	\det, Pseq((0.01!8)++(1!4)++(2!4),inf),
	\ff, Pseq((1000,1200..4000)++(4000,3800..1000),inf),
	\fq, 2
).play;

)
TempoClock.stop