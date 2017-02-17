// Please put a fuck ton of synthdefs below.
(
SynthDef(\mx1, {
    arg freq=200,amp=0.1,fa=0.996,fb=1.006,gate=1;
    var temp, sum;
    sum=0;
    8.do{
        temp = VarSaw.ar(
             freq * {Rand(fa,fb)}!2,
            {ExpRand(0.005,0.5)}!2,
            {ExpRand(0.005,0.05)}!2
        );
        sum = sum + temp;
    };
    sum = sum * EnvGen.kr(Env.adsr(0.01,0.3,0.5,0.1),gate,doneAction:2);
    sum = Fold.ar(sum,-0.95,0.95);
    Out.ar(0,sum * amp);
}).add;
)
x = Synth(\mx1);
x.free;
(
TempoClock.tempo = 180/60;
a=PmonoArtic(\mx1,
	\legato, 0.8,
	\octave, Pseq([1,1,1,2,1,1,2,2]+.t[1,2.015],inf),
	\scale, Scale.minor,
	\degree,Pseq([0,1,2,5],3),
	\dur,
		Pxrand([
		Pseq([0.5,0.25,0.25]),
		Pseq([0.25,0.25,0.5]),
		Pseq(0.25!4),
			Pseq(0.5!2)],inf)).play;
)
// Additive processes


// Grainsynths
//  load some buffers in an scd file


// independent envelopes

// effects:
// FFT spectral compressors
  // distortion
  // signal math// feedback!!!!!!!!
  // filters
  // delays
  // reverb

