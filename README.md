FeedbackLoop – Full Journey

A generative visual meditation on rhythm, growth, and decay.
Author: Sasha Collins


Table of Contents

General Info

Technologies Used

Features

Screenshots

Setup

Usage

Project Status

Room for Improvement

Acknowledgements

Contact

General Info

FeedbackLoop – Full Journey is a generative art project that explores cyclical motion and evolving intensity through color, form, and rhythm.
Each “circle” in the system behaves like a breathing organism — expanding, spiraling, and fading over time, while the global energy of the piece rises and falls in a feedback loop.

Problems it explores:

How to simulate organic motion using minimal rules.

How rhythmic oscillations can create a meditative, evolving digital artwork.

Purpose:
To create a soothing, evolving, almost musical visual experience that feels alive yet never repeats exactly.

Motivation:
Built as part of an exploration of generative motion and emotional tone in Processing. The project aims to visualize balance between chaos and calmness — a “journey” of form and color.

Technologies Used

Processing (Java Mode) – version 4.3

Java AWT Graphics – built into Processing

PVector / ArrayList – for motion and particle management

Features

- Evolving feedback loop of color and motion
- Organic spiral-based movement system
- Smooth oscillating intensity that drives generative behavior
- Soft fade trails for persistence and visual depth
- Gentle transitions between chaos and calm

Screenshots

![Uploading Screenshot 2025-11-02 at 3.21.33 PM.png…]()


Example:


Setup

Requirements:

Processing 4.3+

Java (comes bundled with Processing)

Installation:

Clone or download this repository.

Open FeedbackLoop_FullJourney.pde in Processing.

Press Run (▶).

That’s it — the sketch will start generating the visual journey automatically.

Usage

There are no controls — the piece evolves on its own.
However, you can tweak parameters at the top of the sketch to experiment:

int maxCircles = 50;        // Controls the population limit
float journeySpeed = 0.0008; // Controls the speed of intensity oscillation
float baseIntensity = 0.05;  // Minimum visual intensity


To record the visuals, use Processing’s built-in saveFrame() function (or screen capture).


# FeedbackLoop
// FeedbackLoop - Full Journey
// Sasha Collins
// Processing (Java Mode)

ArrayList<CircleParticle> circles;
int maxCircles = 50;
float journeyProgress = 0;  // 0 -> 1 -> 0
float journeySpeed = 0.0008; // slower for a long evolution
float baseIntensity = 0.05;

color[] palette;

void setup() {
  size(900, 700);
  smooth();
  circles = new ArrayList<CircleParticle>();
  background(15);

  // Gentle color palette
  palette = new color[3];
  palette[0] = color(60, 120, 200);   // blue
  palette[1] = color(240, 180, 80);   // warm yellow
  palette[2] = color(200, 100, 150);  // pink

  // Start with very few circles
  for (int i = 0; i < 3; i++) {
    circles.add(new CircleParticle(
      new PVector(random(width), random(height)),
      random(80, 160)
    ));
  }
}

void draw() {
  // Background fade for trailing effect
  noStroke();
  fill(15, 15, 15, 18);
  rect(0, 0, width, height);

  // Update journey progress (oscillates between 0 and 1)
  journeyProgress += journeySpeed;
  if (journeyProgress > 1 || journeyProgress < 0) {
    journeySpeed *= -1;
  }

  // Map journeyProgress to intensity (smooth rise and fall)
  float intensity = map(journeyProgress, 0, 1, 0.05, 0.4); // keep max moderate

  // Spawn new circles gradually as intensity rises
  float spawnChance = map(intensity, 0, 1, 0.002, 0.05);
  if (random(1) < spawnChance && circles.size() < maxCircles) {
    circles.add(new CircleParticle(
      new PVector(random(width), random(height)),
      random(60, 160)
    ));
  }

  // Update and display circles
  for (int i = circles.size() - 1; i >= 0; i--) {
    CircleParticle c = circles.get(i);
    c.update(intensity);
    c.display(intensity);
    if (c.isDead()) {
      circles.remove(i);
    }
  }
}

// -------- CircleParticle Class --------
class CircleParticle {
  PVector pos;
  PVector startPos;
  float r;
  float startR;
  float age;
  float lifeSpan;
  float noiseSeed;
  color baseColor;
  float angle;
  float spiralSpeed;
  float cycleTime;

  CircleParticle(PVector p, float rad) {
    pos = p.copy();
    startPos = p.copy();
    r = rad;
    startR = rad;
    age = 0;
    lifeSpan = random(1200, 3000);
    noiseSeed = random(300);
    baseColor = palette[(int) random(palette.length)];
    angle = random(TWO_PI);
    spiralSpeed = random(0.01, 0.03);
    cycleTime = random(TWO_PI);
  }

  void update(float intensity) {
    age += 1.0 / lifeSpan;

    // Spiral movement
    float spiralRadius = map(sin(age * TWO_PI + cycleTime), -1, 1, 0, r * 2.5 * intensity);
    angle += spiralSpeed * intensity;

    pos.x = startPos.x + cos(angle) * spiralRadius;
    pos.y = startPos.y + sin(angle) * spiralRadius;

    // Radius breathing (smooth expansion/contraction)
    r = startR + startR * 0.5 * sin(age * TWO_PI + cycleTime) * intensity;
  }

  void display(float intensity) {
    float alpha = map(1.0 - age, 0, 1, 15, 150) * intensity;

    // Main circle outline
    noFill();
    stroke(red(baseColor), green(baseColor), blue(baseColor), alpha);
    strokeWeight(max(2, r * 0.05));
    ellipse(pos.x, pos.y, r * 2, r * 2);

    // Calm subtle fill when intensity is low
    if (intensity < 0.25) {
      noStroke();
      fill(red(baseColor), green(baseColor), blue(baseColor), alpha * 0.08);
      ellipse(pos.x, pos.y, r * 1.2, r * 1.2);
    }

    // Random mini circles for gentle bursts during high intensity
    if (intensity > 0.3 && random(1) < 0.003) {
      float miniR = r * random(0.4, 0.7);
      PVector miniPos = new PVector(
        pos.x + random(-r, r),
        pos.y + random(-r, r)
      );
      circles.add(new CircleParticle(miniPos, miniR));
    }
  }

  boolean isDead() {
    return age >= 1.0;
  }
} 
