import processing.sound.*;
SoundFile sound;
SoundFile ronco;

void settings()
{
   System.setProperty("jogl.disable.openglcore", "false");
   size(800, 600, P3D);
}

void setup(){
  noStroke();
  sound = new SoundFile(this, "./salamisound-8882847-door-squeak-and-creak-door.wav");
  ronco = new SoundFile(this, "./ronco_efeito_sonoro.wav");
}

float olhoYDir=55, olhoYEsq=40, pupilaYEsq=25, pupilaYDir=35, sobrancelhaYEsq=295, sobrancelhaYDir=295, time = 0.0;
float trianguloY1 = 190, trianguloY2 = 230, lixoY = 20, lixoX = 40, sobeLixo=305, sobeTri=260, descePedal=0;
boolean piscaEsq = false, piscaDir = false, dormir = false, tampaAberta=false;
int posTamp = 0, frame = 0;
int tempoPressionado = 0;

void draw(){
  background(200);
  noStroke();
  
  if(mousePressed)
    camera(mouseX, mouseY, (height/2) / tan(PI/6), width/2,height/2, 0, 0, 1, 0);
    
  if((keyPressed == true)){
    dormir = false; //Deixa de dormir
    frame = 0; //Reinicia frame
    piscaEsq = false; //Deixa de piscar
    piscaDir = false; //Deixa de piscar
  }
  if(frame > 60) frame=0; //Reinicia frame
 
  lights();
  ambientLight(102, 102, 102);
  directionalLight(51, 102, 126, 1, 1, 0); 
   
  //Chão 
  pushMatrix();
  fill(0, 50, 0);
  translate(400, 400, 0);
  box(400, 10, 400);
  
  /*___________________________LIXEIRA___________________________*/
  fill(80);
  translate(0, -75, 100);
  box(90, 120, 10);
  translate(45,0, -45);
  box(10, 120, 100);
  translate(-90, 0, 0);
  box(10, 120, 100);
  translate(45, 0, -45);
  box(90, 120, 10);
  //Fundo
  translate(0, 55, 45);
  box(100, 10, 100);
  //Tampa
  fill(70);
  /*___________________________________________________________*/
  
  /*___________________________TAMPA___________________________*/
  if((keyPressed == true) && (key == 'P') || (keyPressed == true) && (key == 'p')){
    tempoPressionado++;
    abreTampa();
    descePedal();
  }else{
    tempoPressionado = 0;
    fechaTampa();
    sobePedal();
  }
  /*___________________________________________________________*/

  //Pé da lixeira
  translate(0, 10, 40);
  fill(0);
  box(70, 10, 20);
  popMatrix();
  
  /*___________________________OLHOS___________________________*/
  if((keyPressed == true) && (key == '4')) piscaEsq = true;
  if((keyPressed == true) && (key == '6')) piscaDir = true;
  if((keyPressed == true) && (key == 'f') || (keyPressed == true) && (key == 'F')) dormir = true; //Dorme
  
  if(!ronco.isPlaying() && dormir) ronco.play();
  else if(!dormir) ronco.pause();
  
  if(piscaEsq && frame < 31 || dormir)
  {
      fechaOlhoEsquerdo();
  }
  else if(!piscaEsq || frame > 30 && frame < 61)
  {
      abreOlhoEsquerdo();
  }
  
  if(piscaDir && frame < 31 || dormir)
  {
      fechaOlhoDireito();
  }
  else if(!piscaDir || frame > 30 && frame < 61)
  {
      abreOlhoDireito();
  }
  /*___________________________________________________________*/
  
  /*___________________________BOCA___________________________*/
  pushMatrix();
  //Desenha Boca
  translate(100, -60, 110.1);
  if(!dormir && tempoPressionado <= 3 * frameRate){
    //Boca aberta
    fill(color(0, 180)); //Preto fundo da boca
    arc(300, 385, 50, 50, 0, PI); //Boca
    translate(0, 0, 0.1);
    fill(255); //Cor dos dentes
    arc(300, 385, 40, 5, 0, PI); //Dente
    translate(0, 0, 0.1);
    fill(255,0,0); //Cor da lingua
    arc(300, 407, 21, 6, 0, PI); //Lingua
  }
  else if (tempoPressionado <= 3 * frameRate){
    //Boca fechada
    fill(color(0, 200));
    ellipse(290, 400, 15, 15);
  }
  popMatrix();
  /*___________________________________________________________*/
  
  /*___________________________RODA___________________________*/
  pushMatrix();
  translate(350, 380, 30);
  rotateY(PI/2);
  drawWheel(5,20, 30);
  popMatrix();
  
  // Desenha a roda direita
  pushMatrix();
  translate(450, 380, 30);
  rotateY(PI/2);
  drawWheel(5,20, 30);
  popMatrix();
  /*___________________________________________________________*/
  
  
  /*___________________________LIXO___________________________*/
  if((keyPressed == true) && (key == 'P') && tempoPressionado >= 3 * frameRate|| (keyPressed == true) && (key == 'p') && tempoPressionado >= 3 * frameRate){
      desenhaLixo();
  }else{
      //lixoY = lixoY > 20? lixoY-3 : 20;
      //lixoX = lixoX > 40? lixoX-5 : 150;
      sobeLixo = sobeLixo < 305? sobeLixo+3 : 305;
      sobeTri = sobeTri < 260? sobeTri+3 : 260;
  }
  /*___________________________________________________________*/
  
  if(piscaEsq || piscaDir) frame++;
}

void abreTampa(){
  if(!sound.isPlaying() && !tampaAberta) sound.play();
  
  if(time < 0.8){
      posTamp = posTamp+2;
      time = ((posTamp) * PI / 60 ) * 0.1;
      tampaAberta=true;
    }
    pushMatrix();
    translate(0,-120-time*40,-time*20);
    rotateX(time);
    
    fill(50); //Cor estrutura da tampa
    box(100, 10, 100);
    popMatrix();
}

void fechaTampa(){
  tampaAberta=false;
  if(time > 0){
      posTamp = posTamp-3;
      time = ((posTamp) * PI / 60 ) * 0.1;
 
    }
    //Tampa fechada
    pushMatrix();
    translate(0,-120-time*40,-time*20);
    rotateX(time);
    
    fill(50); //Cor estrutura da tampa
    box(100, 10, 100);
    popMatrix();
}

void desenhaLixo(){
  //lixoY = lixoY < 80? lixoY+3 : 80;
  //lixoX = lixoX < 150? lixoX+10 : 150;
  
  sobeLixo = sobeLixo > 290? sobeLixo-0.5 : 290;
  sobeTri = sobeTri > 245? sobeTri-0.5 : 245;
  
  pushMatrix();
  translate(400, sobeTri, 60);
  shape(createPyramid(20, 20));
  popMatrix();
  
  pushMatrix();
  translate(400, sobeLixo, 60);
  fill(0);
  sphere(45);
  popMatrix();
  
  //Boca triste
  pushMatrix();
  translate(100, -60, 110.1);
  stroke(0);
  noFill();
  strokeWeight(5);
  arc(300, 400, 30, 20, PI, PI*2);
  popMatrix();
  
  // Desenhe a lágrima
  pushMatrix();
  translate(100, -35, 111);
  noStroke();
  fill(255);
  ellipse(275 ,340, 15,15); 
  ellipse(280 ,330, 5,5); 
  ellipse(325 ,340, 15,15);
  ellipse(320 ,330, 5,5); 
  popMatrix();
  pushMatrix();
  translate(115, -35, 111);
  fill(0, 0, 255); // Cor azul
  triangle(250, 335, 244, 345, 256, 345);
  ellipse(250 ,350, 15,15);
  popMatrix();
  pushMatrix();
  translate(85, -35, 111);
  triangle(350, 335, 344, 345, 356, 345);
  ellipse(350 ,350, 15,15);
  popMatrix();
}

void abreOlhoEsquerdo(){
  pushMatrix();
  olhoYEsq = olhoYEsq < 40? olhoYEsq+3 : 40;
  pupilaYEsq = pupilaYEsq < 25? pupilaYEsq+3 : 25;
  translate(110, -35, 110);
  fill(255); //Branco do olho
  ellipse(270, 330, 35, olhoYEsq); //Olho esquerdo
  translate(0, 0, 0.1);
  fill(0); //Preto da pupila
  ellipse(270, 330, 20, pupilaYEsq); //Pupila esquerdo
  popMatrix();
}

void fechaOlhoEsquerdo(){
  pushMatrix();
  translate(110, -35, 110);
  olhoYEsq = olhoYEsq > 8? olhoYEsq-3 : 8; //Pisca o olho esquerdo
  if(olhoYEsq <= pupilaYEsq) pupilaYEsq = pupilaYEsq >= 10? pupilaYEsq-3 : 10; //Pisca pupila esquerda
  if(olhoYEsq < 9)fill(0); //Cor do olho totalmente fechado
  else fill(255); //Branco do olho
  ellipse(270, 330, 35, olhoYEsq); //Olho esquerdo
  translate(0, 0, 0.1);
  fill(0); //Preto da pupila
  ellipse(270, 330, 20, pupilaYEsq); //Pupila esquerdo
  popMatrix();
}

void abreOlhoDireito(){
  pushMatrix();
  olhoYDir = olhoYDir < 40? olhoYDir+3 : 40;
  pupilaYDir = pupilaYDir < 25? pupilaYDir+3 : 25;
  translate(150, -35, 110);
  fill(255); //Branco do olho
  ellipse(270, 330, 35, olhoYDir); //Olho esquerdo
  translate(0, 0, 0.1);
  fill(0); //Preto da pupila
  ellipse(270, 330, 20, pupilaYDir); //Pupila esquerdo
  popMatrix();
}

void fechaOlhoDireito(){
  pushMatrix();
  translate(90, -35, 110);
  olhoYDir = olhoYDir > 8? olhoYDir-3 : 8;
  if(olhoYDir <= pupilaYDir) pupilaYDir = pupilaYDir >= 10? pupilaYDir-3 : 10;
  if(olhoYDir < 9) fill(0); //Cor do olho totalmente fechado
  else fill(255); //Branco do olho
  ellipse(330, 330, 40, olhoYDir); //Olho direito
  translate(0, 0, 0.1);
  fill(0); //Preto da pupila
  ellipse(330, 330, 25, pupilaYDir); //Pupila direita
  popMatrix();
}

void sobePedal(){
  descePedal = descePedal > 0? descePedal-0.3 : 0;
 pushMatrix();
 fill(70);
 translate(0, descePedal, 60);
 box(30, 10, 15);
 popMatrix();
}

void descePedal(){
 descePedal = descePedal < 5? descePedal+0.3 : 5;
 pushMatrix();
 fill(70);
 translate(0, descePedal, 60);
 box(30, 10, 15);
 popMatrix();
}

void drawWheel(float radius, float thickness, int numSpokes) {
  float angleStep = 360.0 / numSpokes;  // Ângulo entre os raios da roda
  float outerRadius = radius + thickness / 2;  // Raio externo da roda
  
  // Desenha os raios da roda
  for (int i = 0; i < numSpokes; i++) {
    float x1 = radius * cos(radians(i * angleStep));
    float y1 = radius * sin(radians(i * angleStep));
    float x2 = outerRadius * cos(radians(i * angleStep));
    float y2 = outerRadius * sin(radians(i * angleStep));
    
    fill(0); // Define a cor de preenchimento como preto
    beginShape();
    vertex(x1, y1, -thickness / 2);
    vertex(x2, y2, -thickness / 2);
    vertex(x2, y2, thickness / 2);
    vertex(x1, y1, thickness / 2);
    endShape(CLOSE);
  }
  
  // Desenha o círculo externo da roda
  fill(0); // Define a cor de preenchimento como preto
  beginShape(TRIANGLE_STRIP);
  
  for (int i = 0; i <= numSpokes; i++) {
    float x = outerRadius * cos(radians(i * angleStep));
    float y = outerRadius * sin(radians(i * angleStep));
    
    vertex(x, y, thickness / 2);
    vertex(x, y, -thickness / 2);
  }
  endShape(CLOSE);
  
  // Desenha o círculo interno da roda
  fill(0); // Define a cor de preenchimento como branco
  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i <= numSpokes; i++) {
    float x = radius * cos(radians(i * angleStep));
    float y = radius * sin(radians(i * angleStep));
    
    vertex(x, y, thickness / 2);
    vertex(x, y, -thickness / 2);
  }
  endShape(CLOSE);

}

PShape createPyramid(float baseSize, float height) {
  PShape pyramid = createShape();

  pyramid.beginShape(TRIANGLES);
  pyramid.fill(28,28,28); // Cor vermelha

  float halfBase = baseSize / 2;
  // Base da pirâmide
  pyramid.vertex(-halfBase, -halfBase, halfBase);
  pyramid.vertex(halfBase, -halfBase, halfBase);
  pyramid.vertex(0, -halfBase, -halfBase);

  pyramid.vertex(-halfBase, -halfBase, halfBase);
  pyramid.vertex(0, -halfBase, -halfBase);
  pyramid.vertex(halfBase, -halfBase, halfBase);

  // Faces laterais
  pyramid.vertex(-halfBase, -halfBase, halfBase);
  pyramid.vertex(0, -halfBase, -halfBase);
  pyramid.vertex(0, halfBase, 0);

  pyramid.vertex(halfBase, -halfBase, halfBase);
  pyramid.vertex(0, -halfBase, -halfBase);
  pyramid.vertex(0, halfBase, 0);

  pyramid.vertex(halfBase, -halfBase, halfBase);
  pyramid.vertex(-halfBase, -halfBase, halfBase);
  pyramid.vertex(0, halfBase, 0);

  pyramid.vertex(-halfBase, -halfBase, halfBase);
  pyramid.vertex(halfBase, -halfBase, halfBase);
  pyramid.vertex(0, halfBase, 0);

  pyramid.endShape();

  return pyramid;
}
