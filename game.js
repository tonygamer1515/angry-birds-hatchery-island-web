(() => {
'use strict';
const $=(s,r=document)=>r.querySelector(s), $$=(s,r=document)=>[...r.querySelectorAll(s)];
const clamp=(v,a,b)=>Math.max(a,Math.min(b,v));
const canvas=$('#game'),ctx=canvas.getContext('2d',{alpha:false});
let W=0,H=0,DPR=1,uiScale=1,registry,data,levelsData,levelsPromise,physicsData,atlasImages=new Map(),screen='loading',time=0,last=performance.now();
const TILE_W=196,TILE_H=97,MAP_ORIGIN_X=70*TILE_W/2;
const camera={x:5480,y:2380,zoom:1,drag:false,startX:0,startY:0,baseX:0,baseY:0,moved:false};
const pointers=new Map();
const audio={title:new Audio('assets/audio/title_theme.mp3'),ambient:new Audio('assets/audio/hatchery_ambient.mp3'),level:null};
audio.title.loop=audio.ambient.loop=true;audio.title.volume=.38;audio.ambient.volume=.34;
let soundOn=true,titleButton={x:0,y:0,w:0,h:0},placement=null,selected=null,toastTimer=0,slingshot=null,nextBirdVoiceAt=performance.now()+7000;
let baseTiles=[],worldDecor=[],worldObstacles=[],dynamicDecor=[];

const freshSave=()=>({version:3,stars:60,coins:300,objects:[
 {id:'nest-1',type:'nest',x:5480,y:2400,state:'empty',created:Date.now()}
],removed:[],taskTier:0,taskProgress:[0,0,0],scores:{},highScores:{},achievements:{maleBirds:0,femaleBirds:0},tutorial:{completed:false,slingShown:false},sound:true});
let save=loadSave();soundOn=save.sound!==false;
function loadSave(){
 try{
  const parsed=JSON.parse(localStorage.getItem('hatchery-island-save')||'{}'),merged={...freshSave(),...parsed};
  merged.objects=(merged.objects||[]).filter(object=>object.id!=='bird-1'&&object.id!=='bird-2');
  merged.achievements={...freshSave().achievements,...(parsed.achievements||{})};merged.tutorial={...freshSave().tutorial,...(parsed.tutorial||{})};
  if(!parsed.version||parsed.version<3){
   const birds=merged.objects.filter(object=>object.type==='bird');
   birds.forEach((object,index)=>{object.gender=object.gender||(index%2?'female':'male');object.voice=object.voice||((object.birdIndex||index)%12+1)});
   merged.achievements.maleBirds=birds.filter(object=>object.gender==='male').length;merged.achievements.femaleBirds=birds.filter(object=>object.gender==='female').length;
   if((merged.taskTier||0)===0){merged.taskProgress=merged.taskProgress||[0,0,0];merged.taskProgress[0]=birds.some(object=>object.gender==='female')?1:0;merged.taskProgress[1]=birds.some(object=>object.gender==='male')?1:0}
   merged.version=3;localStorage.setItem('hatchery-island-save',JSON.stringify(merged));
  }
  return merged;
 }catch{return freshSave()}
}
function persist(){localStorage.setItem('hatchery-island-save',JSON.stringify(save))}
const HATCHERY_VOICES=Array.from({length:12},(_,index)=>`h_bird_idle_${index+1}.wav`);
const BIRD_SOUND_PACKS={
 RED:{select:'bird 01 select.mp3',launch:'bird 01 flying.mp3',collision:['bird 01 collision a1.mp3','bird 01 collision a2.mp3','bird 01 collision a3.mp3','bird 01 collision a4.mp3']},
 BLUE:{select:'bird 02 select.mp3',launch:'bird 02 flying.mp3',collision:['bird 02 collision a1.mp3','bird 02 collision a2.mp3','bird 02 collision a3.mp3','bird 02 collision a4.mp3','bird 02 collision a5.mp3']},
 YELLOW:{select:'bird 03 select.mp3',launch:'bird 03 flying.mp3',collision:['bird 03 collision a1.mp3','bird 03 collision a2.mp3','bird 03 collision a3.mp3','bird 03 collision a4.mp3','bird 03 collision a5.mp3']},
 BLACK:{select:'bird 04 select.mp3',launch:'bird 04 flying.mp3',collision:['bird 04 collision a1.mp3','bird 04 collision a2.mp3','bird 04 collision a3.mp3','bird 04 collision a4.mp3']},
 WHITE:{select:'bird 05 select.mp3',launch:'bird 05 flying.mp3',collision:['bird 05 collision a1.mp3','bird 05 collision a2.mp3','bird 05 collision a3.mp3','bird 05 collision a4.mp3','bird 05 collision a5.mp3']},
 GREEN:{select:'boomerang_select.mp3',launch:'bird_06_flying.mp3',collision:['bird 03 collision a1.mp3','bird 03 collision a2.mp3','bird 03 collision a3.mp3']},
 BIGBROTHER:{select:'bigbrother_select.mp3',launch:'bigbrother_fly.mp3',collision:['bird 01 collision a1_low.mp3','bird 01 collision a2_low.mp3','bird 01 collision a3_low.mp3','bird 01 collision a4_low.mp3']},
 ORANGE:{select:'Globe_Bird_Selection_1.mp3',launch:'Globe_Bird_Launch_3.mp3',collision:['Globe_Bird_Hit_1.mp3','Globe_Bird_Hit_2.mp3','Globe_Bird_Hit_3.mp3','Globe_Bird_Hit_4.mp3']}
};
function play(name,vol=.7){if(!soundOn||!name)return;const a=new Audio(`assets/audio/${name}`);a.volume=vol;a.play().catch(()=>{})}
function playRandom(list,volume=.7){if(list?.length)play(list[Math.floor(Math.random()*list.length)],volume)}
function birdSoundPack(source){const bird=getBird(source),key=String(bird?.color||bird?.shape||'RED').toUpperCase();return BIRD_SOUND_PACKS[key]||BIRD_SOUND_PACKS.RED}
function birdVoiceFile(object){return HATCHERY_VOICES[clamp((object?.voice||1)-1,0,HATCHERY_VOICES.length-1)]}
function playBirdVoice(object,volume=.65){play(birdVoiceFile(object),volume)}
function materialSound(body,phase){
 const material=body?.plugin?.material||'wood',prefix=material==='piglette'?'piglette':material==='rock'?'rock':material==='light'?'light':'wood';
 if(phase==='destroyed')return prefix==='piglette'?'piglette destroyed.mp3':`${prefix} destroyed a${1+Math.floor(Math.random()*3)}.mp3`;
 const amount=phase==='damage'?(prefix==='piglette'?8:3):(prefix==='piglette'||prefix==='light'?8:prefix==='wood'?6:5);return`${prefix} ${phase} a${1+Math.floor(Math.random()*amount)}.mp3`;
}
function setMusic(which){Object.values(audio).filter(Boolean).forEach(a=>{if(a!==audio[which]){a.pause();a.currentTime=0}});if(soundOn&&which&&audio[which])audio[which].play().catch(()=>{})}
function setLevelAmbience(theme){
 const index=parseInt(String(theme||'theme1').match(/\d+/)?.[0]||'1');
 const file=index===17?'ab_cave_ambient.mp3':index===18?'birthday_ambience.mp3':[4,9,10,11,12,13,14].includes(index)?'ambient_construction.mp3':index===2?'ambient_green_jungleish.mp3':index===3?'ambient_red_savannah.mp3':index===7?'ambient_city.mp3':'ambient_white_dryforest.mp3';
 if(audio.level){audio.level.pause();audio.level.src=''}
 audio.level=new Audio(`assets/audio/${file}`);audio.level.loop=true;audio.level.volume=.32;setMusic('level');
}
function toast(text){const el=$('#toast');el.textContent=text;el.classList.add('show');clearTimeout(toastTimer);toastTimer=setTimeout(()=>el.classList.remove('show'),1500)}

class SpriteLibrary{
 constructor(reg){this.reg=reg;this.pending=new Map();this.failed=new Set();this.queue=[];this.active=0}
 loadAtlas(name){
  if(atlasImages.has(name))return Promise.resolve(atlasImages.get(name));
  if(this.pending.has(name))return this.pending.get(name);
  const url=this.reg.atlases[name];
  if(!url)return Promise.reject(new Error(`Unknown sprite atlas: ${name}`));
  const promise=new Promise((resolve,reject)=>{this.queue.push({name,url,resolve,reject});this.pump()});
  this.pending.set(name,promise);return promise;
 }
 pump(){
  while(this.active<3&&this.queue.length){
   const job=this.queue.shift(),image=new Image();this.active++;image.decoding='async';
   image.onload=()=>{atlasImages.set(job.name,image);this.pending.delete(job.name);this.active--;job.resolve(image);this.pump()};
   image.onerror=()=>{const error=new Error(`Could not load ${job.url}`);this.failed.add(job.name);this.pending.delete(job.name);this.active--;job.reject(error);this.pump()};
   image.src=job.url;
  }
 }
 request(name){if(!name||atlasImages.has(name)||this.failed.has(name))return;this.loadAtlas(name).catch(error=>console.warn(error.message))}
 async load(names){
  const results=await Promise.allSettled(names.filter(name=>this.reg.atlases[name]).map(name=>this.loadAtlas(name)));
  if(results.length&&results.every(result=>result.status==='rejected'))throw results[0].reason;
 }
 meta(name){return this.reg.sprites[name]}
 image(atlas){const image=atlasImages.get(atlas);if(!image)this.request(atlas);return image}
 draw(name,x,y,scale=1,angle=0,alpha=1,context=ctx){const s=this.meta(name);if(!s)return false;const im=this.image(s.atlas);if(!im)return false;context.save();context.globalAlpha=alpha;context.translate(x,y);context.rotate(angle);context.scale(scale,scale);context.drawImage(im,s.x,s.y,s.w,s.h,-s.ox,-s.oy,s.w,s.h);context.restore();return true}
 drawCentered(name,x,y,maxW,maxH,context=ctx){const s=this.meta(name);if(!s)return false;const im=this.image(s.atlas);if(!im)return false;const scale=Math.min(maxW/s.w,maxH/s.h);context.drawImage(im,s.x,s.y,s.w,s.h,x-s.w*scale/2,y-s.h*scale/2,s.w*scale,s.h*scale);return true}
 raw(name){const s=this.meta(name);if(!s)return null;const image=this.image(s.atlas);return image?{s,image}:null}
}
let sprites;

function resize(){const r=canvas.getBoundingClientRect();DPR=Math.min(1.5,devicePixelRatio||1);W=r.width;H=r.height;canvas.width=Math.round(W*DPR);canvas.height=Math.round(H*DPR);ctx.setTransform(DPR,0,0,DPR,0,0);uiScale=Math.min(W/1024,H/768)}
addEventListener('resize',resize);resize();

async function boot(){
 try{
  const json=async url=>{const response=await fetch(url);if(!response.ok)throw new Error(`${url}: HTTP ${response.status}`);return response.json()};
  levelsPromise=json('assets/data/levels.json?build=7').then(value=>(levelsData=value));
  const [s,g,p]=await Promise.all([json('assets/data/sprites.json?build=7'),json('assets/data/game-data.json?build=7'),json('assets/data/physics.json?build=7')]);
  registry=s;data=g;physicsData=p;sprites=new SpriteLibrary(s);
  // Boot only the title atlases. The old 100+ MB all-at-once decode could make
  // mobile Safari reject an Image event, which appeared as "LOAD ERROR: undefined".
  await sprites.load(['BACKGROUNDS_MAIN_1.pvr','MENU_ELEMENTS_2.png','BUTTONS_HATCHERY_1.pvr']);
  prepareMap();$('#loading').hidden=true;screen='title';requestAnimationFrame(frame)
 }catch(e){const message=e?.message||String(e||'unknown resource failure');$('#loading b').textContent='LOAD ERROR: '+message;console.error(e)}
}
function tilePoint(col,row){return{x:(col-row)*TILE_W/2+MAP_ORIGIN_X,y:(col+row)*TILE_H/2}}
function prepareMap(){
 const layers=Object.fromEntries(data.map.layers.map(l=>[l.name,l]));const defs=data.objects;
 for(let row=0;row<70;row++)for(let col=0;col<70;col++){
  const i=row*70+col,p=tilePoint(col,row),base=layers.Base.data[i],dyn=layers.Dynamic.data[i];
  if(base&&defs[String(base)]?.sprites?.[0])baseTiles.push({x:p.x,y:p.y,sprite:defs[String(base)].sprites[0]});
  if(dyn&&defs[String(dyn)]?.sprites?.[0])worldObstacles.push({id:`map-${i}`,gid:dyn,x:p.x,y:p.y,sprite:defs[String(dyn)].sprites[0],def:defs[String(dyn)]});
 }
 const make=(o,i)=>{const def=defs[String(o.gid)];return def?.sprites?.[0]?{id:`deco-${i}`,gid:o.gid,x:o.x,y:o.y,sprite:def.sprites[0],def}:null};
 worldDecor=layers.Decoration.objects.map(make).filter(Boolean);dynamicDecor=layers.DynamicDecoration.objects.map(make).filter(Boolean);
 worldObstacles=worldObstacles.filter(o=>!save.removed.includes(o.id));updateHud()
}

function visible(x,y,pad=220){const l=camera.x-W/(2*camera.zoom)-pad,r=camera.x+W/(2*camera.zoom)+pad,t=camera.y-H/(2*camera.zoom)-pad,b=camera.y+H/(2*camera.zoom)+pad;return x>l&&x<r&&y>t&&y<b}
function worldTransform(){ctx.translate(W/2-camera.x*camera.zoom,H/2-camera.y*camera.zoom);ctx.scale(camera.zoom,camera.zoom)}
function renderTitle(){
 ctx.fillStyle='#12a6bd';ctx.fillRect(0,0,W,H);const bg=sprites.raw('MENU_BACKGROUND_TOP');if(bg){ctx.drawImage(bg.image,bg.s.x,bg.s.y,bg.s.w,bg.s.h,0,0,W/2,H);ctx.save();ctx.translate(W,0);ctx.scale(-1,1);ctx.drawImage(bg.image,bg.s.x,bg.s.y,bg.s.w,bg.s.h,0,0,W/2,H);ctx.restore()}
 sprites.drawCentered('MENU_LOGO',W/2,H*.22,W*.82,H*.3);const pulse=1+Math.sin(time*3)*.025;const m=sprites.meta('H_BUTTON_HATCHERY'),bw=Math.min(W*.34,390)*pulse,bh=bw*(m.h/m.w);sprites.drawCentered('H_BUTTON_HATCHERY',W/2,H*.59,bw,bh);titleButton={x:W/2-bw/2,y:H*.59-bh/2,w:bw,h:bh};
 drawBird(data.prototypeBirds[0],W*.25,H*.73,uiScale*.85,0);drawBird(data.prototypeBirds[2],W*.75,H*.73,uiScale*.85,0);ctx.fillStyle='#fff';ctx.textAlign='center';ctx.font=`900 ${Math.max(15,23*uiScale)}px Arial Rounded MT Bold`;ctx.shadowColor='#07516b';ctx.shadowBlur=4;ctx.fillText('TAP HATCHERY TO ENTER',W/2,H*.9);ctx.shadowBlur=0
}

function renderWorld(){
 ctx.fillStyle='#71cddd';ctx.fillRect(0,0,W,H);ctx.save();worldTransform();
 for(const t of baseTiles)if(visible(t.x,t.y,150))sprites.draw(t.sprite,t.x,t.y);
 const drawables=[];
 for(const o of worldDecor)if(visible(o.x,o.y))drawables.push(o);
 for(const o of dynamicDecor)if(visible(o.x,o.y))drawables.push(o);
 for(const o of worldObstacles)if(visible(o.x,o.y))drawables.push(o);
 for(const o of save.objects)if(visible(o.x,o.y,260))drawables.push(o);
 drawables.sort((a,b)=>(a.y+(a.def?.renderQueue||0)*2)-(b.y+(b.def?.renderQueue||0)*2));
 for(const o of drawables)drawWorldObject(o);
 if(placement){const p=screenToWorld(placement.pointerX,placement.pointerY),tile=worldToTile(p.x,p.y),snap=tilePoint(tile.col,tile.row);ctx.globalAlpha=.65;drawPlacement(placement.type,snap.x,snap.y);ctx.globalAlpha=1}
 ctx.restore();
}
function updateWorldAmbience(now){if(!soundOn||now<nextBirdVoiceAt||$('#panel').hidden===false)return;const birds=save.objects.filter(object=>object.type==='bird');if(birds.length)playBirdVoice(birds[Math.floor(Math.random()*birds.length)],.24);nextBirdVoiceAt=now+8000+Math.random()*9000}
function getBird(o){return o.custom||data.prototypeBirds[o.birdIndex%data.prototypeBirds.length]}
function drawWorldObject(o){
 if(o.type==='nest'){const bob=Math.sin(time*2+o.x)*1.5;sprites.draw('H_GAME_OBJECT_NEST_1_BOTTOM',o.x,o.y+bob);if(o.state==='incubating'||o.state==='ready')sprites.draw('H_GAME_OBJECT_EGG_1',o.x,o.y-48+bob,.52,Math.sin(time*4)*.03);sprites.draw('H_GAME_OBJECT_NEST_1_TOP',o.x,o.y+bob);if(o.state==='incubating')drawTimer(o)}
 else if(o.type==='bird'){const b=getBird(o);drawBird(b,o.x,o.y+Math.sin(time*2.1+o.birdIndex)*5,.5,time)}
 else{let angle=0,scale=1;if(o.def?.animation){angle=Math.sin(time*(o.def.animation.speedMin||1)+o.x)*.025;scale=1+Math.sin(time*1.7+o.y)*.012}sprites.draw(o.sprite,o.x,o.y,scale,angle)}
}
function drawPlacement(type,x,y){if(type==='nest'||(type==='move'&&placement.object?.type==='nest')){sprites.draw('H_GAME_OBJECT_NEST_1_BOTTOM',x,y);sprites.draw('H_GAME_OBJECT_NEST_1_TOP',x,y)}else if(type==='move'&&placement.object?.type==='bird'){drawBird(getBird(placement.object),x,y,.5,time)}else sprites.draw('H_GAME_OBJECT_EGG_1',x,y-40,.5)}
function drawTimer(o){const elapsed=(Date.now()-o.created)/1000,ratio=clamp(elapsed/60,0,1);if(ratio>=1)o.state='ready';ctx.save();ctx.translate(o.x-42,o.y-105);ctx.fillStyle='#123b48cc';ctx.fillRect(0,0,84,9);ctx.fillStyle='#ffcc1b';ctx.fillRect(2,2,80*ratio,5);ctx.restore()}
function drawBird(b,x,y,scale=.5,t=time,context=ctx){if(!b)return;const shape=b.shape||'RED',color=b.color||shape,eyes=b.eyes||shape,beak=b.beak||shape;let body=b.sprite||`BIRD_BODY_${shape}_${color}`;if(!sprites.meta(body))body='BIRD_BODY_RED_RED';const blink=(t+Number(b.id||0))%4<.12,eyeNormal=`BIRD_EYES_${eyes}_NORMAL`,eyeBlink=`BIRD_EYES_${eyes}_BLINK`,mouth=`BIRD_BEAK_${beak}_NORMAL`;context.save();context.translate(x,y+Math.sin(t*2+Number(b.id||0))*2);const parts=b.sprites||[];if(parts.length){for(const part of parts){let name=part.sprite;if(String(name).startsWith('BIRD_BODY_'))name=body;else if(String(name).startsWith('BIRD_EYES_'))name=blink&&sprites.meta(eyeBlink)?eyeBlink:eyeNormal;else if(String(name).startsWith('BIRD_BEAK_'))name=mouth;if(!sprites.meta(name))continue;sprites.draw(name,(part.x||0)*scale,(part.y||0)*scale,scale*(part.scale||1),-(part.angle||0),1,context)}}else{sprites.draw(body,0,0,scale,0,1,context);sprites.draw(blink&&sprites.meta(eyeBlink)?eyeBlink:eyeNormal,4*scale,-18*scale,scale,0,1,context);sprites.draw(mouth,28*scale,7*scale,scale,0,1,context)}context.restore()}

function screenToWorld(x,y){return{x:(x-W/2)/camera.zoom+camera.x,y:(y-H/2)/camera.zoom+camera.y}}
function worldToTile(x,y){const dx=x-MAP_ORIGIN_X,a=dx/(TILE_W/2),b=y/(TILE_H/2);return{col:clamp(Math.round((a+b)/2),0,69),row:clamp(Math.round((b-a)/2),0,69)}}
function objectAt(x,y){const all=[...save.objects,...worldObstacles];let best=null,dist=95/camera.zoom;for(const o of all){const d=Math.hypot(o.x-x,o.y-y);if(d<dist){best=o;dist=d}}return best}

function handleTap(x,y){
 if(screen==='title'){if(x>=titleButton.x&&x<=titleButton.x+titleButton.w&&y>=titleButton.y&&y<=titleButton.y+titleButton.h){play('menu_confirm.mp3');setMusic('ambient');screen='world';$('#hud').hidden=false;nextBirdVoiceAt=performance.now()+5000;toast('WELCOME TO HATCHERY ISLAND!');if(!save.tutorial.completed)setTimeout(()=>{if(screen==='world')showTutorial(0)},450)}return}
 if(screen!=='world')return;const w=screenToWorld(x,y);
 if(placement){const tile=worldToTile(w.x,w.y),p=tilePoint(tile.col,tile.row);if(placement.type==='nest'){if(save.coins<20)return toast('NOT ENOUGH COINS');save.coins-=20;save.objects.push({id:'nest-'+Date.now(),type:'nest',x:p.x,y:p.y,state:'empty',created:Date.now()});play('h_purchase.wav')}else if(placement.type==='move'&&placement.object){placement.object.x=p.x;placement.object.y=p.y;play('abi_inventory_place.mp3')}placement=null;$$('.tools button').forEach(b=>b.classList.remove('active'));persist();updateHud();return}
 const o=objectAt(w.x,w.y);if(o)openContext(o)
}
function openContext(o){selected=o;const box=$('#contextMenu'),title=$('#contextTitle'),text=$('#contextText'),actions=$('#contextActions');actions.innerHTML='';box.hidden=false;
 if(o.type==='nest'){title.textContent='NEST';if(o.state==='empty'){text.textContent='This nest is ready for an egg.';addAction('ADD EGG · 20',()=>addEgg(o))}else if(o.state==='incubating'){const left=Math.max(0,Math.ceil(60-(Date.now()-o.created)/1000));text.textContent=`The egg hatches in ${left} seconds.`;addAction('HURRY · 10 ★',()=>hurry(o))}else{text.textContent='The egg is ready. Choose its gender and voice before hatching.';addAction('CHOOSE & HATCH!',()=>openHatchDialog(o))}addAction('MOVE',()=>beginMove(o))}
 else if(o.type==='bird'){title.textContent=`${o.gender==='female'?'FEMALE':'MALE'} HATCHED BIRD`;text.textContent=`Voice pack ${o.voice||1}. This bird is part of your slingshot flock.`;addAction('HEAR VOICE',()=>playBirdVoice(o));addAction('CUSTOMIZE',()=>openBirdDesigner(o));addAction('REMOVE',()=>removeUser(o))}
 else{title.textContent='CLEAR OBSTACLE';text.textContent='Clear this object to make room for a nest.';addAction('CLEAR · 20',()=>clearObstacle(o))}}
function addAction(label,fn){const b=document.createElement('button');b.textContent=label;b.onclick=()=>{play('menu_confirm.mp3');$('#contextMenu').hidden=true;fn()};$('#contextActions').append(b)}
function addEgg(n){if(save.coins<20)return toast('NOT ENOUGH COINS');save.coins-=20;n.state='incubating';n.created=Date.now();persist();updateHud();play('h_egg_selected.wav');toast('EGG ADDED')}
function hurry(n){if(save.stars<10)return toast('NOT ENOUGH STARS');save.stars-=10;n.state='ready';persist();updateHud();play('h_marker_1.mp3')}
function openHatchDialog(n){
 let gender=n.pendingGender||'male',voice=n.pendingVoice||1+Math.floor(Math.random()*HATCHERY_VOICES.length),index=Math.floor(Math.random()*data.prototypeBirds.length);
 $('#panelTitle').textContent='HATCH YOUR BIRD';const body=$('#panelBody');
 body.innerHTML='<div class="hatch-choice"><canvas id="hatchPreview" width="300" height="240"></canvas><h3>CHOOSE ONE GENDER</h3><div class="gender-choice"><button data-gender="male">♂ MALE</button><button data-gender="female">♀ FEMALE</button></div><h3>CHOOSE A VOICE PACK</h3><div class="voice-choice"><button id="voicePrev">‹</button><b id="voiceName"></b><button id="voicePlay">▶ PREVIEW</button><button id="voiceNext">›</button></div><p>Gender achievements only count the gender selected here.</p><button class="action" id="confirmHatch">HATCH BIRD</button></div>';
 const redraw=()=>{const canvas=$('#hatchPreview'),preview=canvas.getContext('2d');preview.clearRect(0,0,canvas.width,canvas.height);drawBird(data.prototypeBirds[index],150,145,.78,time,preview);$$('[data-gender]',body).forEach(button=>button.classList.toggle('active',button.dataset.gender===gender));$('#voiceName').textContent=`VOICE ${voice} OF ${HATCHERY_VOICES.length}`};
 $$('[data-gender]',body).forEach(button=>button.onclick=()=>{gender=button.dataset.gender;play('h_OK_1.wav');redraw()});
 $('#voicePrev').onclick=()=>{voice=voice<=1?HATCHERY_VOICES.length:voice-1;play(HATCHERY_VOICES[voice-1]);redraw()};
 $('#voiceNext').onclick=()=>{voice=voice>=HATCHERY_VOICES.length?1:voice+1;play(HATCHERY_VOICES[voice-1]);redraw()};
 $('#voicePlay').onclick=()=>play(HATCHERY_VOICES[voice-1]);
 $('#confirmHatch').onclick=()=>hatch(n,{index,gender,voice});redraw();openPanel();
}
function hatch(n,{index,gender,voice}){
 const object={id:'bird-'+Date.now(),type:'bird',x:n.x+95,y:n.y+25,birdIndex:index,gender,voice};save.objects.push(object);n.state='empty';n.created=Date.now();delete n.pendingGender;delete n.pendingVoice;
 save.achievements=save.achievements||{maleBirds:0,femaleBirds:0};save.achievements[gender==='female'?'femaleBirds':'maleBirds']++;
 progressTask(object);persist();closePanel();play('h_bird_hatched_popup.mp3');setTimeout(()=>playBirdVoice(object,.8),350);toast(`${gender.toUpperCase()} BIRD · VOICE ${voice} HATCHED!`)
}
function beginMove(o){placement={type:'move',object:o,pointerX:W/2,pointerY:H/2};toast('TAP A NEW LOCATION')}
function removeUser(o){save.objects=save.objects.filter(x=>x.id!==o.id);persist()}
function clearObstacle(o){if(save.coins<20)return toast('NOT ENOUGH COINS');save.coins-=20;worldObstacles=worldObstacles.filter(x=>x.id!==o.id);save.removed.push(o.id);persist();updateHud();play('abi_remove_item.mp3');toast('AREA CLEARED')}

function packNumber(pack){return parseInt(String(pack).match(/\d+/)?.[0]||'0')}
function themeNumber(theme){return parseInt(String(theme||'theme1').match(/\d+/)?.[0]||'1')}
function visualThemeNumber(theme){const n=themeNumber(theme);return n<=8?n:n<=15?n-8:n===16?9:n}
const LEVEL_THEMES={
 1:{sky:'#94cede',ground:'#0a1339'},2:{sky:'#c1e7ef',ground:'#0a130f'},3:{sky:'#efd673',ground:'#2f170e'},
 4:{sky:'#90cded',ground:'#1c120c'},5:{sky:'#f1e28c',ground:'#442702'},6:{sky:'#4a5a2c',ground:'#181c0f'},
 7:{sky:'#07152b',ground:'#112245'},8:{sky:'#f9f8eb',ground:'#d9eef0'},9:{sky:'#085268',ground:'#332222'},
 17:{sky:'#101018',ground:'#111100'},18:{sky:'#63d6f4',ground:'#550000'}
};
function themeSpriteNames(theme){
 const visual=visualThemeNumber(theme);
 if(visual===17)return{sky:'THEME_CAVE_PARALLAX_1',middle:['THEME_BG_1'],front:'THEME_CAVE_FG_1',ground:'THEME_GROUND_TEXTURE_CAVE'};
 if(visual===18)return{sky:'BIRTHDAY_SKY',middle:['BIRTHDAY_MIDGROUND_1','BIRTHDAY_MIDGROUND_2','BIRTHDAY_MIDGROUND_3'],front:'BIRTHDAY_GROUND',ground:'THEME_GROUND_TEXTURE_BIRTHDAY'};
 if(visual===9)return{sky:'BACKGROUND_10_LAYER_1',middle:['BACKGROUND_10_LAYER_4'],items:'BACKGROUND_10_LAYER_2_ITEM_',front:'FOREGROUND_10_LAYER_1',ground:'THEME_GROUND_TEXTURE_10'};
 return{sky:`BACKGROUND_${visual}_LAYER_1`,middle:[`BACKGROUND_${visual}_LAYER_2`,`BACKGROUND_${visual}_LAYER_3`],items:`BACKGROUND_${visual}_LAYER_2_ITEM_`,front:`FOREGROUND_${visual}_LAYER_2`,ground:`THEME_GROUND_TEXTURE_${visual}`};
}
function drawSpriteCover(name,x,y,width,height){
 const raw=sprites.raw(name);if(!raw)return false;
 const scale=Math.max(width/raw.s.w,height/raw.s.h),sw=width/scale,sh=height/scale,sx=raw.s.x+(raw.s.w-sw)/2,sy=raw.s.y+(raw.s.h-sh)/2;
 ctx.drawImage(raw.image,sx,sy,sw,sh,x,y,width,height);return true;
}
function drawParallaxStrip(name,S,y,scale=1,speed=.4){
 const raw=sprites.raw(name);if(!raw)return false;
 const width=raw.s.w*scale,height=raw.s.h*scale,offset=-((S.cameraX*speed)%width);
 for(let x=offset-width;x<W+width;x+=width)ctx.drawImage(raw.image,raw.s.x,raw.s.y,raw.s.w,raw.s.h,x,y,width,height);
 return true;
}
function drawParallaxItems(prefix,S,y,speed=.45){
 const names=Object.keys(registry.sprites).filter(name=>name.startsWith(prefix)).sort();
 if(!names.length)return;
 const period=Math.max(W*1.7,1100);
 names.forEach((name,index)=>{const raw=sprites.raw(name);if(!raw)return;const scale=1.15+(index%3)*.28,x=((index+1)*period/(names.length+1)-S.cameraX*speed)%period-W*.25;ctx.drawImage(raw.image,raw.s.x,raw.s.y,raw.s.w,raw.s.h,x,y-raw.s.h*scale-(index%2)*24,raw.s.w*scale,raw.s.h*scale)});
}
function renderLevelTheme(S){
 const visual=visualThemeNumber(S.level.theme),palette=LEVEL_THEMES[visual]||LEVEL_THEMES[1],names=themeSpriteNames(S.level.theme);
 ctx.fillStyle=palette.sky;ctx.fillRect(0,0,W,H);
 if(names.sky)drawSpriteCover(names.sky,0,0,W,S.groundY);
 names.middle?.forEach((name,index)=>drawParallaxStrip(name,S,S.groundY-(index+1)*95,1.7-index*.25,.18+index*.2));
 if(names.items)drawParallaxItems(names.items,S,S.groundY-18,.42);
 const ground=sprites.raw(names.ground);
 if(ground){const pattern=ctx.createPattern(ground.image,'repeat');if(pattern){ctx.save();ctx.translate(-(S.cameraX*.05%ground.s.w),0);ctx.fillStyle=pattern;ctx.fillRect(-ground.s.w,S.groundY,W+ground.s.w*2,H-S.groundY);ctx.restore()}}
 else{ctx.fillStyle=palette.ground;ctx.fillRect(0,S.groundY,W,H-S.groundY)}
 if(names.front)drawParallaxStrip(names.front,S,S.groundY-42,1.35,.82);
}
function levelSaveKey(level){return `${level.pack}/${level.id}`}
function orderedPackLevels(pack){return levelsData.levels.filter(level=>level.pack===pack).sort((a,b)=>(a.order??999999)-(b.order??999999)||a.id.localeCompare(b.id,undefined,{numeric:true}))}
function packIcon(pack){
 if(pack==='goldeneggs1')return'assets/images/level-menu/episodeg_icon.webp';
 const world=packNumber(pack),episode=world<=3?1:world<=5?2:world<=8?3:world<=11?4:world<=14?5:world<=17?6:7,suffix=episode===7?'7':String(episode).padStart(2,'0');
 return`assets/images/level-menu/ls_pack_thumb_${suffix}.webp`;
}
function levelIcon(pack){
 if(pack==='goldeneggs1')return'assets/images/level-menu/ls_level_bg_normal_open_8.webp';
 const world=packNumber(pack),index=world<=8?world:world<=11?world-8:world<=14?world-11:world<=17?world-14:4;
 return`assets/images/level-menu/ls_level_bg_normal_open_${index}.webp`;
}

async function showLevels(initialPack='pack1'){
 const birds=save.objects.filter(o=>o.type==='bird');
 $('#panelTitle').textContent='CHOOSE AN ORIGINAL LEVEL';
 const body=$('#panelBody');
 if(!levelsData){
  body.innerHTML='<p>Loading all 325 original IPA levels…</p>';
  openPanel();
  await levelsPromise;
 }
 if(!birds.length){
  body.innerHTML='<p><b>Hatch at least one bird first.</b> Your custom Hatchery birds become the slingshot team.</p>';
  return openPanel();
 }
 const packs=[...new Set(levelsData.levels.map(level=>level.pack))].sort((a,b)=>{
  if(a==='goldeneggs1')return 1;
  if(b==='goldeneggs1')return -1;
  return packNumber(a)-packNumber(b);
 });
 body.innerHTML='<div class="pack-picker" aria-label="Original level packs"></div><select id="packSelect" class="sr-only" aria-label="World"></select><h3 class="selected-pack-title"></h3><p class="level-count"></p><div class="level-grid"></div>';
 const select=$('#packSelect',body),picker=$('.pack-picker',body);
 for(const pack of packs){
  const count=levelsData.levels.filter(level=>level.pack===pack).length,option=document.createElement('option'),button=document.createElement('button');
  option.value=pack;option.textContent=pack==='goldeneggs1'?`GOLDEN EGGS · ${count} LEVELS`:`WORLD ${packNumber(pack)} · ${count} LEVELS`;select.append(option);
  button.type='button';button.className='pack-button';button.dataset.pack=pack;button.innerHTML=`<img src="${packIcon(pack)}" alt=""><b>${pack==='goldeneggs1'?'GOLDEN EGGS':`WORLD ${packNumber(pack)}`}</b><small>${count} LEVELS</small>`;
  button.onclick=()=>{select.value=pack;play('menu_select.mp3');render();button.scrollIntoView({behavior:'smooth',block:'nearest',inline:'center'})};picker.append(button);
 }
 select.value=packs.includes(initialPack)?initialPack:packs[0];
 const render=()=>{
  const levels=orderedPackLevels(select.value),grid=$('.level-grid',body),world=packNumber(select.value);
  $$('.pack-button',picker).forEach(button=>button.classList.toggle('active',button.dataset.pack===select.value));
  $('.selected-pack-title',body).textContent=select.value==='goldeneggs1'?'GOLDEN EGGS':`WORLD ${world}`;
  const objectCount=levels.reduce((total,level)=>total+Object.keys(level.world).length,0),jointCount=levels.reduce((total,level)=>total+Object.keys(level.joints||{}).length,0);
  $('.level-count',body).textContent=`${levels.length} distinct IPA layouts · ${objectCount.toLocaleString()} original objects · ${jointCount.toLocaleString()} joints`;
  grid.innerHTML='';
  levels.forEach((level,index)=>{
   const button=document.createElement('button'),key=levelSaveKey(level),stars=save.scores[key]||0;
   button.className='level-button';button.title=`Original file: ${level.pack}/${level.id}.lua`;
   button.innerHTML=`<span class="level-icon"><img src="${levelIcon(level.pack)}" alt=""><strong>${level.pack==='goldeneggs1'?'GE':index+1}</strong></span><small>${level.id}</small><span class="level-stars">${'★'.repeat(stars)}${'☆'.repeat(3-stars)}</span>`;
   button.onclick=()=>startLevel(level,index+1);grid.append(button);
  });
 };
 select.onchange=render;
 render();
 openPanel();
}

function originalBirdDefinition(bird,byColor=false){
 const custom=getBird(bird),key=String(byColor?(custom.color||custom.shape):(custom.shape||'RED')).toUpperCase();
 return data.birdDefinitions.definitionsMapping[key]||'RedBird';
}
function physicsValue(def,material,key,fallback){return def?.[key]??material?.[key]??fallback}
function damageSpriteFor(body){
 const plugin=body.plugin,sets=plugin.definition?.damageSprites;
 if(!sets||!plugin.maxHealth)return plugin.render.sprite;
 const percent=plugin.health/plugin.maxHealth*100;
 for(const item of Object.values(sets))if(item.min<percent&&item.max>=percent)return item.sprite;
 return plugin.render.sprite;
}
function makeLevelBody(S,object,definition,meta){
 const M=Matter,material=physicsData.materials?.[definition.material]||{},rawDensity=physicsValue(definition,material,'density',1),isStatic=rawDensity===0;
 const sizeFactor=isStatic?1:.92,pixelScale=1/20;
 const width=(definition.width??meta.w*pixelScale*sizeFactor)*S.unit;
 const height=(definition.height??meta.h*pixelScale*sizeFactor)*S.unit;
 const x=S.offsetX+object.x*S.unit,y=S.groundY+(object.y-S.groundWorldY)*S.unit;
 const options={
  isStatic,
  isSensor:definition.collision===false,
  restitution:physicsValue(definition,material,'restitution',.1),
  friction:physicsValue(definition,material,'friction',.7),
  frictionStatic:Math.max(.5,physicsValue(definition,material,'friction',.7)),
  density:Math.max(.00005,rawDensity*.001),
  angle:object.angle||0,
  sleepThreshold:45
 };
 let body;
 if(definition.type==='circle'){
  const radius=(definition.radius??meta.w*.5*pixelScale*sizeFactor)*S.unit;
  body=M.Bodies.circle(x,y,Math.max(2,radius),options);
 }else if(definition.type==='polygon'&&Array.isArray(definition.vertices)&&definition.vertices.length>=3){
  const vertices=definition.vertices.map(vertex=>({x:(vertex.x-.5)*width,y:(vertex.y-.5)*height}));
  body=M.Bodies.fromVertices(x,y,[vertices],options,true);
  M.Body.setAngle(body,object.angle||0);
 }else body=M.Bodies.rectangle(x,y,Math.max(2,width),Math.max(2,height),options);
 const isGoal=definition.levelGoal===true;
 body.label=isGoal?'pig':'block';
 body.plugin.render={sprite:definition.sprite,definition:object.definition};
 body.plugin.definition=definition;
 body.plugin.object=object;
 body.plugin.material=definition.material;
 body.plugin.health=physicsValue(definition,material,'strength',40);
 body.plugin.maxHealth=body.plugin.health;
 body.plugin.defence=physicsValue(definition,material,'defence',5);
 body.plugin.destructible=body.plugin.defence<100000&&definition.collision!==false;
 body.plugin.destroyed=false;
 body.plugin.preVelocity={x:0,y:0};
 return body;
}
function localConstraintPoint(S,joint,side,body){
 const x=Number(joint[`x${side}`])||0,y=Number(joint[`y${side}`])||0;
 if(joint.coordType===2)return{x:x*S.unit,y:y*S.unit};
 const worldX=S.offsetX+x*S.unit,worldY=S.groundY+(y-S.groundWorldY)*S.unit,dx=worldX-body.position.x,dy=worldY-body.position.y,c=Math.cos(-body.angle),s=Math.sin(-body.angle);
 return{x:dx*c-dy*s,y:dx*s+dy*c};
}
function addLevelJoints(S){
 const M=Matter;
 for(const joint of Object.values(S.level.joints||{})){
  const bodyA=S.bodyByName.get(joint.end1),bodyB=S.bodyByName.get(joint.end2);
  if(!bodyA||!bodyB)continue;
  // Two malformed editor leftovers use 500-unit local anchors. The native game
  // cannot use those meaningfully either; ignore only those corrupt records.
  if(joint.coordType===2&&Math.max(Math.abs(joint.x1||0),Math.abs(joint.y1||0),Math.abs(joint.x2||0),Math.abs(joint.y2||0))>50)continue;
  const constraint=M.Constraint.create({
   bodyA,bodyB,pointA:localConstraintPoint(S,joint,1,bodyA),pointB:localConstraintPoint(S,joint,2,bodyB),
   stiffness:(joint.type===1&&joint.frequency)?0.1:0.95,damping:joint.dampingRatio??(joint.type===1?0.08:0.02)
  });
  constraint.plugin.nativeJoint=joint;
  if(joint.type===5&&joint.destroyTimer)constraint.plugin.destroyAt=performance.now()+joint.destroyTimer*1000;
  S.constraints.push(constraint);M.World.add(S.world,constraint);
 }
}
function updateBodyDamageSprite(body){
 const name=damageSpriteFor(body);
 if(name&&sprites.meta(name))body.plugin.render.sprite=name;
}
function explosionAt(S,source,params,soundName){
 const M=Matter,radius=(params.explosionRadius||10)*S.unit,damageRadius=(params.explosionDamageRadius||5)*S.unit;
 for(const target of M.Composite.allBodies(S.world)){
  if(target===source||target.plugin?.destroyed||!target.plugin?.definition)continue;
  const dx=target.position.x-source.position.x,dy=target.position.y-source.position.y,d=Math.max(1,Math.hypot(dx,dy));
  if(d<radius&&!target.isStatic){
   const strength=(params.explosionForce||20000)/40000*.035*(1-d/radius);
   M.Body.applyForce(target,target.position,{x:dx/d*strength,y:dy/d*strength});
  }
  if(d<damageRadius&&target.plugin.destructible){
   const worldDistance=Math.max(.6,d/S.unit),damage=(params.explosionDamage||200)/worldDistance;
   if(damage>target.plugin.defence)damageLevelBody(S,target,damage,source);
  }
 }
 if(soundName)play(soundName,.8);
}
function destroyLevelBody(S,body,award=true){
 if(!body||body.plugin?.destroyed)return;
 body.plugin.destroyed=true;
 const definition=body.plugin.definition;
 if(definition?.specialty==='BOMB')explosionAt(S,body,definition,'h_specialty_explosion.mp3');
 if(award){
  S.score+=body.label==='pig'?5000:(definition?.destroyedScoreInc||500);
  play(materialSound(body,'destroyed'),.62);
 }
 for(const constraint of [...(S.constraints||[])])if(constraint.bodyA===body||constraint.bodyB===body){Matter.World.remove(S.world,constraint);S.constraints=S.constraints.filter(item=>item!==constraint)}
 Matter.World.remove(S.world,body);
}
function damageLevelBody(S,body,amount,attacker){
 if(!body?.plugin?.destructible||body.plugin.destroyed||!Number.isFinite(amount)||amount<=0)return;
 body.plugin.health-=amount;
 if(attacker?.label==='playerBird')S.score+=Math.max(0,Math.round(amount*10));
 const now=performance.now();if(now-(body.plugin.lastDamageSound||0)>180){body.plugin.lastDamageSound=now;play(materialSound(body,'damage'),clamp(.28+amount/40,.3,.72))}
 updateBodyDamageSprite(body);
 if(body.plugin.health<=0)destroyLevelBody(S,body,true);
}
function collisionSpeed(pair){
 const a=pair.bodyA.plugin?.preVelocity||pair.bodyA.velocity,b=pair.bodyB.plugin?.preVelocity||pair.bodyB.velocity,n=pair.collision.normal;
 return Math.abs((b.x-a.x)*n.x+(b.y-a.y)*n.y);
}
function birdDamageMultiplier(birdBody,target){
 const group=birdBody.plugin?.damageFactors||'DefaultDamageFactors';
 return physicsData.damageFactors?.[group]?.damageMultiplier?.[target.plugin?.material]??1;
}
function handleLevelCollisions(S,event){
 const now=performance.now();
 for(const pair of event.pairs){
  const a=pair.bodyA,b=pair.bodyB;
  for(const [bird,other] of [[a,b],[b,a]])if(bird.label==='playerBird'&&other.label!=='playerBird'){
   if(!bird.plugin.hasCollided)playRandom(birdSoundPack(bird.plugin.source).collision,.65);bird.plugin.hasCollided=true;
   if(bird.plugin.bombling&&!bird.plugin.exploded){
    bird.plugin.exploded=true;
    explosionAt(S,bird,{explosionForce:20000,explosionRadius:10,explosionDamage:200,explosionDamageRadius:3},'h_specialty_explosion.mp3');
    if(bird!==S.current)Matter.World.remove(S.world,bird);
   }
  }
  if(now<S.damageArmedAt||S.shotsFired===0)continue;
  const speed=collisionSpeed(pair);
  if(speed<.75)continue;
  if(speed>1.8&&now-(S.lastCollisionSound||0)>90){const sounding=a.label==='ground'?b:a;S.lastCollisionSound=now;play(materialSound(sounding,'collision'),clamp(speed/12,.2,.62))}
  const hit=(target,attacker)=>{
   if(!['pig','block'].includes(target.label)||!target.plugin?.destructible)return;
   const impactBody=attacker.isStatic?target:attacker,mass=Math.sqrt(clamp(Number.isFinite(impactBody.mass)?impactBody.mass:1,.1,25));
   // KA3D damage is impulse-based. Include body mass so a falling beam or
   // stone can crush a pig instead of merely nudging it forever.
   const force=speed*(1.3+mass*1.15),defence=target.plugin.defence||0;
   if(force<=defence)return;
   const factor=attacker.label==='playerBird'?birdDamageMultiplier(attacker,target):1;
   damageLevelBody(S,target,(force-defence)*factor,attacker);
  };
  hit(a,b);hit(b,a);
 }
}

function handleActiveCrushing(S,event){
 if(S.shotsFired===0)return;const now=performance.now();
 for(const pair of event.pairs){
  const pig=pair.bodyA.label==='pig'?pair.bodyA:pair.bodyB.label==='pig'?pair.bodyB:null,block=pair.bodyA.label==='block'?pair.bodyA:pair.bodyB.label==='block'?pair.bodyB:null;
  if(!pig||!block||pig.plugin.destroyed||block.plugin.destroyed||now-(pig.plugin.lastCrushAt||0)<140)continue;
  const radius=Math.max(block.bounds.max.x-block.bounds.min.x,block.bounds.max.y-block.bounds.min.y)*.25,motion=block.speed+Math.abs(block.angularVelocity)*radius;
  if(motion<.18)continue;
  const mass=Math.sqrt(clamp(Number.isFinite(block.mass)?block.mass:1,.1,25)),force=motion*(1.35+mass*1.2),defence=pig.plugin.defence||0;
  if(force>defence){pig.plugin.lastCrushAt=now;damageLevelBody(S,pig,(force-defence)*.8,block)}
 }
}

function startLevel(level,number){
 const allBirds=save.objects.filter(object=>object.type==='bird');
 if(!allBirds.length)return toast('HATCH A BIRD FIRST');
 closePanel();
 $('#hud').hidden=true;
 screen='slingshot';
 setLevelAmbience(level.theme);
 play('level start military a1.mp3');
 const M=window.Matter,engine=M.Engine.create({enableSleeping:true,gravity:{x:0,y:1,scale:.001}}),world=engine.world,entries=Object.values(level.world);
 engine.positionIterations=10;engine.velocityIterations=8;engine.constraintIterations=4;
 const authoredBirds=entries.filter(object=>physicsData.blocks?.[object.definition]?.controllable).sort((a,b)=>(a.startNumber||99)-(b.startNumber||99));
 // Every hatched bird is usable. The original level birds only provide the
 // sling position; they no longer discard the rest of the player's flock.
 const roster=[...allBirds];
 const groundObject=entries.find(object=>object.definition==='Ground'),slingObject=authoredBirds[0]||{x:-12,y:-1},groundWorldY=groundObject?.y??5;
 const xs=entries.filter(object=>Number.isFinite(object.x)&&object.definition!=='Ground').map(object=>object.x),minX=Math.min(slingObject.x-4,...xs),maxX=Math.max(slingObject.x+55,...xs);
 const unit=clamp(W*.76/Math.max(35,maxX-minX),5,16),offsetX=W*.14-slingObject.x*unit,renderScale=unit/20,groundY=H*.82,slingX=offsetX+slingObject.x*unit,slingY=groundY+(slingObject.y-groundWorldY)*unit;
 // KA3D uses 20 source pixels per physics unit. Convert a 9.81-unit gravity
 // into Matter's per-frame scale instead of using Matter's 10x-heavier default.
 engine.gravity.scale=.00000981*unit;
 const now=performance.now(),maxCameraX=Math.max(0,offsetX+maxX*unit-W*.55),physicsToWorld=level.physicsToWorld||20;
 const cameraPosition=data=>{const camera=data?.ipad||data;if(!Number.isFinite(camera?.px))return null;return clamp(offsetX+camera.px/physicsToWorld*unit-W/2,0,maxCameraX)};
 const castleCameraX=cameraPosition(level.camera?.castle)??maxCameraX,birdCameraX=cameraPosition(level.camera?.bird)??0;
 slingshot={
  level,number,engine,world,bodies:[],bodyByName:new Map(),constraints:[],roster,queueIndex:0,current:null,
  sling:{x:slingX,y:slingY},pullRadius:5.4*unit,groundY,groundWorldY,offsetX,unit,renderScale,physicsToWorld,
  cameraX:castleCameraX,castleCameraX,birdCameraX,maxCameraX,cameraDragging:false,dragging:false,
  intro:true,introStartedAt:now,introSweepAt:now+650,introEndsAt:now+2450,
  launchedAt:0,special:false,score:0,complete:false,failed:false,resultShown:false,shotsFired:0,
  initialGoalCount:0,goalsClearedAt:0,damageArmedAt:now+1250,physicsStartsAt:now+250,lastMovingAt:now,
  unusedBonus:0
 };
 const left=offsetX+minX*unit-W,right=offsetX+maxX*unit+W;
 M.World.add(world,M.Bodies.rectangle((left+right)/2,groundY+35,right-left,70,{isStatic:true,friction:1,label:'ground'}));
 for(const object of entries){
  const definition=physicsData.blocks?.[object.definition];
  if(!definition||definition.controllable||object.definition==='Ground')continue;
  const meta=sprites.meta(definition.sprite);
  if(!meta)continue;
  const body=makeLevelBody(slingshot,object,definition,meta);
  if(body.label==='pig')slingshot.initialGoalCount++;
  slingshot.bodies.push(body);slingshot.bodyByName.set(object.name,body);
  M.World.add(world,body);
 }
 addLevelJoints(slingshot);
 const activeLevel=slingshot;
 M.Events.on(engine,'beforeUpdate',()=>{
  for(const body of M.Composite.allBodies(world))body.plugin.preVelocity={x:body.velocity.x,y:body.velocity.y};
 });
 M.Events.on(engine,'collisionStart',event=>handleLevelCollisions(activeLevel,event));M.Events.on(engine,'collisionActive',event=>handleActiveCrushing(activeLevel,event));
 loadNextBird();
 if(!save.tutorial.slingShown){save.tutorial.slingShown=true;persist();setTimeout(()=>{if(slingshot===activeLevel)toast('DRAG BACK AND RELEASE · TAP IN FLIGHT FOR SPECIALTY')},2600)}
}
function makePlayerBody(S,source,x,y,radius,velocity,extra={}){
 const M=Matter,shapeDefinition=physicsData.blocks?.[originalBirdDefinition(source,false)]||physicsData.blocks.RedBird,colorDefinition=physicsData.blocks?.[originalBirdDefinition(source,true)]||shapeDefinition;
 const waiting=!velocity,body=M.Bodies.circle(x,y,radius??Math.max(7,(shapeDefinition.radius||.85)*S.unit),{
  restitution:shapeDefinition.restitution??.35,friction:shapeDefinition.friction??.3,
  density:Math.max(.0001,(shapeDefinition.density||6)*.001),frictionAir:.008,sleepThreshold:60
 });
 // Matter bodies constructed as static lose their original finite mass and turn
 // into NaN when released. Build dynamically, then park the waiting bird.
 if(waiting)M.Body.setStatic(body,true);
 body.label='playerBird';
 body.plugin.source=source;
 body.plugin.definition=shapeDefinition;
 body.plugin.material=shapeDefinition.material;
 body.plugin.damageFactors=colorDefinition.damageFactors||'DefaultDamageFactors';
 body.plugin.hasCollided=false;
 body.plugin.bombling=!!extra.bombling;
 body.plugin.renderSprite=extra.renderSprite;
 body.plugin.preVelocity={x:velocity?.x||0,y:velocity?.y||0};
 if(velocity)M.Body.setVelocity(body,velocity);
 M.World.add(S.world,body);
 return body;
}
function loadNextBird(){
 const S=slingshot;
 if(!S||S.complete)return;
 if(S.queueIndex>=S.roster.length){
  if(!S.current){S.failed=true;S.failedAt=performance.now()}
  return;
 }
 const source=S.roster[S.queueIndex++];
 S.current=makePlayerBody(S,source,S.sling.x,S.sling.y,null,null);
 S.dragging=false;S.special=false;S.launchedAt=0;playRandom(['bird next military a1.mp3','bird next military a2.mp3','bird next military a3.mp3'],.45);setTimeout(()=>{if(slingshot===S&&S.current?.plugin.source===source)playBirdVoice(source,.48)},180);
}
function launchBird(x,y){
 const S=slingshot,M=Matter,b=S?.current;
 if(!b||!b.isStatic)return;
 let dx=x-S.sling.x,dy=y-S.sling.y,d=Math.hypot(dx,dy);
 if(d>S.pullRadius){dx*=S.pullRadius/d;dy*=S.pullRadius/d;d=S.pullRadius}
 M.Body.setPosition(b,{x:S.sling.x+dx,y:S.sling.y+dy});
 M.Body.setStatic(b,false);M.Sleeping.set(b,false);
 const fraction=clamp(d/S.pullRadius,0,1),speed=.77*S.unit*fraction;
 M.Body.setVelocity(b,{x:d?-dx/d*speed:0,y:d?-dy/d*speed:0});
 S.dragging=false;S.launchedAt=performance.now();S.shotsFired++;
 playRandom(['bird shot-a1.mp3','bird shot-a2.mp3','bird shot-a3.mp3'],.65);play(birdSoundPack(b.plugin.source).launch,.72);setTimeout(()=>playBirdVoice(b.plugin.source,.5),90);
 const bird=getBird(b.plugin.source);
 if(bird.shape==='BLACK'&&bird.color==='YELLOW')play(Math.random()<.5?'h_specialty_yell.mp3':'h_specialty_yell2.mp3');
}
function spawnSplitBird(S,source,base,angle,bombling=false){
 const speed=base.speed,velocity={x:base.velocity.x*Math.cos(angle)-base.velocity.y*Math.sin(angle),y:base.velocity.x*Math.sin(angle)+base.velocity.y*Math.cos(angle)};
 if(speed<.1){velocity.x=Math.cos(angle)*4;velocity.y=Math.sin(angle)*4}
 const body=makePlayerBody(S,source,base.position.x,base.position.y,Math.max(6,base.circleRadius*.72),velocity,{bombling});
 S.bodies.push(body);return body;
}
function removeCurrentForSpecial(S,body,replacement){
 Matter.World.remove(S.world,body);
 if(S.current===body)S.current=replacement||null;
}
function activateSpecial(){
 const S=slingshot,b=S?.current;
 if(!b||b.isStatic||S.special)return;
 S.special=true;
 const bird=getBird(b.plugin.source),shape=String(bird.shape||'RED').toUpperCase(),color=String(bird.color||shape).toUpperCase();
 if(shape==='BLUE'&&(color==='BLACK'||color==='YELLOW')){
  const bombling=color==='BLACK';
  spawnSplitBird(S,b.plugin.source,b,-.28,bombling);spawnSplitBird(S,b.plugin.source,b,.28,bombling);b.plugin.bombling=bombling;
  if(color==='YELLOW')Matter.Body.setVelocity(b,{x:b.velocity.x*1.35,y:b.velocity.y*1.35});
  play(color==='YELLOW'?'h_specialty_boost.mp3':'h_specialty_divide.mp3');
 }else if(shape==='YELLOW'&&(color==='BLUE'||color==='BLACK')){
  Matter.Body.setVelocity(b,{x:b.velocity.x*1.75,y:b.velocity.y*1.75});b.plugin.bombling=color==='BLACK';play('h_specialty_boost.mp3');
 }else if(shape==='BLACK'&&color==='BLUE'){
  explosionAt(S,b,{explosionForce:40000,explosionRadius:20,explosionDamage:400,explosionDamageRadius:5},'h_specialty_explosion.mp3');
  const clones=[-.7,0,.7].map(angle=>spawnSplitBird(S,b.plugin.source,b,angle,false));
  removeCurrentForSpecial(S,b,clones[1]);
  play('h_specialty_divide.mp3');
 }else if(shape==='BLACK'&&color==='YELLOW'){
  explosionAt(S,b,{explosionForce:10000,explosionRadius:10,explosionDamage:100,explosionDamageRadius:5},'h_specialty_explosion2.mp3');
  removeCurrentForSpecial(S,b,null);
  setTimeout(()=>{if(slingshot===S&&!S.complete)loadNextBird()},500);
 }else if(shape==='BLACK'&&color==='WHITE'){
  for(let i=0;i<5;i++){
   const angle=i/5*Math.PI*2,egg=makePlayerBody(S,b.plugin.source,b.position.x+Math.cos(angle)*3*S.unit,b.position.y+Math.sin(angle)*3*S.unit,Math.max(6,b.circleRadius*.55),{x:Math.cos(angle)*8,y:Math.sin(angle)*8},{bombling:true,renderSprite:'DROPPABLE_EGG'});
   S.bodies.push(egg);
  }
  explosionAt(S,b,{explosionForce:20000,explosionRadius:15,explosionDamage:200,explosionDamageRadius:5},'h_specialty_egg.mp3');
  removeCurrentForSpecial(S,b,null);setTimeout(()=>{if(slingshot===S&&!S.complete)loadNextBird()},600);
 }else if(shape==='WHITE'&&color==='BLACK'){
  const egg=makePlayerBody(S,b.plugin.source,b.position.x,b.position.y+b.circleRadius*2,Math.max(6,b.circleRadius*.6),{x:0,y:10},{bombling:true,renderSprite:'DROPPABLE_EGG'});
  S.bodies.push(egg);Matter.Body.setVelocity(b,{x:b.velocity.x+2,y:b.velocity.y-9});play('h_specialty_egg.mp3');
 }else play('bird misc a1.mp3');
}
function finishLevel(S){
 if(S.complete)return;
 S.complete=true;
 const unused=Math.max(0,S.roster.length-S.shotsFired);
 S.unusedBonus=unused*10000;S.score+=S.unusedBonus;
 const limits=S.level.stars||{},stars=S.score>=(limits.goldScore??Infinity)?3:S.score>=(limits.silverScore??Infinity)?2:1,key=levelSaveKey(S.level);
 save.scores[key]=Math.max(save.scores[key]||0,stars);
 save.highScores=save.highScores||{};save.highScores[key]=Math.max(save.highScores[key]||0,S.score);
 persist();
 setTimeout(()=>{if(slingshot===S&&S.complete)showLevelResult(true,stars)},900);
}
function updateSlingshot(dt){
 const S=slingshot;
 if(!S)return;
 const now=performance.now();
 for(const constraint of [...S.constraints]){
  if(constraint.plugin.destroyAt&&now>=constraint.plugin.destroyAt){Matter.World.remove(S.world,constraint);S.constraints=S.constraints.filter(item=>item!==constraint);continue}
  const native=constraint.plugin.nativeJoint;if(native?.motor&&constraint.bodyB&&!constraint.bodyB.isStatic)Matter.Body.setAngularVelocity(constraint.bodyB,(native.motorSpeed||0)/60);
 }
 if(now>=S.physicsStartsAt)Matter.Engine.update(S.engine,dt*1000);
 const bodies=Matter.Composite.allBodies(S.world);
 for(const body of bodies){
  if((body.label==='pig'||body.label==='block')&&!body.isStatic&&body.speed>.4)S.lastMovingAt=now;
  if(S.shotsFired>0&&(body.label==='pig'||body.label==='block')&&!body.plugin?.destroyed&&(body.position.y>H+500||body.position.x<-W*2||body.position.x>S.maxCameraX+W*3))destroyLevelBody(S,body,true);
 }
 const goals=Matter.Composite.allBodies(S.world).filter(body=>body.label==='pig'&&!body.plugin?.destroyed);
 if(!goals.length&&S.shotsFired>0&&!S.complete){
  if(!S.goalsClearedAt)S.goalsClearedAt=now;
  const stable=S.level.doNotWaitForMovingObjects||now-S.lastMovingAt>750;
  if((stable&&now-S.goalsClearedAt>900)||now-S.goalsClearedAt>5000)finishLevel(S);
 }else if(goals.length)S.goalsClearedAt=0;
 const b=S.current;
 if(S.intro){
  if(now>=S.introEndsAt){S.intro=false;S.cameraX=S.birdCameraX}
  else if(now>=S.introSweepAt){const t=clamp((now-S.introSweepAt)/(S.introEndsAt-S.introSweepAt),0,1),ease=1-Math.pow(1-t,3);S.cameraX=S.castleCameraX+(S.birdCameraX-S.castleCameraX)*ease}
 }else if(b&&!b.isStatic&&!S.cameraDragging){
  const target=clamp(b.position.x-W*.34,0,S.maxCameraX);
  S.cameraX+=(target-S.cameraX)*Math.min(1,dt*4);
 }else if(b?.isStatic&&!S.cameraDragging)S.cameraX+=(S.birdCameraX-S.cameraX)*Math.min(1,dt*4);
 if(b&&!b.isStatic&&S.launchedAt&&Matter.Composite.get(S.world,b.id,'body')){
  const age=(now-S.launchedAt)/1000;
  if(age>12||(age>2&&b.speed<.22)||b.position.y>H+400){
   Matter.World.remove(S.world,b);S.current=null;
   if(!S.complete)setTimeout(()=>{if(slingshot===S&&!S.current&&!S.complete)loadNextBird()},650);
  }
 }else if(b&&!Matter.Composite.get(S.world,b.id,'body'))S.current=null;
 if(S.failed&&!S.complete&&!S.resultShown&&now-(S.failedAt||now)>900){
  S.resultShown=true;showLevelResult(false,0);
 }
}
function renderSlingshot(){
 const S=slingshot;
 renderLevelTheme(S);
 ctx.save();ctx.translate(-S.cameraX,0);
 const waiting=S.roster.slice(S.queueIndex),visibleWaiting=waiting.slice(0,12);visibleWaiting.forEach((source,index)=>drawBird(getBird(source),S.sling.x-(index+1)*Math.max(24,38*S.renderScale),S.sling.y+24*S.renderScale,.25*S.renderScale,time,ctx));
 sprites.draw('SLING_SHOT_01_BACK',S.sling.x,S.sling.y+30*S.renderScale,S.renderScale,0,1,ctx);
 if(S.current?.isStatic){ctx.strokeStyle='#4b2116';ctx.lineWidth=Math.max(4,8*S.renderScale);ctx.beginPath();ctx.moveTo(S.sling.x+10*S.renderScale,S.sling.y+5*S.renderScale);ctx.lineTo(S.current.position.x,S.current.position.y);ctx.stroke()}
 for(const body of Matter.Composite.allBodies(S.world)){
  if(body.label==='ground'||body.plugin?.destroyed)continue;
  ctx.save();ctx.translate(body.position.x,body.position.y);ctx.rotate(body.angle);
  if(body.label==='playerBird'){
   if(body.plugin.renderSprite)sprites.draw(body.plugin.renderSprite,0,0,S.renderScale,0,1,ctx);
   else drawBird(getBird(body.plugin.source),0,0,.35*S.renderScale,time,ctx);
  }else{
   const name=body.plugin.render?.sprite;
   if(name)sprites.draw(name,0,0,S.renderScale,0,1,ctx);
  }
  ctx.restore();
 }
 if(S.current?.isStatic){ctx.strokeStyle='#32150f';ctx.lineWidth=Math.max(4,7*S.renderScale);ctx.beginPath();ctx.moveTo(S.current.position.x,S.current.position.y);ctx.lineTo(S.sling.x-8*S.renderScale,S.sling.y+7*S.renderScale);ctx.stroke()}
 sprites.draw('SLING_SHOT_01_FRONT',S.sling.x,S.sling.y+30*S.renderScale,S.renderScale,0,1,ctx);
 if(S.current?.isStatic){
  ctx.strokeStyle='#fff8';ctx.lineWidth=3;ctx.setLineDash([6,8]);ctx.beginPath();ctx.moveTo(S.sling.x,S.sling.y);ctx.lineTo(S.sling.x+S.unit*18,S.sling.y-S.unit*8);ctx.stroke();ctx.setLineDash([]);
 }
 ctx.restore();
 if(S.intro){ctx.fillStyle='#063e56cc';ctx.fillRect(W/2-105,H-55,210,36);ctx.fillStyle='#fff';ctx.font='900 15px Arial';ctx.textAlign='center';ctx.fillText('TAP TO SKIP CAMERA',W/2,H-31);ctx.textAlign='start'}
 const world=S.level.pack==='goldeneggs1'?'GOLDEN EGG':`WORLD ${packNumber(S.level.pack)}-${S.number}`;
 ctx.textAlign='start';ctx.fillStyle='#fff';ctx.strokeStyle='#173845';ctx.lineWidth=5;ctx.font='900 23px Arial';ctx.strokeText(`${world}  ·  ${S.level.id}  ·  SCORE ${S.score}  ·  BIRDS ${Math.max(0,S.roster.length-S.shotsFired)}`,90,43);ctx.fillText(`${world}  ·  ${S.level.id}  ·  SCORE ${S.score}  ·  BIRDS ${Math.max(0,S.roster.length-S.shotsFired)}`,90,43);
 ctx.beginPath();ctx.arc(42,42,29,0,Math.PI*2);ctx.fillStyle='#078da9';ctx.fill();ctx.strokeStyle='#fff';ctx.lineWidth=4;ctx.stroke();ctx.fillStyle='#fff';ctx.font='900 26px Arial';ctx.fillText('‹',34,50);
}
function showLevelResult(win,stars){
 const S=slingshot;
 if(!S||$('#panel').hidden===false)return;
 S.resultShown=true;
 const levels=orderedPackLevels(S.level.pack),index=levels.findIndex(level=>level.id===S.level.id),next=levels[index+1];
 $('#panelTitle').textContent=win?'LEVEL COMPLETE!':'TRY AGAIN';
 $('#panelBody').innerHTML=`<div style="text-align:center;font-size:2rem;color:#f4a000">${'★'.repeat(stars)}${'☆'.repeat(3-stars)}</div><p style="text-align:center"><b>${S.level.pack==='goldeneggs1'?'GOLDEN EGG':`WORLD ${packNumber(S.level.pack)}-${S.number}`}</b><br>Original layout: ${S.level.id}<br>Score: ${S.score}${S.unusedBonus?` · Unused birds: +${S.unusedBonus}`:''}</p><div style="text-align:center"><button class="action" id="retryLevel">RETRY</button>${win&&next?'<button class="action" id="nextLevel">NEXT LEVEL</button>':''}<button class="action" id="backIsland">HATCHERY</button></div>`;
 openPanel();
 $('#retryLevel').onclick=()=>startLevel(S.level,S.number);
 if(win&&next)$('#nextLevel').onclick=()=>startLevel(next,index+2);
 $('#backIsland').onclick=exitLevel;
 play(win?'level_complete.mp3':'level failed piglets a1.mp3');
}
function exitLevel(){closePanel();slingshot=null;screen='world';$('#hud').hidden=false;setMusic('ambient')}
function updateHud(){$('#stars').textContent=save.stars;$('#coins').textContent=save.coins;$('#soundButton').textContent=soundOn?'♫':'×'}

const TUTORIAL_STEPS=[
 {title:'WELCOME TO HATCHERY ISLAND',icon:'🏝️',text:'Drag the island with one finger or the mouse. Pinch or use the zoom buttons to see the full 70×70 Hatchery map.'},
 {title:'BUILD A BIRD',icon:'🥚',text:'Select an empty nest, buy an egg, wait for its timer or use Hurry, then choose CHOOSE & HATCH.'},
 {title:'GENDER AND VOICE',icon:'♂ ♀ 🔊',text:'Choose exactly one gender and one of the 12 original Hatchery voice packs. Only that selected gender advances its achievement.'},
 {title:'YOUR WHOLE FLOCK',icon:'🐦',text:'Every bird in MY SLINGSHOT FLOCK is queued for level play. Waiting birds stand behind the sling and enter one after another.'},
 {title:'ORIGINAL LEVEL PACKS',icon:'🎯',text:'Open PLAY, swipe through all 18 world packs plus Golden Eggs, then choose any of the 325 distinct IPA levels.'},
 {title:'SLINGSHOT AND PHYSICS',icon:'🪃',text:'Drag the bird backward and release. Falling wood, stone and glass can crush pigs. Tap a flying bird for its specialty; drag after the specialty to move the camera.'}
];
function showTutorial(step=0){
 step=clamp(step,0,TUTORIAL_STEPS.length-1);const item=TUTORIAL_STEPS[step];$('#panelTitle').textContent=`TUTORIAL ${step+1} / ${TUTORIAL_STEPS.length}`;const body=$('#panelBody');
 body.innerHTML=`<div class="tutorial-card"><div class="tutorial-icon">${item.icon}</div><h3>${item.title}</h3><p>${item.text}</p><div class="tutorial-dots">${TUTORIAL_STEPS.map((_,index)=>index===step?'●':'○').join(' ')}</div><button class="action" id="tutorialSkip">SKIP</button><button class="action" id="tutorialNext">${step===TUTORIAL_STEPS.length-1?'DONE':'NEXT'}</button></div>`;
 $('#tutorialSkip').onclick=()=>{save.tutorial.completed=true;persist();closePanel()};$('#tutorialNext').onclick=()=>{if(step===TUTORIAL_STEPS.length-1){save.tutorial.completed=true;persist();closePanel()}else showTutorial(step+1)};openPanel();
}
function progressTask(object){
 const tier=data.tasks[save.taskTier],bird=getBird(object);if(!tier||!bird)return;
 tier.tasks.forEach((task,index)=>{
  let matches=false;
  if(task.taskType==='HATCH_ANY_KIND_OF_BIRD')matches=true;
  else if(task.taskType==='HATCH_BIRD_OF_COLOR')matches=bird.shape===task.identifier;
  else if(task.taskType==='HATCH_BIRD_OF_GENDER')matches=object.gender===task.identifier;
  else if(task.taskType==='HATCH_BIRD_WITH_ACCESSORY')matches=(bird.sprites||[]).some(part=>String(part.sprite).includes('ACCESSORY'));
  if(matches)save.taskProgress[index]=(save.taskProgress[index]||0)+1;
 });
 save.taskProgress=save.taskProgress.map((value,index)=>Math.min(value,tier.tasks[index].amount));
}

function showBirds(){
 const body=$('#panelBody');$('#panelTitle').textContent='MY SLINGSHOT FLOCK';body.innerHTML='<p class="flock-note">Every bird shown here is queued in Angry Birds levels. Tap a card to customize it; use the speaker to hear its saved voice.</p><div class="bird-grid"></div>';const grid=$('.bird-grid',body),birds=save.objects.filter(object=>object.type==='bird');
 if(!birds.length)body.innerHTML='<p>Hatch an egg to add your first bird. No starter birds are granted.</p>';
 for(const object of birds){const card=document.createElement('div');card.className='bird-card';card.innerHTML=`<button class="bird-open"><canvas width="180" height="180"></canvas><b>BIRD ${object.birdIndex+1}</b><small>${object.gender==='female'?'♀ FEMALE':'♂ MALE'} · VOICE ${object.voice||1}</small></button><button class="voice-preview" title="Play this bird voice">🔊</button>`;$('.bird-open',card).onclick=()=>openBirdDesigner(object);$('.voice-preview',card).onclick=()=>playBirdVoice(object);grid.append(card);const preview=$('canvas',card).getContext('2d');drawBird(getBird(object),90,105,.72,time,preview)}openPanel();
}
function showTasks(){
 const tier=data.tasks[save.taskTier]||data.tasks.at(-1),achievements=save.achievements||{maleBirds:0,femaleBirds:0};$('#panelTitle').textContent='TASKS & ACHIEVEMENTS';const body=$('#panelBody');
 body.innerHTML=`<div class="achievement-summary"><div><b>♂ MALE BIRDS</b><strong>${achievements.maleBirds||0}</strong></div><div><b>♀ FEMALE BIRDS</b><strong>${achievements.femaleBirds||0}</strong></div></div><p class="achievement-note">Only the gender selected in the hatch dialog is counted.</p><div class="task-list"></div>`;
 const list=$('.task-list',body);tier.tasks.forEach((task,index)=>{const done=(save.taskProgress[index]||0)>=task.amount,card=document.createElement('div');card.className='task-card '+(done?'done':'');card.innerHTML=`<b>${done?'✓':'○'} ${task.text}</b><p>${save.taskProgress[index]||0} / ${task.amount}</p>`;list.append(card)});
 if(tier.tasks.every((task,index)=>(save.taskProgress[index]||0)>=task.amount)){const button=document.createElement('button');button.className='action';button.textContent=`COLLECT ${tier.rewardAmount} ★`;button.onclick=()=>{save.stars+=tier.rewardAmount;save.taskTier=Math.min(save.taskTier+1,data.tasks.length-1);save.taskProgress=[0,0,0];persist();updateHud();showTasks();play('h_fanfare_1.wav')};body.append(button)}openPanel();
}
function openBirdDesigner(o){selected=o;const bird=o.custom||(o.custom=JSON.parse(JSON.stringify(data.prototypeBirds[o.birdIndex])));$('#panelTitle').textContent='BIRD DESIGNER';const body=$('#panelBody');body.innerHTML='<canvas id="birdPreview" width="380" height="280" style="display:block;margin:auto;max-width:100%;background:radial-gradient(circle,#c8f5f4,#4cb5cb);border-radius:22px"></canvas><div style="text-align:center"><button class="action" data-cycle="body">BODY</button><button class="action" data-cycle="eyes">EYES</button><button class="action" data-cycle="beak">BEAK</button><button class="action" data-cycle="hat">HAT</button></div>';const redraw=()=>{const c=$('#birdPreview'),x=c.getContext('2d');x.clearRect(0,0,c.width,c.height);drawBird(bird,190,165,1.1,time,x)};redraw();$$('[data-cycle]',body).forEach(btn=>btn.onclick=()=>{const types=data.birdDefinitions.DefaultIndexes,kind=btn.dataset.cycle;if(kind==='body'){bird.shape=types[(types.indexOf(bird.shape)+1)%types.length];bird.color=types[(types.indexOf(bird.color)+2)%types.length];bird.sprite=`BIRD_BODY_${bird.shape}_${bird.color}`;if(!sprites.meta(bird.sprite))bird.sprite='BIRD_BODY_RED_RED'}else if(kind==='eyes')bird.eyes=types[(types.indexOf(bird.eyes)+1)%types.length];else if(kind==='beak')bird.beak=types[(types.indexOf(bird.beak)+1)%types.length];else{bird.sprites=bird.sprites||[];bird.sprites.push({sprite:data.birdDefinitions.Sprites.AccessoryTop[Math.floor(Math.random()*data.birdDefinitions.Sprites.AccessoryTop.length)],x:0,y:-75,scale:.7,angle:0})}play('h_marker_2.mp3');redraw();persist()});openPanel()}
function openPanel(){$('#contextMenu').hidden=true;$('#panel').hidden=false}function closePanel(){$('#panel').hidden=true}

function resetPointerState(){pointers.clear();camera.drag=false;camera.pinch=0;camera.moved=false;if(slingshot){slingshot.dragging=false;slingshot.cameraDragging=false}}
canvas.addEventListener('pointerdown',e=>{try{canvas.setPointerCapture(e.pointerId)}catch{}pointers.set(e.pointerId,{x:e.clientX,y:e.clientY});if(screen==='slingshot'&&slingshot){if(e.clientX<82&&e.clientY<82){exitLevel();return}const S=slingshot;if(S.intro){S.intro=false;S.cameraX=S.birdCameraX;return}const b=S.current,wx=e.clientX+S.cameraX;if(b?.isStatic&&Math.hypot(wx-b.position.x,e.clientY-b.position.y)<Math.max(48,S.pullRadius)){S.dragging=true;play(birdSoundPack(b.plugin.source).select,.62)}else if(b&&!b.isStatic&&!S.special)activateSpecial();else{S.cameraDragging=true;S.cameraDragStart=e.clientX;S.cameraDragBase=S.cameraX}return}camera.drag=true;camera.startX=e.clientX;camera.startY=e.clientY;camera.baseX=camera.x;camera.baseY=camera.y;camera.moved=pointers.size>1;if(screen==='title'&&soundOn&&audio.title.paused)setMusic('title')});
canvas.addEventListener('pointermove',e=>{if(!pointers.has(e.pointerId))return;pointers.set(e.pointerId,{x:e.clientX,y:e.clientY});if(screen==='slingshot'&&slingshot){const S=slingshot;if(S.dragging&&S.current){const dx=e.clientX+S.cameraX-S.sling.x,dy=e.clientY-S.sling.y,d=Math.hypot(dx,dy),r=Math.min(S.pullRadius,d);Matter.Body.setPosition(S.current,{x:S.sling.x+(d?dx/d*r:0),y:S.sling.y+(d?dy/d*r:0)});return}else if(S.cameraDragging){S.cameraX=clamp(S.cameraDragBase-(e.clientX-S.cameraDragStart),0,S.maxCameraX);return}}if(placement){placement.pointerX=e.clientX;placement.pointerY=e.clientY}if(screen!=='world')return;if(pointers.size===1&&camera.drag){const dx=e.clientX-camera.startX,dy=e.clientY-camera.startY;if(Math.hypot(dx,dy)>5)camera.moved=true;camera.x=clamp(camera.baseX-dx/camera.zoom,100,13600);camera.y=clamp(camera.baseY-dy/camera.zoom,100,6700)}else if(pointers.size>=2){camera.moved=true;const ps=[...pointers.values()].slice(0,2),d=Math.hypot(ps[0].x-ps[1].x,ps[0].y-ps[1].y);if(!camera.pinch){camera.pinch=d;camera.pinchZoom=camera.zoom}else camera.zoom=clamp(camera.pinchZoom*d/camera.pinch,.38,1.45)}});
function finishPointer(e,cancelled=false){const wasMoved=camera.moved;if(screen==='slingshot'&&slingshot?.dragging){if(cancelled&&slingshot.current)Matter.Body.setPosition(slingshot.current,slingshot.sling);else if(slingshot.current)launchBird(slingshot.current.position.x,slingshot.current.position.y);slingshot.dragging=false}if(slingshot)slingshot.cameraDragging=false;pointers.delete(e.pointerId);if(screen==='world'&&pointers.size===1){const p=[...pointers.values()][0];camera.startX=p.x;camera.startY=p.y;camera.baseX=camera.x;camera.baseY=camera.y;camera.pinch=0;camera.moved=true}else if(!pointers.size){camera.drag=false;camera.pinch=0;if(!cancelled&&!wasMoved&&screen!=='slingshot')handleTap(e.clientX,e.clientY);camera.moved=false}}
canvas.addEventListener('pointerup',e=>finishPointer(e,false));canvas.addEventListener('pointercancel',e=>finishPointer(e,true));canvas.addEventListener('lostpointercapture',e=>{if(pointers.has(e.pointerId))finishPointer(e,true)});addEventListener('blur',resetPointerState);document.addEventListener('visibilitychange',()=>{if(document.hidden)resetPointerState()});
canvas.addEventListener('wheel',e=>{if(screen!=='world')return;e.preventDefault();camera.zoom=clamp(camera.zoom*Math.exp(-e.deltaY*.001),.38,1.45)},{passive:false});

$$('.tools button').forEach(b=>b.onclick=()=>{const t=b.dataset.tool;play('menu_select.mp3');if(t==='nest'){placement={type:'nest',pointerX:W/2,pointerY:H/2};$$('.tools button').forEach(x=>x.classList.toggle('active',x===b));toast('TAP THE MAP TO PLACE A NEST')}else if(t==='egg'){const nest=save.objects.find(x=>x.type==='nest'&&x.state==='empty');if(nest)openContext(nest);else toast('PLACE OR SELECT AN EMPTY NEST')}else if(t==='birds')showBirds();else if(t==='tasks')showTasks();else showLevels()});
$('#homeButton').onclick=()=>{screen='title';$('#hud').hidden=true;setMusic('title');play('menu_back.mp3')};$('#tutorialButton').onclick=()=>showTutorial(0);$('#soundButton').onclick=()=>{soundOn=!soundOn;save.sound=soundOn;persist();if(!soundOn)Object.values(audio).filter(Boolean).forEach(a=>a.pause());else setMusic(screen==='world'?'ambient':'title');updateHud()};$('#zoomIn').onclick=()=>camera.zoom=clamp(camera.zoom*1.15,.38,1.45);$('#zoomOut').onclick=()=>camera.zoom=clamp(camera.zoom/1.15,.38,1.45);$('.close-context').onclick=()=>$('#contextMenu').hidden=true;$('#closePanel').onclick=closePanel;

function frame(now){const dt=Math.min(.05,(now-last)/1000);last=now;time+=dt;ctx.setTransform(DPR,0,0,DPR,0,0);if(screen==='title')renderTitle();else if(screen==='world'){updateWorldAmbience(now);renderWorld()}else if(screen==='slingshot'){updateSlingshot(dt);renderSlingshot()}requestAnimationFrame(frame)}
window.__hatcheryDebug=()=>({screen,atlasesLoaded:atlasImages.size,level:slingshot?.level?.id||null,pack:slingshot?.level?.pack||null,cameraX:slingshot?.cameraX||0,currentBird:slingshot?.current?{x:slingshot.current.position.x,y:slingshot.current.position.y,speed:slingshot.current.speed,static:slingshot.current.isStatic,sleeping:slingshot.current.isSleeping}:null,goals:slingshot?Matter.Composite.allBodies(slingshot.world).filter(body=>body.label==='pig').length:0,objects:slingshot?Matter.Composite.allBodies(slingshot.world).length:0,joints:slingshot?.constraints?.length||0,flock:slingshot?.roster?.length||0,queueIndex:slingshot?.queueIndex||0});
boot();
if('serviceWorker'in navigator&&location.protocol.startsWith('http'))navigator.serviceWorker.register('./sw.js').catch(()=>{});
})();
