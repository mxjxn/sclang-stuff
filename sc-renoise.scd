s.boot;

(

    var win,sections,sectArray,renoiseAddr,combBtn,tempoNum;
    renoiseAddr = NetAddr.new("127.0.0.1", 13131);

    win = Window.new("RENOISE CONTROL", Rect(0,0,300,500));
    win.front;


    // Section button-grid
    // loops selected section (group of patterns) and schedules first pattern in group
    sectArray = ["1","2"];
    sections = ListView.new(win, Rect(5,5,60,35))
               .background_(Color.cyan(1,0.3))
               .items_(sectArray)
               .selectionMode_(\single)
               .selectionAction_({|aa| 
                  var sel = sectArray.at(aa.selection);
                  renoiseAddr.sendMsg("/renoise/transport/loop/sequence", sel,sel);
                  renoiseAddr.sendMsg("/renoise/song/sequence/schedule_set", sel)
               });

    tempoNum = EZNumber.new(win, Rect(70,5,95,35),"tempo",ControlSpec(32,300,\lin,1,120))
              .action_({|aa| renoiseAddr.sendMsg("/renoise/song/bpm", aa.value)});

    combBtn = Button.new(win, Rect(5,70, 120, 35))
              .states_([
                  ["Comb Sweep",Color.black,Color.green(1,0.1)],
                  ["Comb Sweeping",Color.red,Color.green]
              ])
              .action_({|aa|
                  if(aa.value == 1){
                        "aa...".post;
                        aa.value.postln;
                    Routine { |fuu| "fuuu: ".post;fuu.postln;
                        128.do{|i|
                            renoiseAddr.sendMsg("/renoise/song/track/2/device/2/set_parameter_by_name", "Transpose", i/128.0); 
                            0.01.wait;
                        };
                        128.do{|i|
                            renoiseAddr.sendMsg("/renoise/song/track/2/device/2/set_parameter_by_name", "Transpose", (128-i)/128.0); 
                            0.01.wait;
                        };
                        //combBtn.states = [["Comb Sweep",Color.black,Color.green(1,0.1)], ["Comb Sweeping",Color.red,Color.green]];
                    }.play;
                  };
              });
)
