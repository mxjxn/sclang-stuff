s.boot;
(
{
	var freq = 220;
	var modf = freq*3;
   Fold.ar(
		EnvGen.kr(Env.linen(0.01,1,0.5),doneAction:2) *
		LFTri.ar(
			freq +
			SinOsc.kr(modf,0, XLine.kr(freq*8,freq/5,1)))
	* 0.2
}.play
)