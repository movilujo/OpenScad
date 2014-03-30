//-- function Original from Obijuan Library vector.scad
//-- Calculate the module of a vector
function mod(v) = (sqrt(v[0]*v[0]+v[1]*v[1]+v[2]*v[2]));

//------------------------------------------------------------------
//-- Modified module from the original vectorz of Obijuan Library vector.scad
//-- Draw a vector poiting to the z axis
//-- This is an auxiliary module for implementing the vector module
//--
//-- Parameters:
//--  l: total vector length (line + arrow)
//--  r: radio cylinder
//------------------------------------------------------------------
module ramaz(l=10, r=2)
{
  //-- vector body length (not including the arrow)
  lb = l;

  //-- The vector is locatead at 0,0,0
  translate([0,0,lb/2])
    cylinder(r=r, r2= r-0.4, h=lb, center=true, $fn=50);
}

//---------------------------------------------------------------
//-- function Original from Obijuan Library vector.scad
//
//-- ORIENTATE OPERATOR
//-- Orientate the child to the direction given by the vector
//-- The z axis of the child is rotate so that it points in the
//-- direction given by v
//-- 
//-- Parameters:
//--   v : Orientation vector
//--  roll: Angle to rotate the child around the v axis
//---------------------------------------------------------------
module orientate(v=[1,1,1],roll=0)
{
  //-- Get the vector coordinales and rotating angle
  x=v[0]; y=v[1]; z=v[2];
  phi_z1 = roll;
  
  //-- Perform the needed calculations
  phi_x = atan2(y,z);  //-- for case 1 (x=0)
  phi_y2 = atan2(x,z); //-- For case 2 (y=0)
  phi_z3 = atan2(y,x); //-- For case 3 (z=0)

  //-- General case
  l=sqrt(x*x+y*y);
  phi_y4 = atan2(l,z);
  phi_z4 = atan2(y,x);

  //-- Orientate the Child acording to region where 
  //-- the orientation vector is located

  //-- Case 1:  The vector is on the plane x=0
  if (x==0) { 
     //echo("Case 1");      //-- For debugging 
     
     rotate([-phi_x,0,0])
       rotate([0,0,phi_z1])
         children(0);
  }

  //-- Case 2: Plane y=0
  else if (y==0) {
    //echo("Case 2");      //-- Debugging

    rotate([0,phi_y2,0])
       rotate([0,0,phi_z1])
         children(0);
  }
  //-- Case 3: Plane z=0
  else if (z==0) {
    //echo("Case 3");      //-- Debugging

    rotate([0,0,phi_z3])
    rotate([0,90,0])
       rotate([0,0,phi_z1])
         children(0);
  }
  //-- General case
  else {
    //echo("General case ");    //-- Debugging
    //echo("Phi_z4: ", phi_z4);
    //echo("Phi_y4: ",phi_y4);

    rotate([0,0,phi_z4])
      rotate([0,phi_y4,0])
        rotate([0,0,phi_z1])
          children(0);
  }
}

//---------------------------------------------------------------------------
//-- Module modify from the original vector of Obijuan Library vector.scad
//--
//-- Draw a vector 
//--
//-- There are two modes of drawing the vector
//-- * Mode 1: Given by a cartesian point(x,y,z). A vector from the origin
//--           to the end (x,y,z) is drawn. The l parameter (length) must 
//--           be 0  (l=0)
//-- * Mode 2: Give by direction and length
//--           A vector of length l pointing to the direction given by
//--           v is drawn
//---------------------------------------------------------------------------
//-- Parameters:
//--  v: Vector cartesian coordinates
//--  l: total vector length (line + arrow)
//--  r: radio rama
//---------------------------------------------------------------------------
module rama(v,l=0, r)
{
  //-- Get the vector length from the coordinates
  mod = mod(v);

  //-- Draw the vector. The vector length is given either
  //--- by the mod variable (when l=0) or by l (when l!=0)
  if (l==0)
    orientate(v) ramaz(l=mod, r = r);
  else
    orientate(v) ramaz(l=l, r = r);
}

//---------------------------------------------------------------------------
//-- Modulo recursivo.
//-- construye la parte izquierda del arbol
//---------------------------------------------------------------------------

module arbol ( n, v, l, r, anx, any) {
  vi = v;
  ln = l * fr;
  rn = r * fr;
  angX = (anx + calpha) % 65;
  angY = (any + calpha) % 230;

  vn = [ln * cos(angX), ln*sin(angY), ln * sin(angX)];
  vn0 = [-vn[0], -vn[1], vn[2]];
  if (n == 1) {
     translate(vi){
      color("Green"){
        rama(vn, 0, rn);
        rama(vn0, 0, rn);
      }
    }
  }
  else {
     translate(vi){
     color("BurlyWood")
      rama(vn, 0, rn);
     arbol(n-1, vn, ln, rn, angX, angY);
     color("BurlyWood")
      rama(vn0, 0, rn);
     arbol(n-1, vn0, ln, rn, angX, angY);
     }
  } 
}

//---------------------------------------------------------------------------
//-- Modulo recursivo.
//-- construye la parte derecha del arbol
//---------------------------------------------------------------------------
module arbolD ( n, v, l, r, anx, any) {
  vi = v;
  ln = l * fr;
  rn = r * fr;
  angX = (anx + calpha) % 65;
  angY = (any + calpha) % 230;

  vn = [ln * cos(angX), ln*sin(angY), ln * sin(angX)];
  vn0 = [vn[0], -vn[1], vn[2]];
  if (n == 1) {
     translate(vi){
      color("Green"){
        rama(vn, 0, rn);
        rama(vn0, 0, rn);
      }
    }
  }
  else {
     translate(vi){
   color("BurlyWood")
     rama(vn, 0, rn);
      arbol(n-1, vn, ln, rn, angX, angY);
   color("BurlyWood")
     rama(vn0, 0, rn);
      arbol(n-1, vn0, ln, rn, angX, angY);
     }
  } 
}

//------- Ejemplo ---------//
//--- Parametros ----------//
calpha = 42.5; //Angulo base para la separación de las ramas
l = 30;         //longitud inicial
r = 3;          //radio inicial (grosor de la rama)
v = [0,0,l];    //vector inicial (tronco)
fr = 0.75;      //factor de reducción de cada pasada
AlphaY = 87.5;  //angulos usados para el ramaje
AlphaX = 0;
n = 6;          //número de pasadas
mcolor = "BurlyWood";


//dibujamos el tronco
color(mcolor)
   rama(v, 0, r);

//-- y las dos primeras ramas, llamando al ramaje de cada
//-- lado.

lx = l * fr;
rx = r * fr;
vx = [lx * cos(calpha), 0, lx * sin(calpha)];
vxI = [-vx[0], vx[1], vx[2]];
translate(v){
  color(mcolor)
   rama(vx, 0, rx);
  arbolD (n, vx, lx, rx, AlphaX, AlphaY);
  color(mcolor)
    rama(vxI, 0, rx);
  arbol (n, vxI, lx, rx, AlphaX, AlphaY);
} 
