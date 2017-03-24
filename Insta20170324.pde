import de.voidplus.leapmotion.*;

ArrayList<Particle> particles;
LeapMotion leap;

void setup()
{
  size(800, 800, P3D);
  frameRate(30);
  hint(DISABLE_DEPTH_TEST);
  colorMode(HSB);
  blendMode(ADD);
  
  particles = new ArrayList<Particle>();
  for(int i = 0; i < 256; i++)
  {
    particles.add(new Particle(random(-250, 250), random(-250, 250), random(-250, 250)));
  }
  
  leap = new LeapMotion(this);
}

void draw()
{
  background(0);
  translate(width / 2, height / 2, 0);
    
  ArrayList<PVector> targets = new ArrayList<PVector>();
  for(Hand hand : leap.getHands())
  {
    PVector index = hand.getIndexFinger().getPosition().copy();
    index.sub(width / 2, height / 2, 0);
    pushMatrix();
    translate(index.x, index.y, index.z);
    fill(0, 255, 255);
    box(5);
    popMatrix();
    
    PVector thumb = hand.getThumb().getPosition().copy();
    thumb.sub(width / 2, height / 2, 0);
    pushMatrix();
    translate(thumb.x, thumb.y, thumb.z);
    fill(0, 255, 255);
    box(5);
    popMatrix();
    
    if(PVector.dist(index, thumb) < 50)
    {
      index.mult(1);
      thumb.mult(1);
      targets.add(index);
      targets.add(thumb);
    }
  }
  
  for(Particle particle : particles)
  {
    particle.flok(particles);
    for(PVector target : targets)
    {
      particle.applyForce(particle.seek(target));
    }
    particle.update();
    particle.borders();
    particle.display();
  }

  /*
  println(frameCount);
  saveFrame("screen-#####.png");
  if(frameCount > 900)
  {
     exit();
  }
  */
}