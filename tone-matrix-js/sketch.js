//------------------------------------------------------------------------------
//osc vars
let note = [96, 93, 91, 89, 86, 84, 81, 79, 77, 74, 72, 69, 67, 65, 62, 60];
var gain = 0.5;
var attack = 0.001;
var decay = 0.001;
var sustain = 0.75;
var release = 0.7;
var osc_bank = [];
//------------------------------------------------------------------------------
var s = note.length;
var screensize = 380;
//------------------------------------------------------------------------------
// Grid Vars
var spacer = screensize / (4 * s);
var dotSize = (screensize / s) - (spacer);
//------------------------------------------------------------------------------
// beat vars
var beat = 0;
let framesPerBeat = 8;
//------------------------------------------------------------------------------
var pat = new Pattern();
//------------------------------------------------------------------------------
function midi2Hz(midiNoteNumber)
{
  return Math.pow(2, (midiNoteNumber - 69) / 12.0) * 440.0;
}
//------------------------------------------------------------------------------
function playNote(step, note)
{
  osc_bank[step][note].amp(gain, attack);
  osc_bank[step][note].amp(gain * sustain, decay);
  osc_bank[step][note].amp(0.0, release);
}

function playSound()
{
  if (beat == 0)
  {
    // do something on every sequence loop
  }

  for (var i = 0; i < 16; i++)
  {
    if (pat.getStep(beat, i))
    {
      playNote(beat, i);
    }
  }
}
//------------------------------------------------------------------------------
function setup()
{
  createCanvas(screensize + spacer, screensize + spacer);
  background(0);

  for (var j = 0; j < s; j++)
  {
    osc_bank.push([]);
    for (var i = 0; i < s; i++)
    {
      osc_bank[j].push(new p5.Oscillator());
      osc_bank[j][i].setType('sine');
      osc_bank[j][i].freq(midi2Hz(note[i]));
      osc_bank[j][i].amp(0);
      osc_bank[j][i].start();
    }
  }
}

//------------------------------------------------------------------------------

function draw()
{
  pat.draw();
  if ((frameCount % framesPerBeat) == 0)
  {
    playSound();
    beat++;
    beat %= note.length;
  }
}
//------------------------------------------------------------------------------
function mouseDragged()
{
  var note = Math.floor(constrain((mouseX * s) / width, 0, s - 1));
  var beat = Math.floor(constrain((mouseY * s) / height, 0, s - 1));
  pat.setStepNote(note, beat, true);
}
