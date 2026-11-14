#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
uniform vec2 uRes;
uniform float uPass,uSeed,uTrail,uN;
uniform vec4 uS[6];
uniform vec4 uRing;
uniform vec4 uView;
uniform vec2 uOff;
float ssm(float a,float b,float x){float t=clamp((x-a)/(b-a),0.,1.);return t*t*(3.-2.*t);}
#define smoothstep ssm

vec3 rotX(vec3 v,float a){float c=cos(a),s=sin(a);return vec3(v.x,c*v.y-s*v.z,s*v.y+c*v.z);}
vec3 rotY(vec3 v,float a){float c=cos(a),s=sin(a);return vec3(c*v.x+s*v.z,v.y,-s*v.x+c*v.z);}
vec3 rotZ(vec3 v,float a){float c=cos(a),s=sin(a);return vec3(c*v.x-s*v.y,s*v.x+c*v.y,v.z);}

float hash13(vec3 p3){p3=fract(p3*.1031);p3+=dot(p3,p3.zyx+31.32);return fract((p3.x+p3.y)*p3.z);}
float vnoise(vec3 p){
 vec3 i=floor(p),f=fract(p);f=f*f*f*(f*(f*6.-15.)+10.);
 float a=hash13(i),b=hash13(i+vec3(1.,0.,0.)),c=hash13(i+vec3(0.,1.,0.)),d=hash13(i+vec3(1.,1.,0.));
 float e=hash13(i+vec3(0.,0.,1.)),g=hash13(i+vec3(1.,0.,1.)),h=hash13(i+vec3(0.,1.,1.)),k=hash13(i+vec3(1.,1.,1.));
 return mix(mix(mix(a,b,f.x),mix(c,d,f.x),f.y),mix(mix(e,g,f.x),mix(h,k,f.x),f.y),f.z);}
float fbm(vec3 p){float a=.5,s=0.;for(int i=0;i<7;i++){s+=a*vnoise(p);p=p*2.03+vec3(1.7,9.2,3.1);a*=.5;}return s;}
float fbm5(vec3 p){float a=.5,s=0.;for(int i=0;i<5;i++){s+=a*vnoise(p);p=p*2.03+vec3(1.7,9.2,3.1);a*=.5;}return s;}
float ridged(vec3 p){float a=.5,s=0.;for(int i=0;i<5;i++){float n=1.-abs(vnoise(p)*2.-1.);s+=a*n*n;p=p*2.1+vec3(5.2,1.3,8.7);a*=.5;}return s;}
float worley(vec3 p){
 vec3 i=floor(p),f=fract(p);float m=8.;
 for(int z=-1;z<=1;z++)for(int y=-1;y<=1;y++)for(int x=-1;x<=1;x++){
  vec3 g=vec3(float(x),float(y),float(z));vec3 o=vec3(hash13(i+g),hash13(i+g+17.1),hash13(i+g+41.7));
  vec3 d=g+o-f;m=min(m,dot(d,d));}
 return sqrt(m);}

float starLayer(vec2 px,float cell,float seed,float dens,out vec3 tint){
 vec2 g=px/cell,i=floor(g),f=fract(g);
 float h=hash13(vec3(i,seed));
 tint=vec3(1.);
 if(h>dens) return 0.;
 vec2 o=vec2(hash13(vec3(i,seed+1.3)),hash13(vec3(i,seed+2.7)))*.7+.15;
 float d=length((f-o)*cell);
 float m=hash13(vec3(i,seed+5.1));
 float b=.25+.75*m*m;
 float s=mix(.7,1.4,m);
 float v=b*exp(-d*d/(2.*s*s));
 v+=step(.9,m)*b*.35*exp(-d/5.);
 float t=hash13(vec3(i,seed+9.9));
 tint=mix(mix(vec3(1.,.72,.5),vec3(.65,.78,1.),t),vec3(1.),.4);
 return v;}

vec3 nebulaCol(vec2 uv){
 vec3 sd=vec3(uSeed*1.7,uSeed*.6,uSeed*2.3);
 vec2 q=vec2(fbm(vec3(uv*.9,0.)+sd),fbm(vec3(uv*.9+4.,0.)+sd+3.));
 float n=fbm(vec3(uv*1.5+q*2.2,1.)+sd);
 float m=fbm(vec3(uv*3.2-q*1.4,2.)+sd);
 float f=fbm5(vec3(uv*7.5+q*2.5,3.)+sd);
 float bd=uv.y*.9+uv.x*.35+.15*sin(uv.x*1.3+uSeed);
 float band=exp(-bd*bd*1.4);
 vec3 pa=mix(vec3(.5),.5+.5*cos(6.2831*(uSeed*.11+vec3(.0,.33,.67))),.7);
 vec3 pb=mix(vec3(.5),.5+.5*cos(6.2831*(uSeed*.11+.5+vec3(.0,.33,.67))),.7);
 float fil=ridged(vec3(uv*2.2+q*1.8,7.)+sd);
 vec3 c=vec3(.003,.004,.01);
 c+=pa*pow(smoothstep(.38,.9,n),2.2)*.17*(.15+band);
 c+=pb*pow(smoothstep(.5,.92,m),2.6)*.14*(.12+band);
 c+=mix(pa,pb,.5)*pow(fil,3.2)*.16*(.1+band);
 c+=vec3(1.,.9,.8)*pow(f,3.)*.05*band;
 float dust=smoothstep(.5,.72,fbm5(vec3(uv*2.6+q,5.)+sd));
 c*=1.-.75*dust*band;
 return c;}

vec3 background(vec2 pxn,vec2 uv){
 vec3 c=nebulaCol(uv);vec3 t;float v;
 float bd=uv.y*.9+uv.x*.35+.15*sin(uv.x*1.3+uSeed);float band=exp(-bd*bd*1.4);
 v=starLayer(pxn+13.,9.,uSeed+11.,.5,t);c+=t*v*.22*(.35+1.3*band);
 v=starLayer(pxn,22.,uSeed,.2,t);c+=t*v*.85;
 v=starLayer(pxn+101.,47.,uSeed+3.,.3,t);c+=t*v*1.1;
 v=starLayer(pxn+57.,97.,uSeed+7.,.4,t);c+=t*v*1.6;
 return c;}

/* ====================== MODE 0: sfere (planete, luni, inele, traiectorii) ====================== */
#ifdef M0
float craters(vec3 p){float c=0.;for(int k=0;k<3;k++){float w=worley(p*(5.+7.*float(k))+float(k)*9.);c+=(-smoothstep(.28,.0,w)+.55*smoothstep(.26,.34,w)*smoothstep(.45,.34,w))/(1.+float(k));}return c;}
vec3 surfJup(vec3 p){
 float lat=p.y;vec3 q=vec3(p.x*1.3,lat*6.5,p.z*1.3);
 vec3 w=vec3(fbm5(q*1.6+vec3(3.,1.,2.)),fbm5(q*1.6+vec3(7.,5.,9.)),0.);
 float band=.5+.5*sin(lat*17.+w.x*6.+fbm5(q*.7)*3.);
 float fine=fbm(vec3(p.x*7.,lat*46.,p.z*7.)+w*3.5);
 float cells=fbm(p*vec3(15.,28.,15.)+w*2.4);
 vec3 c=mix(vec3(.94,.86,.72),vec3(.63,.39,.25),smoothstep(.25,.85,band));
 c=mix(c,vec3(.98,.95,.9),smoothstep(.55,.92,cells)*.55*(1.-band*.6));
 c=mix(c,vec3(.42,.25,.17),smoothstep(.6,.9,fbm5(vec3(p.x*3.,lat*30.,p.z*3.)+w*2.))*.45*band);
 c*=.74+.55*fine;
 vec3 g=normalize(vec3(.55,-.33,.77));vec3 d=p-g;vec3 ax=normalize(vec3(g.z,0.,-g.x));
 float dx=dot(d,ax),dy=d.y;
 float swirl=fbm5(vec3(dx*20.,dy*44.,0.)+w*4.+vec3(1.,3.,2.));
 float sp=exp(-(dx*dx/.028+dy*dy/.0075));
 c=mix(c,mix(vec3(.74,.27,.14),vec3(.92,.58,.4),swirl),sp*.9);
 c=mix(c,vec3(.97,.93,.88),exp(-(dx*dx/.05+(dy+.11)*(dy+.11)/.0007))*.35*(1.-sp));
 return c;}
vec3 surfSat(vec3 p){
 float lat=p.y;vec3 q=vec3(p.x*1.2,lat*6.,p.z*1.2);
 vec3 w=vec3(fbm5(q*1.4+2.),fbm5(q*1.4+8.),0.);
 float band=.5+.5*sin(lat*20.+w.x*3.5);
 vec3 c=mix(vec3(.93,.83,.6),vec3(.78,.64,.42),band);
 c=mix(c,vec3(.97,.9,.72),smoothstep(.5,.9,fbm5(p*vec3(9.,30.,9.)+w*2.))*.4);
 c*=.9+.25*fbm(vec3(p.x*6.,lat*50.,p.z*6.)+w*2.);
 c=mix(c,vec3(.5,.56,.64),smoothstep(.8,.97,abs(lat))*.35);
 return c;}
vec3 surfTitan(vec3 p){
 float lat=p.y;
 vec3 c=mix(vec3(.88,.58,.22),vec3(.78,.46,.15),smoothstep(-.3,.9,lat));
 c*=.92+.14*fbm5(vec3(p.x*3.,lat*8.,p.z*3.)+4.);
 c=mix(c,vec3(.33,.24,.17),smoothstep(.6,.72,lat)*smoothstep(.97,.8,lat)*.55);
 return c;}
vec3 surfUra(vec3 p){
 float lat=p.y;
 vec3 c=mix(vec3(.55,.83,.88),vec3(.7,.92,.93),smoothstep(.3,1.,abs(lat)));
 c+=.025*sin(lat*26.+fbm5(p*3.)*4.);
 c*=.97+.08*fbm5(vec3(p.x*4.,lat*20.,p.z*4.));
 return c;}
vec3 surfNep(vec3 p){
 float lat=p.y;vec3 q=vec3(p.x*1.4,lat*6.,p.z*1.4);
 vec3 w=vec3(fbm5(q*1.5+5.),fbm5(q*1.5+1.),0.);
 float band=.5+.5*sin(lat*15.+w.x*4.);
 vec3 c=mix(vec3(.14,.3,.86),vec3(.07,.16,.66),band);
 c*=.9+.25*fbm5(vec3(p.x*5.,lat*26.,p.z*5.)+w*2.);
 vec3 g=normalize(vec3(-.35,.3,.88));vec3 d=p-g;vec3 ax=normalize(vec3(g.z,0.,-g.x));
 float dx=dot(d,ax),dy=d.y;
 c=mix(c,vec3(.03,.06,.3),exp(-(dx*dx/.03+dy*dy/.012))*.85);
 float cir=ridged(vec3(p.x*3.,lat*16.,p.z*3.)+w*3.);
 float streak=smoothstep(.78,.95,cir)*(smoothstep(.0,.2,dx+.35)*exp(-dy*dy/.05)*.8+.15*band);
 return mix(c,vec3(.92,.96,1.),clamp(streak,0.,1.)*.8);}
vec3 surfIo(vec3 p){
 float a=fbm(p*3.5),b=fbm(p*9.+3.),c=ridged(p*5.+1.);
 vec3 col=mix(vec3(.95,.85,.35),vec3(.9,.55,.2),smoothstep(.4,.7,a));
 col=mix(col,vec3(.97,.97,.88),smoothstep(.55,.75,b)*.7);
 col=mix(col,vec3(.55,.45,.2),smoothstep(.62,.75,fbm5(p*14.))*.5);
 col=mix(col,vec3(.05,.04,.03),smoothstep(.72,.78,fbm5(p*6.+9.)));
 col=mix(col,vec3(.8,.2,.08),smoothstep(.8,.9,c)*.45);
 return col*(.88+.2*fbm5(p*40.));}
vec3 surfEur(vec3 p){
 float a=fbm(p*4.);vec3 col=mix(vec3(.88,.86,.8),vec3(.95,.95,.97),a);
 float l=pow(ridged(p*5.+fbm5(p*3.)*1.5),3.5);col=mix(col,vec3(.55,.33,.2),clamp(l*1.8,0.,1.)*.8);
 float l2=ridged(p*9.+4.);col=mix(col,vec3(.4,.25,.15),smoothstep(.75,.95,l2)*.5);
 return col*(.85+.3*fbm5(p*30.));}
vec3 surfIce(vec3 p){
 float a=fbm(p*3.);float cr=craters(p);
 vec3 col=mix(vec3(.62,.62,.66),vec3(.82,.82,.85),a);
 col=mix(col,vec3(.5,.45,.45),smoothstep(.5,.8,ridged(p*6.))*.4);
 return col*(.9+.35*cr)*(.9+.2*fbm5(p*28.));}
vec3 surfEarth(vec3 p){
 float c=fbm(p*3.),d=fbm(p*8.+2.);
 vec3 land=mix(vec3(.18,.32,.1),vec3(.45,.38,.22),d);
 vec3 s=mix(vec3(.03,.1,.34),land,smoothstep(.5,.54,c));
 s=mix(s,vec3(.96),smoothstep(.5,.8,fbm(p*4.+7.))*.85);
 return mix(s,vec3(.95),smoothstep(.85,.95,abs(p.y)));}
float hgt(float ty,vec3 p){
 if(ty<5.5) return fbm5(p*16.)*.6+ridged(p*9.)*.4;
 if(ty<6.5) return pow(ridged(p*6.+fbm5(p*3.)),3.)*.9+fbm5(p*30.)*.15;
 return fbm5(p*12.)*.5-craters(p)*.5;}
vec3 shadeSphere(float ty,vec3 nv,vec3 L,float seed){
 if(ty>7.5&&ty<8.5){vec3 ps=rotY(nv,seed);float g=fbm(ps*9.),g2=fbm(ps*30.);return mix(vec3(1.,.5,.12),vec3(1.,.93,.65),smoothstep(.3,.8,g))*(2.6+.5*g2)*(.75+.4*nv.z);}
 float ang=seed*.9;vec3 p=rotY(nv,ang);
 vec3 alb=vec3(.5);float wrap=.1,limb=.3,bump=0.,sp=0.;vec3 atm=vec3(0.);
 if(ty<.5){alb=surfJup(p);wrap=.2;limb=.6;atm=vec3(.95,.7,.45)*.3;}
 else if(ty<1.5){alb=surfSat(p);wrap=.2;limb=.55;atm=vec3(.95,.85,.6)*.25;}
 else if(ty<2.5){alb=surfTitan(p);wrap=.45;limb=.4;atm=vec3(.95,.6,.25)*.6;}
 else if(ty<3.5){alb=surfUra(p);wrap=.3;limb=.5;atm=vec3(.6,.9,.95)*.35;}
 else if(ty<4.5){alb=surfNep(p);wrap=.25;limb=.55;atm=vec3(.25,.45,1.)*.45;}
 else if(ty<5.5){alb=surfIo(p);bump=.02;sp=.1;}
 else if(ty<6.5){alb=surfEur(p);bump=.015;sp=.25;}
 else if(ty<7.5){alb=surfIce(p);bump=.03;sp=.12;}
 else {alb=surfEarth(p);wrap=.15;limb=.4;atm=vec3(.35,.6,1.)*.6;sp=.2;}
 vec3 n=nv;
 if(bump>0.){float e=.0025;float h0=hgt(ty,p);vec3 g=vec3(hgt(ty,p+vec3(e,0.,0.))-h0,hgt(ty,p+vec3(0.,e,0.))-h0,hgt(ty,p+vec3(0.,0.,e))-h0)/e;vec3 pn=normalize(p-bump*(g-dot(g,p)*p));n=rotY(pn,-ang);}
 float lit=pow(clamp((dot(n,L)+wrap)/(1.+wrap),0.,1.),.9);
 float ld=mix(1.,pow(max(nv.z,0.),.55),limb);
 vec3 col=alb*lit*ld*2.2+alb*.01;
 col+=atm*pow(1.-max(nv.z,0.),3.)*lit*1.4;
 vec3 hh=normalize(L+vec3(0.,0.,1.));
 col+=sp*pow(max(dot(n,hh),0.),50.)*lit;
 return col;}
vec3 haloCol(float ty,vec2 dir,float rho,vec3 L){
 float k=.1,ex=14.;vec3 c=vec3(.6,.7,1.);
 if(ty<.5){c=vec3(.95,.7,.45);k=.22;}
 else if(ty<1.5){c=vec3(.95,.85,.6);k=.18;}
 else if(ty<2.5){c=vec3(.95,.6,.25);k=.85;ex=10.;}
 else if(ty<3.5){c=vec3(.6,.9,.95);k=.3;}
 else if(ty<4.5){c=vec3(.25,.45,1.);k=.4;}
 else if(ty>7.5&&ty<8.5){c=vec3(1.,.8,.5);k=1.8;ex=3.5;}
 else if(ty>8.5){c=vec3(.5,.75,1.);k=.3;}
 float lit=clamp(dot(dir,L.xy)*.7+.5,0.,1.);
 if(ty>7.5&&ty<8.5) lit=1.;
 return c*k*exp(-(rho-1.)*ex)*lit;}
float ringDen(float rho,float detail){
 float x=(rho-uRing.x)/(uRing.y-uRing.x);
 if(x<0.||x>1.) return 0.;
 float prof=.28*smoothstep(0.,.03,x)*(1.-smoothstep(.15,.2,x))+smoothstep(.17,.22,x)*(1.-smoothstep(.53,.56,x))+.72*smoothstep(.6,.63,x)*(1.-smoothstep(.86,.88,x))+.62*smoothstep(.9,.92,x)*(1.-smoothstep(.96,.985,x));
 if(detail>.5){float a=fbm5(vec3(rho*140.,uSeed,1.)),b=fbm5(vec3(rho*520.,2.,uSeed));prof*=.45+.9*a*(.6+.8*b);}
 return clamp(prof,0.,1.);}
void modeSpheres(vec2 P,vec2 pxn,out vec3 col,out float depth){
 vec3 L=normalize(rotZ(vec3(-.55,.42,.68),uView.w));
 col=vec3(0.);depth=.08;
 if(uPass<.5) col=background(pxn,P);
 if(uTrail>.5&&uPass<.5){
  for(int i=0;i<5;i++){
   if(float(i+1)>=uN) break;
   vec2 a=uS[i].xy,b=uS[i+1].xy,ab=b-a;float hh=clamp(dot(P-a,ab)/dot(ab,ab),0.,1.);
   vec2 pp=normalize(vec2(-ab.y,ab.x));float ev=mod(float(i),2.);
   float bump=sin(hh*3.14159)*(ev<.5?.22:-.18);
   float d=length(P-(a+ab*hh+pp*bump));
   float dash=.55+.45*step(.5,fract(hh*16.+float(i)*.37));
   vec3 lc=ev<.5?vec3(.3,.75,1.):vec3(1.,.7,.3);
   col+=lc*dash*(exp(-d*d*3200.)*.9+exp(-d*d*220.)*.08);
  }}
 vec3 halo=vec3(0.);
 for(int i=0;i<6;i++){
  if(float(i)>=uN) break;
  vec4 s=uS[i];vec2 d=P-s.xy;float r=s.z,rho=length(d)/r,base=.36+.1*float(i);
  bool inside=rho<1.;float zs=0.;
  if(inside){
   zs=sqrt(max(0.,1.-rho*rho));depth=base+.2*zs;
   if(uPass<.5){
    vec3 nv=vec3(d/r,zs);float sh=1.;
    if(s.w>.5&&s.w<1.5){vec3 Nr=normalize(vec3(uRing.z,.86,uRing.w));float dn=dot(L,Nr);if(abs(dn)>.001){float t=-dot(nv,Nr)/dn;if(t>0.){vec3 h=nv+L*t;sh=1.-.85*ringDen(length(h),0.);}}}
    col=shadeSphere(s.w,nv,L,uSeed+float(i)*1.7)*sh;
   }}
  if(uPass<.5&&!inside&&(rho<1.4||(s.w>7.5&&s.w<8.5&&rho<9.))) halo+=haloCol(s.w,normalize(d),rho,L);
  if(s.w>.5&&s.w<1.5){
   vec3 Nr=normalize(vec3(uRing.z,.86,uRing.w));vec2 q=d/r;float hz=-(Nr.x*q.x+Nr.y*q.y)/Nr.z;
   float rr=length(vec3(q,hz));
   if(rr>uRing.x&&rr<uRing.y&&(!inside||hz>zs)){
    float dn=ringDen(rr,uPass<.5?1.:0.);
    if(dn>.003){
     depth=mix(depth,base+.12+.1*clamp(hz,-1.,1.),clamp(dn*3.,0.,1.));
     if(uPass<.5){
      vec3 hp=vec3(q,hz);float b=dot(hp,L),c=dot(hp,hp)-1.,disc=b*b-c;float lit=1.;
      if(disc>0.&&(-b+sqrt(disc))>0.) lit=.07;
      vec3 rc=mix(vec3(.9,.8,.62),vec3(.66,.52,.36),fbm5(vec3(rr*90.,3.,uSeed)));
      rc*=.7+.5*fbm5(vec3(rr*300.,5.,1.));
      rc*=(.35+.65*abs(dot(Nr,L)))*lit*2.0+.01;
      col=mix(col,rc,clamp(dn*.95,0.,1.));
     }}}}
 }
 col+=halo;
}
#endif

/* ====================== MODE 1/2/3: raymarching (sonda, racheta, antena DSN) ====================== */
#if defined(M1)||defined(M2)||defined(M3)
float sdCyl(vec3 p,float r,float h){vec2 d=abs(vec2(length(p.xy),p.z))-vec2(r,h);return min(max(d.x,d.y),0.)+length(max(d,0.));}
float sdCylY(vec3 p,float r,float h){return sdCyl(vec3(p.x,p.z,p.y),r,h);}
float sdCap(vec3 p,vec3 a,vec3 b,float r){vec3 pa=p-a,ba=b-a;float h=clamp(dot(pa,ba)/dot(ba,ba),0.,1.);return length(pa-ba*h)-r;}
float sdBox(vec3 p,vec3 b){vec3 q=abs(p)-b;return length(max(q,0.))+min(max(q.x,max(q.y,q.z)),0.);}
vec2 opU(vec2 a,vec2 b){return a.x<b.x?a:b;}
#endif

#ifdef M1
vec2 mapScene(vec3 p){
 float dish=max(abs(length(p-vec3(0.,0.,2.8))-2.8)-.014,max(length(p.xy)-1.85,p.z-1.4));
 dish=min(dish,length(vec2(length(p.xy)-1.85,p.z-.7))-.03);
 vec2 r=vec2(dish,1.);
 float st=1e5;
 for(int i=0;i<4;i++){float a=float(i)*1.5708+.7854;st=min(st,sdCap(p,vec3(cos(a)*1.8,sin(a)*1.8,.69),vec3(0.,0.,1.6),.013));}
 st=min(st,sdCyl(p-vec3(0.,0.,1.65),.19,.03));
 r=opU(r,vec2(st,3.));
 r=opU(r,vec2(sdCyl(p-vec3(0.,0.,-.42),.66,.3)-.015,2.));
 vec3 a0=vec3(-.6,0.,-.5),a1=vec3(-3.2,.5,-.95);vec3 dr=normalize(a1-a0);
 r=opU(r,vec2(sdCap(p,a0,a1,.03),3.));
 float rt=1e5;
 for(int i=0;i<3;i++){vec3 c=a0+(a1-a0)*(.42+.17*float(i));rt=min(rt,sdCap(p,c-dr*.26,c+dr*.26,.1));}
 r=opU(r,vec2(rt,5.));
 r=opU(r,vec2(sdCap(p,vec3(.65,0.,-.45),vec3(3.0,-.55,-.3),.028),3.));
 r=opU(r,vec2(sdBox(p-vec3(3.1,-.58,-.3),vec3(.17,.12,.1))-.01,3.));
 r=opU(r,vec2(sdCyl(p-vec3(3.1,-.58,-.17),.045,.08),4.));
 r=opU(r,vec2(sdCap(p,vec3(0.,.6,-.4),vec3(-.5,3.9,-1.1),.012),3.));
 r=opU(r,vec2(sdCap(p,vec3(.1,-.6,-.5),vec3(1.9,-3.3,-1.2),.01),3.));
 vec3 q=p-vec3(0.,-.69,-.48);
 r=opU(r,vec2(sdCyl(vec3(q.x,q.z,q.y),.3,.012),4.));
 return r;}
#endif

#ifdef M2
vec2 mapScene(vec3 p){
 vec2 r=vec2(sdCylY(p-vec3(0.,-.4,0.),.27,1.6),1.);
 r=opU(r,vec2(sdCylY(p-vec3(0.,1.65,0.),.27,.45),6.));
 r=opU(r,vec2(min(sdCap(p,vec3(0.,2.1,0.),vec3(0.,2.65,0.),.27),sdCap(p,vec3(0.,2.65,0.),vec3(0.,3.05,0.),.1)),6.));
 for(int i=0;i<2;i++){
  float sx=i==0?-.5:.5;
  r=opU(r,vec2(sdCylY(p-vec3(sx,-.35,0.),.21,1.65),1.));
  r=opU(r,vec2(sdCap(p,vec3(sx,1.3,0.),vec3(sx,1.75,0.),.2),1.));
  r=opU(r,vec2(sdCylY(p-vec3(sx,-2.1,0.),.13,.1),3.));
 }
 r=opU(r,vec2(sdCylY(p-vec3(0.,-2.1,0.),.15,.1),3.));
 return r;}
#endif

#ifdef M3
vec2 mapScene(vec3 p){
 float g=p.y+1.55+.12*sin(p.x*.7)*sin(p.z*.6)+.05*sin(p.x*2.3+p.z*1.7);
 vec2 r=vec2(g*.6,7.);
 r=opU(r,vec2(sdCylY(p-vec3(0.,-.9,0.),.38,.7),8.));
 vec3 q=rotX(p-vec3(0.,.3,0.),.95);
 float dish=max(abs(length(q-vec3(0.,0.,4.66))-4.66)-.02,max(length(q.xy)-2.1,q.z-1.0));
 dish=min(dish,length(vec2(length(q.xy)-2.1,q.z-.5))-.045);
 r=opU(r,vec2(dish,1.));
 float tr=1e5;
 for(int i=0;i<8;i++){float a=float(i)*.7854;tr=min(tr,sdCap(q,vec3(0.,0.,-.3),vec3(cos(a)*2.0,sin(a)*2.0,.28),.022));}
 tr=min(tr,length(vec2(length(q.xy)-1.2,q.z-.05))-.03);
 tr=min(tr,length(vec2(length(q.xy)-.7,q.z+.12))-.03);
 for(int i=0;i<4;i++){float a=float(i)*1.5708+.7854;tr=min(tr,sdCap(q,vec3(cos(a)*1.95,sin(a)*1.95,.5),vec3(0.,0.,2.3),.017));}
 tr=min(tr,sdCyl(q-vec3(0.,0.,-.25),.3,.3));
 tr=min(tr,sdCyl(q-vec3(0.,0.,2.35),.12,.13));
 r=opU(r,vec2(tr,9.));
 return r;}
#endif

#if defined(M1)||defined(M2)||defined(M3)
vec3 calcN(vec3 p){vec2 e=vec2(.0012,0.);return normalize(vec3(mapScene(p+e.xyy).x-mapScene(p-e.xyy).x,mapScene(p+e.yxy).x-mapScene(p-e.yxy).x,mapScene(p+e.yyx).x-mapScene(p-e.yyx).x));}
float softShadow(vec3 ro,vec3 rd){float res=1.,t=.03;for(int i=0;i<22;i++){float h=mapScene(ro+rd*t).x;res=min(res,8.*h/t);t+=clamp(h,.03,.5);if(res<.01||t>7.)break;}return clamp(res,0.,1.);}
float calcAO(vec3 p,vec3 n){float o=0.,s=1.;for(int i=0;i<4;i++){float h=.03+.13*float(i);float d=mapScene(p+n*h).x;o+=(h-d)*s;s*=.7;}return clamp(1.-1.6*o,0.,1.);}
vec3 envMap(vec3 r,vec3 L){
 float s=pow(max(dot(r,L),0.),24.);
 return mix(vec3(.01,.015,.03),vec3(.06,.08,.14),r.y*.5+.5)+vec3(1.,.85,.6)*s*2.5+vec3(.2,.3,.6)*pow(max(dot(r,normalize(vec3(.6,-.2,-.5))),0.),6.)*.15;}
void modeMarch(vec2 P,vec2 pxn,out vec3 col,out float depth){
 col=vec3(0.);depth=.08;
 if(uPass<.5) col=background(pxn,P);
 vec2 Q=(P-uOff)*uView.z;
 vec3 ro=vec3(0.,0.,10.),rd=normalize(vec3(Q,-3.2));
#ifdef M3
 ro=vec3(0.,.35,9.);
#endif
 float ax=uView.x,ay=uView.y;
 vec3 roO=rotY(rotX(ro,-ax),-ay),rdO=rotY(rotX(rd,-ax),-ay);
 vec3 Lw=normalize(rotY(vec3(-.55,.55,.7),uView.w));vec3 Lo=rotY(rotX(Lw,-ax),-ay);
#ifdef M3
 Lw=normalize(vec3(-.45,.7,.5));Lo=rotY(Lw,-ay);
#endif
 float t0=0.,t1=140.;bool inb=true;
#if defined(M1)||defined(M2)
 vec3 bc=vec3(0.);float br=4.7;
#ifdef M2
 bc=vec3(0.,.4,0.);br=3.7;
#endif
 vec3 oc=roO-bc;float bb=dot(oc,rdO),cc=dot(oc,oc)-br*br,dd=bb*bb-cc;
 inb=dd>0.;
 if(inb){t0=max(0.,-bb-sqrt(dd));t1=-bb+sqrt(dd);}
#endif
 float t=t0,mat=0.;bool hit=false;
 if(inb){for(int i=0;i<84;i++){vec3 pp=roO+rdO*t;vec2 h=mapScene(pp);if(h.x<.0007*t+.0003){hit=true;mat=h.y;break;}t+=h.x*.92;if(t>t1)break;}}
#ifdef M3
 if(!hit&&rdO.y<.02){hit=true;t=t1;mat=7.;}
#endif
 float thit=hit?t:t1;
 if(hit){
  depth=clamp(.5+(10.-t)*.09,.05,.98);
  if(uPass<.5){
   vec3 pO=roO+rdO*t;vec3 nO=calcN(pO);
#ifdef M3
   if(t>=t1-.01){nO=vec3(0.,1.,0.);}
#endif
   vec3 alb=vec3(.5);float metal=0.,rough=.5;
   if(mat<1.5){
#ifdef M2
    float yb=pO.y;float stripe=smoothstep(.02,0.,abs(fract(yb*1.1)-.5)-.45);
    alb=mix(vec3(.9,.9,.88),vec3(.9,.38,.1),smoothstep(.02,.0,abs(yb-.7)-.12));
    alb=mix(alb,vec3(.06),smoothstep(.03,0.,abs(yb+.9)-.05));
#else
    float ang=atan(pO.y,pO.x),rad=length(pO.xy);
    float rib=smoothstep(.9,1.,abs(sin(ang*8.)))*smoothstep(.2,.4,rad);
    float ring=smoothstep(.94,1.,abs(sin(rad*14.)));
    alb=vec3(.86,.87,.88)*(1.-.18*rib-.1*ring)*(.92+.1*fbm5(pO*30.));
#endif
    metal=.05;rough=.5;
   }else if(mat<2.5){
    alb=vec3(.95,.72,.27)*(.55+.9*fbm(pO*16.));
    nO=normalize(nO+.35*(vec3(fbm5(pO*20.),fbm5(pO*20.+3.),fbm5(pO*20.+6.))-.5));metal=.85;rough=.35;
   }else if(mat<3.5){alb=vec3(.16,.16,.17)*(.8+.4*fbm5(pO*25.));metal=.5;rough=.45;}
   else if(mat<4.5){alb=vec3(.98,.78,.3)*(.8+.3*sin(length(pO.xz)*260.));metal=.95;rough=.2;}
   else if(mat<5.5){float fins=smoothstep(.3,.7,abs(sin(pO.x*60.+pO.y*60.)));alb=vec3(.2,.2,.22)*(.8+.4*fins);metal=.4;rough=.4;}
   else if(mat<6.5){alb=vec3(.75,.77,.8)*(.9+.2*fbm5(pO*25.));metal=.5;rough=.35;}
   else if(mat<7.5){alb=vec3(.1,.075,.055)*(.5+1.3*fbm(pO*vec3(2.,.0,2.)+3.));metal=0.;rough=.9;}
   else if(mat<8.5){alb=vec3(.55,.54,.52)*(.8+.3*fbm5(pO*12.));metal=0.;rough=.8;}
   else {alb=vec3(.7,.72,.75)*(.9+.2*fbm5(pO*20.));metal=.4;rough=.4;}
   float sh=softShadow(pO+nO*.02,Lo),ao=calcAO(pO,nO);
   vec3 V=-rdO;float dif=max(dot(nO,Lo),0.)*sh;
   vec3 H=normalize(Lo+V);float spec=pow(max(dot(nO,H),0.),mix(8.,140.,1.-rough))*sh;
   vec3 refl=envMap(reflect(rdO,nO),Lo);
   float fres=pow(1.-max(dot(nO,V),0.),4.);
   vec3 amb=vec3(.02,.03,.06)+vec3(.06,.08,.14)*(nO.y*.5+.5);
   vec3 sunc=vec3(1.35,1.22,1.05);
#ifdef M3
   sunc=vec3(.55,.65,1.1);amb=vec3(.03,.04,.07)+vec3(.05,.07,.12)*(nO.y*.5+.5);
#endif
   vec3 c=alb*(dif*sunc+amb*ao*2.);
   c=mix(c,alb*refl*1.2+spec*alb*2.,metal);
   c+=spec*(1.-metal)*.15+fres*refl*.12;
   float rim=pow(1.-max(dot(nO,V),0.),3.)*max(dot(nO,rotY(rotX(normalize(vec3(.6,.1,-.7)),-ax),-ay)),0.)*.35;
   c+=rim*vec3(.4,.6,1.);
#ifdef M3
   float fog=smoothstep(8.,40.,t);c=mix(c,vec3(.02,.03,.06),fog);
#endif
   col=c;
  }
 }
#ifdef M2
 if(uPass<.5){
  float T=1.;vec3 acc=vec3(0.);
  for(int j=0;j<30;j++){
   float tt=6.2+float(j)*.253;if(tt>thit) break;float wf=smoothstep(6.2,8.2,tt)*smoothstep(13.8,11.6,tt);
   vec3 pp=roO+rdO*tt;
   float dy=-2.1-pp.y;
   float turb=fbm5(pp*vec3(3.,1.2,3.)+vec3(0.,uSeed*3.,0.));
   float dens=0.;
   if(dy>-.1){
    float rad=.2+.2*max(dy,0.);
    float dist=min(length(pp.xz-vec2(-.5,0.)),min(length(pp.xz),length(pp.xz-vec2(.5,0.))));
    dens=smoothstep(rad,0.,dist)*exp(-max(dy,0.)*.55)*(.55+.9*turb)*3.;
   }
   float cl=smoothstep(.42,.75,fbm5(pp*1.5+vec3(0.,uSeed,0.)))*smoothstep(3.6,.6,length(pp.xz))*smoothstep(-3.8,-2.7,pp.y)*smoothstep(-1.6,-2.8,pp.y);
   float glow=exp(-length(pp.xz)*.5)*exp(-max(dy,0.)*.25)*step(-3.5,pp.y);
   vec3 e=dens*mix(vec3(1.,.32,.05),vec3(1.,.92,.65),clamp(dens*.5,0.,1.))*2.2;
   vec3 sm=cl*(vec3(.5,.47,.45)*.35+vec3(1.,.5,.15)*glow*.9);
   float sg=(dens*.8+cl*1.6)*wf;
   acc+=T*(e+sm)*wf*.253;T*=exp(-sg*.253);
  }
  col=col*T+acc;
 }
#endif
 if(!hit&&uPass>.5){
#ifdef M3
  depth=.04;
#endif
 }
}
#endif

/* ====================== MODE 4: discul de aur ====================== */
#ifdef M4
void modeRecord(vec2 P,vec2 pxn,out vec3 col,out float depth){
 col=vec3(0.);depth=.08;
 if(uPass<.5) col=background(pxn,P);
 vec2 Q=(P-uOff)*uView.z;
 vec3 ro=vec3(0.,0.,8.),rd=normalize(vec3(Q,-3.));
 vec3 n=rotX(rotY(vec3(0.,0.,1.),uView.y),uView.x);
 float dn=dot(rd,n);if(abs(dn)<1e-4) return;
 float t=-dot(ro,n)/dn;if(t<0.) return;
 vec3 h=ro+rd*t;
 vec3 ex=rotX(rotY(vec3(1.,0.,0.),uView.y),uView.x),ey=rotX(rotY(vec3(0.,1.,0.),uView.y),uView.x);
 float u=dot(h,ex),v=dot(h,ey);float rad=length(vec2(u,v))/2.;float ang=atan(v,u);
 if(rad>1.012||rad<.045) return;
 depth=.5+.22*h.z;
 if(uPass>.5) return;
 vec3 Lw=normalize(rotY(vec3(-.55,.55,.7),uView.w));
 vec3 V=-rd;vec3 hh=normalize(Lw+V);
 vec3 T=normalize(-v*ex+u*ey);
 float sp=rad*160.+ang*.159;
 float gr=.5+.5*cos(6.2832*sp);
 float amp=.45+.55*smoothstep(.4,.6,fbm5(vec3(rad*30.,0.,uSeed)));
 float zone=smoothstep(.25,.27,rad);
 vec3 gold=vec3(.96,.74,.28);
 vec3 irid=.5+.5*cos(6.2832*(rad*2.2+vec3(0.,.33,.67)+ang*.08));
 float aniso=exp(-pow(dot(hh,T),2.)*9.)*pow(max(dot(n,hh),0.),2.);
 vec3 c=gold*(.5+.5*gr*amp*zone)*(.55+.5*max(dot(n,Lw),0.)+.2);
 c+=irid*.22*aniso*zone*(.4+.6*gr);
 c+=gold*aniso*(.45+.8*gr*zone)*1.3;
 float lab=1.-zone;
 float eng=smoothstep(.55,.6,abs(sin(ang*9.)*sin(rad*70.)));
 c=mix(c,c*.45,lab*eng);
 c*=1.+.06*fbm5(vec3(u*30.,v*30.,uSeed));
 float edge=smoothstep(.985,1.,rad);
 c=mix(c,vec3(1.,.88,.55)*(.8+aniso),edge);
 c*=smoothstep(.045,.06,rad)*smoothstep(1.012,1.0,rad);
 col=c*1.1;
}
#endif

/* ====================== MODE 5: placa de pe coperta discului ====================== */
#ifdef M5
float segD(vec2 p,vec2 a,vec2 b,out float s){vec2 pa=p-a,ba=b-a;float h=clamp(dot(pa,ba)/dot(ba,ba),0.,1.);s=h*length(ba);return length(pa-ba*h);}
void modePlate(vec2 P,vec2 pxn,out vec3 col,out float depth){
 col=vec3(0.);depth=.08;
 if(uPass<.5) col=background(pxn,P);
 vec2 Q=(P-uOff)*uView.z;
 vec3 ro=vec3(0.,0.,8.),rd=normalize(vec3(Q,-3.));
 vec3 n=rotX(rotY(vec3(0.,0.,1.),uView.y),uView.x);
 float dn=dot(rd,n);if(abs(dn)<1e-4) return;
 float t=-dot(ro,n)/dn;if(t<0.) return;
 vec3 h=ro+rd*t;
 vec3 ex=rotX(rotY(vec3(1.,0.,0.),uView.y),uView.x),ey=rotX(rotY(vec3(0.,1.,0.),uView.y),uView.x);
 vec2 uv=vec2(dot(h,ex),dot(h,ey))/2.2;
 if(abs(uv.x)>1.||abs(uv.y)>1.) return;
 depth=.5+.2*h.z;
 if(uPass>.5) return;
 vec3 Lw=normalize(rotY(vec3(-.55,.55,.7),uView.w));
 vec3 V=-rd;vec3 hh=normalize(Lw+V);
 float brush=fbm5(vec3(uv.x*3.,uv.y*160.,uSeed));
 vec3 base=vec3(.86,.66,.3)*(.7+.5*brush);
 float lines=0.;
 vec2 O=vec2(-.35,-.45);
 for(int k=0;k<14;k++){
  float a=hash13(vec3(float(k),uSeed,1.))*6.2832,l=.3+.55*hash13(vec3(float(k),uSeed,2.));
  float s;float d=segD(uv,O,O+vec2(cos(a),sin(a))*l,s);
  float tick=step(.5,fract(s*46.+float(k)*.31));
  lines=max(lines,smoothstep(.007,.003,d)*(.5+.5*tick));
  lines=max(lines,smoothstep(.016,.0,length(uv-O-vec2(cos(a),sin(a))*l))*.8);
 }
 lines=max(lines,smoothstep(.012,.006,abs(length(uv-vec2(-.68,.62))-.13)));
 lines=max(lines,smoothstep(.012,.006,abs(length(uv-vec2(-.68,.62))-.05)));
 float s2;lines=max(lines,smoothstep(.006,.003,segD(uv,vec2(-.68,.62),vec2(-.68,.35),s2)));
 lines=max(lines,smoothstep(.012,.006,abs(length(uv-vec2(.5,-.5))-.38))*(.5+.5*step(.5,fract(atan(uv.y+.5,uv.x-.5)*8.))));
 lines=max(lines,smoothstep(.012,.006,abs(length(uv-vec2(.5,-.5))-.12)));
 for(int k=0;k<12;k++){float x=-.95+float(k)*.05;float on=step(.5,hash13(vec3(float(k),uSeed,7.)));lines=max(lines,on*smoothstep(.012,.006,abs(uv.x-x))*step(abs(uv.y-.88),.04));}
 float fr=smoothstep(.02,.0,abs(max(abs(uv.x),abs(uv.y))-.97));lines=max(lines,fr);
 vec3 c=mix(base,vec3(.14,.09,.03),lines*.9);
 float aniso=exp(-pow(dot(hh,vec3(1.,0.,0.)),2.)*2.)*pow(max(dot(n,hh),0.),3.);
 c=c*(.55+.55*max(dot(n,Lw),0.))+vec3(1.,.85,.5)*aniso*(1.-lines)*.5*(.6+brush);
 col=c*1.05;
}
#endif

/* ====================== MODE 6: heliosfera ====================== */
#ifdef M6
float hpR(float th){float k=.5*(1.-cos(th));return mix(1.05,2.7,pow(k,1.4));}
void modeBubble(vec2 P,vec2 pxn,out vec3 col,out float depth){
 vec2 Q=(P-uOff)*uView.z;
 col=vec3(0.);depth=.1;
 if(uPass<.5) col=background(pxn,P)*.8;
 vec2 sun=vec2(-.55,0.);
 vec2 d=Q-sun;float rr=length(d),th=atan(d.y,d.x);
 float R=hpR(th)*(1.+.07*(fbm5(vec3(th*3.,uSeed,1.))-.5));
 float f=rr/R;
 float sheath=smoothstep(.55,.66,f)*(1.-smoothstep(.97,1.,f));
 if(uPass>.5){depth=mix(.12,.62,sheath)+exp(-rr*rr*180.)*.3+.2*exp(-f*5.)*(1.-sheath);return;}
 float flow=fbm5(vec3(f*24.,th*9.,uSeed+2.)),flow2=fbm5(vec3(f*60.,th*30.,uSeed+4.));
 vec3 add=vec3(0.);
 add+=sheath*(vec3(.18,.28,.9)*(.35+1.1*flow)+vec3(.7,.3,.9)*pow(flow2,3.)*.9);
 add+=vec3(1.,.8,.6)*exp(-pow((f-.6)/.012,2.))*(.5+flow)*.8;
 add+=vec3(.6,.9,1.)*exp(-pow((f-.99)/.01,2.))*1.5+vec3(.3,.6,1.)*exp(-pow((f-.99)/.05,2.))*.25;
 add+=vec3(1.,.75,.4)*exp(-f*5.)*.6*(1.-sheath);
 float fb=rr/(R*1.28);add+=vec3(.9,.4,.8)*exp(-pow((fb-1.)/.01,2.))*.3;
 add+=vec3(.5,.7,1.)*smoothstep(1.,1.5,f)*(1.-smoothstep(1.5,2.6,f))*pow(fbm5(vec3(Q.x*1.5-Q.y*.2,Q.y*24.,uSeed)),3.)*.18;
 add+=vec3(1.,.85,.5)*(exp(-rr*rr*180.)*5.+exp(-rr*18.)*.5);
 for(int i=0;i<2;i++){
  float a=i==0?.62:-.72;vec2 dir=vec2(cos(a),sin(a));float len=hpR(a)*1.12;
  float s=dot(Q-sun,dir),pd=length(Q-sun-dir*clamp(s,0.,len));float dash=.5+.5*step(.5,fract(s*18.));
  vec3 lc=i==0?vec3(.3,.8,1.):vec3(1.,.75,.3);
  add+=lc*dash*exp(-pd*pd*9000.)*step(0.,s)*1.1;
  vec2 pe=sun+dir*len;float g=length(Q-pe);
  add+=lc*(exp(-g*g*6000.)*3.+exp(-g*30.)*.25)+vec3(1.)*exp(-abs(Q.x-pe.x)*70.)*exp(-abs(Q.y-pe.y)*7.)*.35;
 }
 col+=add;
}
#endif

/* ====================== MODE 7: Pale Blue Dot ====================== */
#ifdef M7
void modeDot(vec2 P,vec2 pxn,out vec3 col,out float depth){
 col=vec3(0.);depth=.1;
 vec2 o=vec2(-1.8,1.2);vec2 dir=normalize(vec2(1.,-.62));vec2 pp=P-o;
 float u=dot(pp,dir),v=dot(pp,vec2(-dir.y,dir.x));
 float w=.12+.05*u;float beam=exp(-v*v/(w*w));
 vec2 dp=vec2(.42,-.22);float dd=length(P-dp)*(uRes.y/1080.)*540.;
 if(uPass>.5){depth=mix(.18+.25*beam*smoothstep(0.,.6,u),.88,exp(-dd*dd/500.));return;}
 col=vec3(.003,.004,.008)+background(pxn,P)*.22;
 float st=fbm(vec3(v*18.,u*1.4,uSeed))*.7+fbm5(vec3(v*70.,u*3.,uSeed+2.))*.5;
 vec3 bc=mix(vec3(.9,.55,.2),vec3(.95,.8,.55),fbm5(vec3(u*2.,v*5.,3.)));
 col+=bc*beam*st*.55*smoothstep(0.,.6,u);
 col+=vec3(.7,.45,.2)*exp(-pow((v-.45)/.012,2.))*.1*smoothstep(0.,.8,u);
 float g=exp(-dd*dd/(2.*1.7*1.7));
 col+=vec3(.62,.8,1.)*g*2.2+vec3(.5,.7,1.)*exp(-dd/9.)*.12;
}
#endif

void main(){
 vec2 px=gl_FragCoord.xy;
 vec2 P=(px-.5*uRes)/(.5*uRes.y);
 vec2 pxn=px*(1080./uRes.y);
 vec3 col=vec3(0.);float depth=.1;
#ifdef M0
 modeSpheres(P,pxn,col,depth);
#endif
#if defined(M1)||defined(M2)||defined(M3)
 modeMarch(P,pxn,col,depth);
#endif
#ifdef M4
 modeRecord(P,pxn,col,depth);
#endif
#ifdef M5
 modePlate(P,pxn,col,depth);
#endif
#ifdef M6
 modeBubble(P,pxn,col,depth);
#endif
#ifdef M7
 modeDot(P,pxn,col,depth);
#endif
#ifdef M8
 if(uPass<.5) col=background(pxn,P);
#endif
 if(uPass>.5){gl_FragColor=vec4(vec3(clamp(depth,0.,1.)),1.);return;}
 col=1.-exp(-col*1.25);
 col=pow(col,vec3(1./2.2));
 vec2 vc=P*vec2(.5,.62);col*=1.-.28*dot(vc,vc);
 col+=(hash13(vec3(px,uSeed))-.5)/160.;
 gl_FragColor=vec4(col,1.);
}
