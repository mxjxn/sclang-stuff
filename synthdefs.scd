// Please put a fuck ton of synthdefs below.
(
SynthDef(\mx1, {
    arg freq=200,amp=0.1,fa=0.996,fb=1.006,gate=0;
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
    sum = sum * EnvGen.kr(Env.perc(0.01,4),doneAction:2);
    sum = Wrap.ar(sum,-0.8,0.8);
    Out.ar(0,sum);
}).add;
)
x = Synth.new(\mx1);
x.free;



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

