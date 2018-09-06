///This edit contains a fully functional motion project against a triangle.
///The vertex list contains all the points of the triangle and uses them to
///calculate trajectory after contact
//variables for object
float xpos, ypos, g, v1_y, v1_x, angle, radius, ground;
{
  g = 0.098;
  angle = 0;
  radius = 0;
  ground = 300.;
}
int numBalls = 12;
float spring = 0.05;
float friction = -0.9;
float[] vertex = new float [8];
{
  vertex [0] = 0.; //0-5 are the triangle's veretexes
  vertex [1] = ground;
  vertex [2] = 0.;
  vertex [3] = 220.;
  vertex [4] = 50.;
  vertex [5] = ground;
  vertex [6] = 500.;
  vertex [7] = 230.;
}
float triangleSlope = (vertex[3]-vertex[5])/(vertex[2] - vertex[4]);
Ball[] balls = new Ball[numBalls];
void setup()
{
  background(255,200,200);
  size(700,400);
  frameRate(60);
  stroke(0,0,0);
  xpos = 100;
  for (int i = 0; i < numBalls; i++) 
  {
    balls[i] = new Ball(random(width), random(0,100), random(30, 50), i, balls);
  }
 noStroke();
 fill(255, 204);
}
void draw()
{
  background(255,200,200);
  fill(255,0,0);
  rect(-10, ground, width + 10, 100);
  triangle(vertex[0],vertex[1],vertex[2],vertex[3],vertex[4],vertex[5]);
  arc(500, 230, 160, 120, 0, PI, OPEN);
  for (Ball ball : balls) 
  {
    ball.collide();
    ball.move();
    ball.display();
  }
}
class Ball 
{
  float xpos, ypos;
  float diameter;
  float v1_x = 0;
  float v1_y = 0;
  int id;
  Ball[] others;
  Ball(float xposin, float yposin, float din, int idin, Ball[] oin) 
  {
    xpos = xposin;
    ypos = yposin;
    diameter = din;
    id = idin;
    others = oin;
  }

 void collide() 
  {
    for (int i = id + 1; i < numBalls; i++) 
    {
      float dx = others[i].xpos - xpos;
      float dy = others[i].ypos - ypos;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others[i].diameter/2 + diameter/2;
      if (distance < minDist) 
      {
        float angle = atan2(dy, dx);
        float targetX = xpos + cos(angle) * minDist;
        float targetY = ypos + sin(angle) * minDist;
        float ax = (targetX - others[i].xpos) * spring;
        float ay = (targetY - others[i].ypos) * spring;
        v1_x -= ax;
        v1_y -= ay;
        others[i].v1_x += ax;
        others[i].v1_y += ay;
      }
    }
  }

 void move() 
 {
  v1_y += g;
  xpos += v1_x;
  ypos += v1_y;
  if (xpos + diameter/2 > width) 
  {
    xpos = width - diameter/2;
    v1_x *= friction;
  }
  else if (xpos - diameter/2 < 0) 
  {
    xpos = diameter/2;
    v1_x *= friction;
  }
  if (ypos + diameter/2 > ground) 
  {
    ypos = 300 - diameter/2;
    v1_y *= friction;
  }
  else if (ypos - diameter/2 < 0) 
  {
    ypos = diameter/2;
    v1_y *= friction;
  }
  if (keyPressed)
  { //allows for movement throgh WASD
    if (key == 'd' || key == 'D')
    {
      v1_x = 2;
    }
    if (key == 'a' || key == 'A')
    {
      v1_x = -2;
    }
    if ((key == 'w' || key == 'W') && ypos >= 300 - diameter/2)
    {//checks to see if ball is on floor
    ypos += 0;
    v1_y = 10;
    }
  } 
  else 
  {
  }
  fill(0,0,255);
  ellipse (xpos, ypos, 20, 20);
  if(ypos < ground)
  {
    v1_y = v1_y + g;
  }
  if(ypos >= ground)
  {
    v1_y = -abs(v1_y * 0.70); //acts as friction for floor
  }
  if(ypos >= ground && v1_y > -0.1 && v1_y < 0.1)
  {//sets y velocity to 0 when within a certain limit
    v1_y = 0;
  }
  if(v1_y == 0)
  {//only when ball has no downward velocity does the x velocity slow down
    v1_x = v1_x * 0.90;
  }
  if(xpos <= 0 || xpos >= width)
  {//allows for ball to bounce off walls
    v1_x = (-v1_x * 0.90);
  }
  for (int t = 0; t < 50; t += 1)
  {
    if (ypos >= triangleSlope * t + vertex[3] && xpos <= t )
    {//triangles properties
      radius = sqrt(pow(v1_x, 2) + pow(v1_y, 2)) * 0.90;
      angle = atan(triangleSlope);
      v1_x = sin(angle) * radius;
      v1_y = -cos(angle) * radius;
    }
  }
}

void display() 
{
  ellipse(xpos, ypos, diameter, diameter);
  }
}
void keyPressed()
{
  if(key == CODED)
  {
    if(keyCode == UP)
    {
      print("Y velocity: ", v1_y, "Angle: ", angle, "Radius: ", radius, "Slope: ", triangleSlope, " ");
      ground--;
    }
    else if(keyCode == DOWN)
    {
      ground++;
    }
  }
}