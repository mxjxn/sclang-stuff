Buffer

(


    SynthDef(\grainbuf, { | buf |
    var sound; 
    sound = GrainBuf.ar(1, 
                Impulse.kr(10),                                           //trigger rate
                0.34,                                                     //grain duration
                buf,                                                      //buffer
                1,
                Line.kr(0,BufFrames.kr(buf)/2)                            //pos
            );
    sound = EnvGen.kr(Env.perc(0,0.5),doneAction:2) * 0.5 * sound;
    sound = Fold.ar(sound*3, -1,1)*0.7;
    Out.ar(0,sound);
    }).add;

    SynthDef(\foldbuf, {|buf| 
        Out.ar(0, 
            Clip.ar(Fold.ar(PlayBuf.ar(1,buf,doneAction:2),-0.3,0.3)* 6,-0.9,0.9 )
        )
    }).add;

)
b = Buffer.read(s, "/Users/MXJXN/workspace/cryptobeat-daw/sounds/TR909Tape/BD-TAPE1.wav")
x = Synth(\grainbuf,[\buf, b]);
x = Synth(\foldbuf,[\buf, b]);
