
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
