s.boot;
(
SynthDef(\fm1, {
  arg freq=440,gate=1,amp=0.5, lagtime=0.05,
  ampatk=0.001,ampdec=0.12,ampsus=0.7,amprls=0.01,
  modamp=0.8,modratio=0.5,modatk=0.001,moddec=0.3,modsus=0.25,modrls=1,
  fampratio=4, ffreq= 150, fatk=0.01, fdec=0.2, fsus=0.4,frls=0.5,out;

  var mod, synth, fenv; 
  mod = LFPar.ar(Lag.kr(freq,lagtime) * modratio, 0.1, freq*modamp) * EnvGen.kr(Env.adsr(modatk,moddec,modsus,modrls),gate);
  synth = LFPar.ar(freq + mod, 0, amp) * EnvGen.kr(Env.adsr(ampatk,ampdec,ampsus,amprls),gate,doneAction:2);
  fenv = EnvGen.kr(Env.adsr(fatk,fdec,fsus,frls),gate,fampratio*ffreq);
  synth = MoogFF.ar(synth,ffreq+fenv);
  Out.ar([0,1],synth)
}).add;

SynthDef(\folder,{|in=0,out=0,amp=0.5| Out.ar(out,Fold.ar(In.ar(in),-0.9,0.9)*amp)}).add;

SynthDef(\mxPlay, {
  |amp=0.5,bufnum,gate=1,out=0,rls=0.01|
  var sound = Pan2.ar(
                PlayBuf.ar(1,bufnum)
                * EnvGen.kr(Env.adsr(0.0001,0.3,0.6,rls),gate,doneAction:2)
                * amp
              );
  Out.ar(out, sound);
}).add;

  SynthDef(\mxCrunch, {
    |amp=0.5, drive=1.4,i_in=0,out=0|
    OffsetOut.ar(out, 
      Pan2.ar(
        CombL.ar(
          Fold.ar(
            In.ar(i_in) *drive*MouseX.kr(0.1,10), -0.8,0.8
          ) * amp,
          0.06,0.01,0.02
        )
      )
    );
  }).add;

  SynthDef(\mxComp, {
    |in=0, i_sidegate=0,out=0|
    Out.ar(out,
      Pan2.ar(
        Fold.ar(
          Compander.ar(
            In.ar(in),
            In.ar(i_sidegate),
            0.6,
            slopeAbove:0.15,
            clampTime:0.05,
            relaxTime:0.18),
          -0.9,0.9)
        )
      )
  }).add;
  
  //MIX IT UP
  SynthDef(\mxMixer, {
    |source1, source2|
    var sounds = Mix.new([
      In.ar(source1),
      In.ar(source2)
    ]);
    Out.ar([0,1],sounds);
  }).add;

)
(

~b1 = Buffer.read(s,"/home/eris1/sounds/808909/808 kick 1.wav");
~b2 = Buffer.read(s,"/home/eris1/sounds/808909/808 snare 1.wav");
~b3 = Buffer.read(s,"/home/eris1/sounds/808909/808 rim.wav")
)
(
var kik, snr, rim,  mxPlay, kikbeat, rimbeat, snrbeat, 
    bupnotes, bupdur,bupper, fm,
    groups = List.new(4);
    ~kikbus = Bus.audio(s,2);
    ~cmpbus = Bus.audio(s,2);

    
    4.do{groups.add(Group.new(s,'addToTail'));};


// drumstuff
kikbeat = [
  1, \r, \r,  0,
 1, \r,  1, \r,
 \r,  1, \r, \r,
 1, \r,  1, \r];
rimbeat = Array.fill(kikbeat.size, {|bt| if (kikbeat.at(bt) == 1, \r, 1) });
snrbeat = Array.fill(kikbeat.size-2, {|bt| if (bt % 8 == 4, 1, \r) }).addAll([1,1]);
mxPlay = Pbind(\instrument, \mxPlay, \dur, 0.125/2, \addAction, 0);
kik = Pbindf(mxPlay, \bufnum, ~b1, \degree, Pseq(kikbeat), \group, groups[0], \out, ~kikbus,\rls,1);
rim = Pbindf(mxPlay, \bufnum, ~b3, \degree, Pseq(rimbeat), \group, groups[1],\amp, 0.8);
snr = Pbindf(mxPlay, \bufnum, ~b2, \degree, Pseq(snrbeat), \group, groups[1],\amp, 0.8);

// melodystuff

fm =  PmonoArtic(\fm1,
      \out, ~cmpbus,
      \dur, Pseq(((0.125!3)++0.25),inf),
      \ffreq, Pseq([
                Pseq(6*((50!32)++(100!32)++(200!32)++(100!32)),inf)]),
      \fampratio, Pseq(((0.125,0.25..1)*.t[1,2,3]).flatten * 4,inf),
      \lagtime, 0.2,
      \modamp, Pseq((0.0,0.015625..0.984375).pyramid(3),inf),
      \moddec, Pseq((0.1!5)++(0.4!3),inf),
      \modratio,Pclutch(([0.25,0.333,0.45,0.75,0.9].pyramid(5))**16 +1,Pseq([1]++(0!7),inf)),
      \legato, Pseq([0.4,0.8,1],inf),
      \degree, Pseq([1,Pxrand([2,3,4]),5,Pxrand([6,2,3]),7],inf),
      \octave, Pseq([2,3,4,5].pyramid(2),inf),
      \ampatk, Pseq(((0.001!12)++(0.1!4)++(0.05!16)++(0.2!16))*4,inf),
      \ampdec, Pseq((0.1!64)++(0.3!12)++(0.5!20)++(0.2!16)++(0.2!32),5));

TempoClock.default = TempoClock.new(68/120);
Task{
  Ppar([
    kik,rim,snr,
  ],32).play;
  fm.play;

  c = Synth.tail(groups[0],\mxCrunch, [\i_in, ~kikbus, \out, ~kikbus, \drive, 38]);
  k = Synth.tail(groups[0],\mxComp, [\in,~kikbus,\i_sidegate,~kikbus,\out,~kikbus]);
  c = Synth.tail(groups[1],\folder, [\in, ~cmpbus, \out, ~cmpbus, \amp, 0.8]);
  d = Synth.tail(groups[1],\mxComp, [\in,~cmpbus,\i_sidegate,~kikbus,\out,~cmpbus]);
  m = Synth.tail(s,\mxMixer, [\source1, ~kikbus, \source2, ~cmpbus]);
}.play;
)
(
~kikbus.free;~cmpbus.free;c.free; k.free; d.free; m.free;
)
s.queryAllNodes;

s.boot;
TempoClock.stop
s.prepareForRecord;
s.record;
s.stopRecording;
