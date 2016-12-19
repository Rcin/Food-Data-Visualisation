/*
 * KEYS
 * s                   : save png
 * p                   : save pdf
 */

import processing.pdf.*;

boolean savePDF = false;

Meal[] all_meals;  // Array of Meals
int meals_count;  // Total Meals Number
int meals_index;

boolean meal_w;
boolean meal_b;
boolean meal_r;
boolean meal_m;
boolean meal_v;
boolean meal_f;
color c1, c2, c3;
color cb, cr, cm, cv, cf;

void setup() {
  loadData();
  smooth();
  size(600, 600, P2D);
  pixelDensity(2);
  cb = color(100, 139, 229); //color for bread
  cr = color(187, 229, 228); //color for rice
  cm = color(141, 110, 200); //color for meat
  cv = color(98, 178, 197); //color for vegetables
  cf = color(202, 130, 172); //color for fruits
}

void draw() {
  //save it to PDF
  if (savePDF) {
    beginRecord(PDF, "meals_######.pdf");
  }
  background(40);
  for (int i = 0; i<5; i++) {
    for (int j = 0; j<3; j++) {
      meals_index = i*3 +j;
      //assign the colors
      if (all_meals[meals_index].b == true && all_meals[meals_index].r == true && all_meals[meals_index].m == true) {
        c1 = cr;
        c2 = cb;
        c3 = cm;
      } else if (all_meals[meals_index].b == true && all_meals[meals_index].r == false && all_meals[meals_index].m == false && all_meals[meals_index].v == false) {
        c1 = cb;
        c2 = cb;
        c3 = 0;
      } else if (all_meals[meals_index].r == true && all_meals[meals_index].m == true && all_meals[meals_index].v == true) {
        c1 = cr;
        c2 = cv;
        c3 = cm;
      } else if (all_meals[meals_index].r == true && all_meals[meals_index].m == false && all_meals[meals_index].v == false) {
        c1 = cr;
        c2 = cr;
        c3 = 0;
      } else if (all_meals[meals_index].f == true) {
        c1 = cf;
        c2 = cf;
        c3 = 0;
      } else if (all_meals[meals_index].v == true && all_meals[meals_index].b == false && all_meals[meals_index].m == false && all_meals[meals_index].r == false) {
        c1 = cv;
        c2 = cv;
        c3 = 0;
      } else if (all_meals[meals_index].v == true && all_meals[meals_index].b == true && all_meals[meals_index].m == true) {
        c1 = cv;
        c2 = cb;
        c3 = cm;
      } else if (all_meals[meals_index].v == true && all_meals[meals_index].m == true) {
        c1 = cv;
        c2 = cm;
        c3 = 0;
      }
      //debug
      println("c1", red(c1), green(c1), blue(c1));
      println("c2", red(c2), green(c2), blue(c2));
      println("c3", red(c3), green(c3), blue(c3));
      drawArc(width/2, height/2, 10 + 40*(i+1), c1, c2, c3, 5, 0.67*PI*j+0.16*PI*i, 0.33*PI+0.67*PI*j+0.16*PI*i);
      if (all_meals[meals_index].w == true) {
        //drawArc(width/2, height/2, 30+42*(i+1), c1, c2, c3, 3, 0, 2*PI);
      }
    }
  }
  if (savePDF) {
    savePDF = false;
    endRecord();
  }
}

void keyPressed() {
  if (key=='s' || key=='S') saveFrame("meals_######.png");
  if (key=='p' || key=='P') {
    savePDF = true;
    println("Save PDF");
  }
}

/*
  cx: centerX
 cy: centerY
 r: radius
 c1: gradientStart
 c2: gradientEnd
 l: arcThickness
 sa: startAngle
 ea: endAngle
 */
void drawArc(float cx, float cy, float r, color c1, color c2, color c3, float l, float sa, float ea) {
  int lineSegments = 1800; //density
  noFill();
  float sd = degrees(sa);
  float ed = degrees(ea);
  float angleDiff = ed - sd;
  float lineCount = angleDiff / 360 * lineSegments;
  beginShape(LINES);
  for ( int i=0; i<lineCount; i++ ) {
    if (c3 == 0) {
      color c = lerpColor(c1, c2, (float)i/lineCount);
      stroke(c);
    } else {
      if (i <= lineCount/2) {
        color c = lerpColor(c1, c2, (float)2*i/lineCount);
        stroke(c);
      } else if (i > lineCount/2) {
        color c = lerpColor(c2, c3, (float)2*i/lineCount-1);
        stroke(c);
      }
    }
    //stroke(c);
    float radiant = sa + (ea - sa)/lineCount * i;
    float lineStartX = cx + r * cos(radiant);
    float lineStartY = cy + r * sin(radiant);
    float lineEndX = cx + (r + l) * cos(radiant);
    float lineEndY = cy + (r + l) * sin(radiant);
    vertex(lineStartX, lineStartY);
    vertex(lineEndX, lineEndY);
  }
  endShape();
}

void loadData() {
  //load data
  Table meals_table = loadTable("fooddata.csv", "header");
  meals_count = meals_table.getRowCount();
  all_meals = new Meal[meals_count];
  //loop through all meals
  int row_index = 0;
  for (TableRow row : meals_table.rows()) {
    //int yummy = row.getInt("yummy");
    //int healthy = row.getInt("healthy");
    boolean w = boolean(row.getString("workout"));
    boolean b = boolean(row.getString("bread"));
    boolean r = boolean(row.getString("rice"));
    boolean m = boolean(row.getString("meat"));
    boolean v = boolean(row.getString("vegetables"));
    boolean f = boolean(row.getString("fruits"));
    //create new meal object and save into meals array
    Meal new_meal = new Meal(w, b, r, m, v, f);
    all_meals[row_index] = new_meal;
    row_index ++;
    //debug
    println(new_meal.w, new_meal.b, new_meal.r, new_meal.m, new_meal.v, new_meal.f);
  }
}