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
function midi2Hz(midiNoteNumber)
{
  return Math.pow(2, (midiNoteNumber - 69) / 12.0) * 440.0;
}
//------------------------------------------------------------------------------
function playNote(i)
{
  osc_bank[i].amp(gain, attack);
  osc_bank[i].amp(gain * sustain, decay);
  osc_bank[i].amp(0.0, release);
}

function playSound()
{
  if (beat == 0)
  {
    //pat.setRandomBlock();
  }

  for (var i = 0; i < 16; i++)
  {

  }
}
//------------------------------------------------------------------------------
function setup()
{
  createCanvas(screensize + spacer, screensize + spacer);
  background(0);
  setPattern();
  for (var i = 0; i < note.length; i++)
  {
    osc_bank.push(new p5.Oscillator());
    osc_bank[i].setType('sine');
    osc_bank[i].freq(midi2Hz(note[i]));
    osc_bank[i].amp(0);
    osc_bank[i].start();
  }
}

//------------------------------------------------------------------------------

function draw()
{
  if ((frameCount % framesPerBeat) == 0)
  {
    // playSound();
  playNote(beat);
  playNote(s - beat - 1);
  beat++;
  beat %= note.length;
  }
}

//------------------------------------------------------------------------------
