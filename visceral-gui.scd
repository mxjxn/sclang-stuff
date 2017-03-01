// ViSCera -- Vim-like Tracker for supercollider composition

(

  var maxBounds = Window.availableBounds,
  font = "Coder's Crux";
  w=Window.new("ViSCera",maxBounds);
  w.view.decorator = FlowLayout(w.view.bounds,1@1,1@1);

  // Toolbar
  v = CompositeView.new(w,w.view.bounds);
  v.decorator = FlowLayout(v.bounds,18@1,2@1);
  StaticText(v,Rect(0,0,167,34))
  .string_("ViSCeral")
  .stringColor_(Color.red)
  .align_(\bottom)
  .background_(Color.black)
  .font_(Font(font,50));
  ~current= CompositeView(v,Rect(0,0,50,84));
  ~current.layout = StackLayout(
     NumberBox(~current, Rect(0,0,32,32)),
    StaticText().string_("patlen").font_(Font(font,16))
  );

  Font.availableFonts;
  /*
    Tracker View Elements:
     - Tracker-toolbar
       - grid-length
       - lines-per-beat
       - edit-step
     - Instrument List
     - Buffer List
     - Audio Bus List
     - Control Bus List
     - Tracker-grid
     (foldable columns!)
       - Environment variables
           - variable name, new value
       - Routine
           - start / stop
       - groups with bus-routing (default: 0, server)
         - instrument/effect
           - index of Instrument in list
           - delay  (128 steps between lines)
           - [node/group, addAction]
           - on / off
           -parameters: [type, value,value2,etc] (value can be float, bus map, bus get, env-var)
             - note
             - amp
             - trigger
             - bufnum
             - in
             - out
     - Current Bus Effect Chain View
     - InstrumentView
       - GUI reflection of current Instrument/Effect in focus
         - 

    Buffer Editor View Elements:
     - Waveform-View
       - Selectable
       - amp envelope line graph
     - WaveShaping Toolbar
       - Add point to envelope
       - generate waveform (sine2 or sine3)
       - combine with ... (new-custom, buffer, file)
  */

  w.front;
 ) 

 (
~buttSynthDef=
  SynthDef(\butt, {|amp,gate,freq| 
    Out.ar(
      [0,1], 
      LFPulse.ar(freq,0,amp) * EnvGen.kr(Env.adsr,gate,doneAction:2)
    )
  }).add;
)
~buttSynthDef.allControlNames.do(_.postln);

// the popupmenu contains the various modes

(
w = Window("soundfile test", Rect(200, 200, 720, 250));

p = PopUpMenu(w, Rect(10,10,80,24))
    .items_( Array.fill(9, {arg i; (i+1).asString;}) )
    .action_({ arg sbs;
        a.resize_(sbs.value+1);
    });

f = SoundFile.new;
f.openRead(Platform.resourceDir +/+ "sounds/a11wlk01.wav");

a = SoundFileView(w, Rect(10,40, 700, 180))
    .soundfile_(f)
    .readWithTask(0, f.numFrames, showProgress: false )
    .resize_(1);

w.front;
)


