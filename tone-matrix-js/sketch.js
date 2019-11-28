//------------------------------------------------------------------------------
if ('serviceWorker' in navigator)
{
  navigator.serviceWorker.register('/js/service-worker.js');   // register service worker
}
//------------------------------------------------------------------------------
//osc vars
let note = [96, 93, 91, 89, 86, 84, 81, 79, 77, 74, 72, 69, 67, 65, 62, 60];
var gain = 0.3;
var attack = 0.001;
var decay = 0.002;
var sustain = 0.707;
var release = 0.2;
var osc_bank = [];
var delay = new p5.Delay();
var canvas;
//------------------------------------------------------------------------------
var s = note.length;
var screensize
if (typeof fullscreenMode != "undefined")
{
  screensize = ($(window).width() < $(window).height()) ? $(window).width() : $(window).height();
  screensize *= 4.0/5.0;
}
else
{
  screensize = (4 * $("#sketch-holder").width()) / 5;
}
//------------------------------------------------------------------------------
// Grid Vars
var spacer = screensize / (4 * s);
var dotSize = (screensize / s) - (spacer);
//------------------------------------------------------------------------------
// beat vars
var beat = 0;
let framesPerBeat = 8;
//------------------------------------------------------------------------------
var pat = new Pattern(s);
var glow_rect;
var glow_size = dotSize + (spacer * 4);
var glow_rect_size = (dotSize + spacer) / 1.1;
var drawLock = false;
var drawStyle; // are we adding or removing blocks
//------------------------------------------------------------------------------
function windowResized()
{
  if (typeof fullscreenMode != "undefined")
  {
    screensize = ($(window).width() < $(window).height()) ? $(window).width() : $(window).height();
    screensize *= 4.0/5.0;
    var x = (windowWidth - width) / 2;
    var y = (windowHeight - height) / 2;
    canvas.position(x, y);
    console.log(screensize);
  }
  else
  {
    screensize = (4 * $("#sketch-holder").width()) / 5;
  }
  spacer = screensize / (4 * s);
  dotSize = (screensize / s) - (spacer);
  glow_size = dotSize + (spacer * 4);
  glow_rect_size = (dotSize + spacer) / 1.1;
  glow_rect = createGraphics(glow_size, glow_size, P2D);
  glow_rect.background(0, 0);
  glow_rect.fill(255, 255);
  glow_rect.rectMode(CENTER);
  glow_rect.rect(glow_size / 2, glow_size / 2, glow_rect_size, glow_rect_size);
  glow_rect.filter(BLUR, 4);
  glow_rect.loadPixels();
  glow_rect.updatePixels();
  glow_rect.filter(DILATE);
  resizeCanvas(screensize + spacer, screensize + spacer);
}
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

  for (var i = 0; i < s; i++)
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
  canvas = createCanvas(screensize + spacer, screensize + spacer, P2D);
  canvas.parent('sketch-holder');
  if (typeof fullscreenMode != "undefined")
  {
    var x = (windowWidth - width) / 2;
    var y = (windowHeight - height) / 2;
    canvas.position(x, y);
  }

  glow_rect = createGraphics(glow_size, glow_size, P2D);
  glow_rect.background(0, 0);
  glow_rect.fill(255, 255);
  glow_rect.rectMode(CENTER);
  glow_rect.rect(glow_size / 2, glow_size / 2, glow_rect_size, glow_rect_size);
  glow_rect.filter(BLUR, 4);
  glow_rect.loadPixels();
  glow_rect.updatePixels();
  glow_rect.filter(DILATE);

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
      delay.process(osc_bank[j][i], .2, .2, 2300);
    }
  }
}

//------------------------------------------------------------------------------

function draw()
{
  background(0);
  pat.draw();
  if ((frameCount % framesPerBeat) == 0)
  {
    playSound();
    beat++;
    beat %= note.length;
  }
}
