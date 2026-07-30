(() => {
'use strict';
const $=(s,r=document)=>r.querySelector(s), $$=(s,r=document)=>[...r.querySelectorAll(s)];
const clamp=(v,a,b)=>Math.max(a,Math.min(b,v));
const canvas=$('#game'),ctx=canvas.getContext('2d',{alpha:false});
let W=0,H=0,DPR=1,uiScale=1,registry,data,atlasImages=new Map(),screen='loading',time=0,last=performance.now();
const TILE_W=196,TILE_H=97,MAP_ORIGIN_X=70*TILE_W/2;
const camera={x:5480,y:2380,zoom:1,drag:false,startX:0,startY:0,baseX:0,baseY:0,moved:false};
const pointers=new Map();
const audio={title:new Audio('assets/audio/title_theme.mp3'),ambient:new Audio('assets/audio/hatchery_ambient.mp3')};
audio.title.loop=audio.ambient.loop=true;audio.title.volume=.38;audio.ambient.volume=.34;
let soundOn=true,titleButton={x:0,y:0,w:0,h:0},placement=null,selected=null,toastTimer=0;
let baseTiles=[],worldDecor=[],worldObstacles=[],dynamicDecor=[];

const freshSave=()=>({stars:60,coins:300,objects:[
 {id:'nest-1',type:'nest',x:5480,y:2400,state:'empty',created:Date.now()},
 {id:'bird-1',type:'bird',x:5310,y:2480,birdIndex:0},
 {id:'bird-2',type:'bird',x:5600,y:2510,birdIndex:1}
],removed:[],taskTier:0,taskProgress:[0,0,0],sound:true});
let save=loadSave();soundOn=save.sound!==false;
function loadSave(){try{return {...freshSave(),...JSON.parse(localStorage.getItem('hatchery-island-save')||'{}')}}catch{return freshSave()}}
function persist(){localStorage.setItem('hatchery-island-save',JSON.stringify(save))}
function play(name,vol=.7){if(!soundOn)return;const a=new Audio(`assets/audio/${name}`);a.volume=vol;a.play().catch(()=>{})}
function setMusic(which){Object.values(audio).forEach(a=>{if(a!==audio[which]){a.pause();a.currentTime=0}});if(soundOn&&which)audio[which].play().catch(()=>{})}
function toast(text){const el=$('#toast');el.textContent=text;el.classList.add('show');clearTimeout(toastTimer);toastTimer=setTimeout(()=>el.classList.remove('show'),1500)}

class SpriteLibrary{
 constructor(reg){this.reg=reg}
 async load(){const jobs=Object.entries(this.reg.atlases).map(([name,url])=>new Promise((resolve,reject)=>{const im=new Image();im.onload=()=>{atlasImages.set(name,im);resolve()};im.onerror=reject;im.src=url}));await Promise.all(jobs)}
 meta(name){return this.reg.sprites[name]}
 draw(name,x,y,scale=1,angle=0,alpha=1,context=ctx){const s=this.meta(name);if(!s)return false;const im=atlasImages.get(s.atlas);if(!im)return false;context.save();context.globalAlpha=alpha;context.translate(x,y);context.rotate(angle);context.scale(scale,scale);context.drawImage(im,s.x,s.y,s.w,s.h,-s.ox,-s.oy,s.w,s.h);context.restore();return true}
 drawCentered(name,x,y,maxW,maxH,context=ctx){const s=this.meta(name);if(!s)return;const scale=Math.min(maxW/s.w,maxH/s.h);const im=atlasImages.get(s.atlas);context.drawImage(im,s.x,s.y,s.w,s.h,x-s.w*scale/2,y-s.h*scale/2,s.w*scale,s.h*scale)}
 raw(name){const s=this.meta(name);return s&&{s,image:atlasImages.get(s.atlas)}}
}
let sprites;

function resize(){const r=canvas.getBoundingClientRect();DPR=Math.min(1.5,devicePixelRatio||1);W=r.width;H=r.height;canvas.width=Math.round(W*DPR);canvas.height=Math.round(H*DPR);ctx.setTransform(DPR,0,0,DPR,0,0);uiScale=Math.min(W/1024,H/768)}
addEventListener('resize',resize);resize();

async function boot(){
 try{
  const [s,g]=await Promise.all([fetch('assets/data/sprites.json').then(r=>r.json()),fetch('assets/data/game-data.json').then(r=>r.json())]);registry=s;data=g;sprites=new SpriteLibrary(s);await sprites.load();prepareMap();$('#loading').hidden=true;screen='title';requestAnimationFrame(frame)
 }catch(e){$('#loading b').textContent='LOAD ERROR: '+e.message;console.error(e)}
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
 if(screen==='title'){if(x>=titleButton.x&&x<=titleButton.x+titleButton.w&&y>=titleButton.y&&y<=titleButton.y+titleButton.h){play('menu_confirm.mp3');setMusic('ambient');screen='world';$('#hud').hidden=false;toast('WELCOME TO HATCHERY ISLAND!')}return}
 if(screen!=='world')return;const w=screenToWorld(x,y);
 if(placement){const tile=worldToTile(w.x,w.y),p=tilePoint(tile.col,tile.row);if(placement.type==='nest'){if(save.coins<20)return toast('NOT ENOUGH COINS');save.coins-=20;save.objects.push({id:'nest-'+Date.now(),type:'nest',x:p.x,y:p.y,state:'empty',created:Date.now()});play('h_purchase.wav')}else if(placement.type==='move'&&placement.object){placement.object.x=p.x;placement.object.y=p.y;play('abi_inventory_place.mp3')}placement=null;$$('.tools button').forEach(b=>b.classList.remove('active'));persist();updateHud();return}
 const o=objectAt(w.x,w.y);if(o)openContext(o)
}
function openContext(o){selected=o;const box=$('#contextMenu'),title=$('#contextTitle'),text=$('#contextText'),actions=$('#contextActions');actions.innerHTML='';box.hidden=false;
 if(o.type==='nest'){title.textContent='NEST';if(o.state==='empty'){text.textContent='This nest is ready for an egg.';addAction('ADD EGG · 20',()=>addEgg(o))}else if(o.state==='incubating'){const left=Math.max(0,Math.ceil(60-(Date.now()-o.created)/1000));text.textContent=`The egg hatches in ${left} seconds.`;addAction('HURRY · 10 ★',()=>hurry(o))}else{text.textContent='The egg is ready to hatch!';addAction('HATCH!',()=>hatch(o))}addAction('MOVE',()=>beginMove(o))}
 else if(o.type==='bird'){title.textContent='HATCHED BIRD';text.textContent='View or customize this bird.';addAction('CUSTOMIZE',()=>openBirdDesigner(o));addAction('REMOVE',()=>removeUser(o))}
 else{title.textContent='CLEAR OBSTACLE';text.textContent='Clear this object to make room for a nest.';addAction('CLEAR · 20',()=>clearObstacle(o))}}
function addAction(label,fn){const b=document.createElement('button');b.textContent=label;b.onclick=()=>{play('menu_confirm.mp3');$('#contextMenu').hidden=true;fn()};$('#contextActions').append(b)}
function addEgg(n){if(save.coins<20)return toast('NOT ENOUGH COINS');save.coins-=20;n.state='incubating';n.created=Date.now();persist();updateHud();play('h_egg_selected.wav');toast('EGG ADDED')}
function hurry(n){if(save.stars<10)return toast('NOT ENOUGH STARS');save.stars-=10;n.state='ready';persist();updateHud();play('h_marker_1.mp3')}
function hatch(n){const index=Math.floor(Math.random()*data.prototypeBirds.length),id='bird-'+Date.now();save.objects.push({id,type:'bird',x:n.x+95,y:n.y+25,birdIndex:index});n.state='empty';n.created=Date.now();progressTask(data.prototypeBirds[index]);persist();play('h_bird_hatched_popup.mp3');toast('A NEW BIRD HATCHED!')}
function beginMove(o){placement={type:'move',object:o,pointerX:W/2,pointerY:H/2};toast('TAP A NEW LOCATION')}
function removeUser(o){save.objects=save.objects.filter(x=>x.id!==o.id);persist()}
function clearObstacle(o){if(save.coins<20)return toast('NOT ENOUGH COINS');save.coins-=20;worldObstacles=worldObstacles.filter(x=>x.id!==o.id);save.removed.push(o.id);persist();updateHud();play('abi_remove_item.mp3');toast('AREA CLEARED')}

function updateHud(){$('#stars').textContent=save.stars;$('#coins').textContent=save.coins;$('#soundButton').textContent=soundOn?'♫':'×'}
function progressTask(bird){const tier=data.tasks[save.taskTier];if(!tier)return;tier.tasks.forEach((t,i)=>{if(t.taskType==='HATCH_ANY_KIND_OF_BIRD')save.taskProgress[i]++;else if(t.taskType==='HATCH_BIRD_OF_COLOR'&&(bird.shape===t.identifier||bird.color===t.identifier))save.taskProgress[i]++;else if(t.taskType==='HATCH_BIRD_OF_GENDER')save.taskProgress[i]++;else if(t.taskType==='HATCH_BIRD_WITH_ACCESSORY'&&(bird.sprites||[]).some(s=>String(s.sprite).includes('ACCESSORY')))save.taskProgress[i]++});save.taskProgress=save.taskProgress.map((v,i)=>Math.min(v,tier.tasks[i].amount))}

function showBirds(){const body=$('#panelBody');$('#panelTitle').textContent='MY BIRDS';body.innerHTML='<div class="bird-grid"></div>';const grid=$('.bird-grid',body);const birds=save.objects.filter(o=>o.type==='bird');if(!birds.length)body.innerHTML='<p>Hatch an egg to add your first bird.</p>';for(const o of birds){const card=document.createElement('button');card.className='bird-card';card.innerHTML='<canvas width="180" height="180"></canvas><b>BIRD '+(o.birdIndex+1)+'</b>';card.onclick=()=>openBirdDesigner(o);grid.append(card);const c=$('canvas',card),cctx=c.getContext('2d');drawBird(getBird(o),90,105,.72,time,cctx)}openPanel()}
function showTasks(){const tier=data.tasks[save.taskTier]||data.tasks.at(-1);$('#panelTitle').textContent='HATCHERY TASKS';const body=$('#panelBody');body.innerHTML='<div class="task-list"></div>';const list=$('.task-list',body);tier.tasks.forEach((t,i)=>{const done=(save.taskProgress[i]||0)>=t.amount,el=document.createElement('div');el.className='task-card '+(done?'done':'');el.innerHTML=`<b>${done?'✓':'○'} ${t.text}</b><p>${save.taskProgress[i]||0} / ${t.amount}</p>`;list.append(el)});if(tier.tasks.every((t,i)=>(save.taskProgress[i]||0)>=t.amount)){const b=document.createElement('button');b.className='action';b.textContent=`COLLECT ${tier.rewardAmount} ★`;b.onclick=()=>{save.stars+=tier.rewardAmount;save.taskTier=Math.min(save.taskTier+1,data.tasks.length-1);save.taskProgress=[0,0,0];persist();updateHud();showTasks();play('h_fanfare_1.wav')};body.append(b)}openPanel()}
function openBirdDesigner(o){selected=o;const bird=o.custom||(o.custom=JSON.parse(JSON.stringify(data.prototypeBirds[o.birdIndex])));$('#panelTitle').textContent='BIRD DESIGNER';const body=$('#panelBody');body.innerHTML='<canvas id="birdPreview" width="380" height="280" style="display:block;margin:auto;max-width:100%;background:radial-gradient(circle,#c8f5f4,#4cb5cb);border-radius:22px"></canvas><div style="text-align:center"><button class="action" data-cycle="body">BODY</button><button class="action" data-cycle="eyes">EYES</button><button class="action" data-cycle="beak">BEAK</button><button class="action" data-cycle="hat">HAT</button></div>';const redraw=()=>{const c=$('#birdPreview'),x=c.getContext('2d');x.clearRect(0,0,c.width,c.height);drawBird(bird,190,165,1.1,time,x)};redraw();$$('[data-cycle]',body).forEach(btn=>btn.onclick=()=>{const types=data.birdDefinitions.DefaultIndexes,kind=btn.dataset.cycle;if(kind==='body'){bird.shape=types[(types.indexOf(bird.shape)+1)%types.length];bird.color=types[(types.indexOf(bird.color)+2)%types.length];bird.sprite=`BIRD_BODY_${bird.shape}_${bird.color}`;if(!sprites.meta(bird.sprite))bird.sprite='BIRD_BODY_RED_RED'}else if(kind==='eyes')bird.eyes=types[(types.indexOf(bird.eyes)+1)%types.length];else if(kind==='beak')bird.beak=types[(types.indexOf(bird.beak)+1)%types.length];else{bird.sprites=bird.sprites||[];bird.sprites.push({sprite:data.birdDefinitions.Sprites.AccessoryTop[Math.floor(Math.random()*data.birdDefinitions.Sprites.AccessoryTop.length)],x:0,y:-75,scale:.7,angle:0})}play('h_marker_2.mp3');redraw();persist()});openPanel()}
function openPanel(){$('#contextMenu').hidden=true;$('#panel').hidden=false}function closePanel(){$('#panel').hidden=true}

canvas.addEventListener('pointerdown',e=>{canvas.setPointerCapture(e.pointerId);pointers.set(e.pointerId,{x:e.clientX,y:e.clientY});camera.drag=true;camera.startX=e.clientX;camera.startY=e.clientY;camera.baseX=camera.x;camera.baseY=camera.y;camera.moved=false;if(!soundOn)return;if(screen==='title'&&audio.title.paused)setMusic('title')});
canvas.addEventListener('pointermove',e=>{if(!pointers.has(e.pointerId))return;pointers.set(e.pointerId,{x:e.clientX,y:e.clientY});if(placement){placement.pointerX=e.clientX;placement.pointerY=e.clientY;}if(pointers.size===1&&camera.drag&&screen==='world'){const dx=e.clientX-camera.startX,dy=e.clientY-camera.startY;if(Math.hypot(dx,dy)>5)camera.moved=true;camera.x=clamp(camera.baseX-dx/camera.zoom,100,13600);camera.y=clamp(camera.baseY-dy/camera.zoom,100,6700)}if(pointers.size===2&&screen==='world'){const ps=[...pointers.values()],d=Math.hypot(ps[0].x-ps[1].x,ps[0].y-ps[1].y);if(!camera.pinch){camera.pinch=d;camera.pinchZoom=camera.zoom}else camera.zoom=clamp(camera.pinchZoom*d/camera.pinch,.38,1.45)}});
canvas.addEventListener('pointerup',e=>{const wasMoved=camera.moved;pointers.delete(e.pointerId);if(!pointers.size){camera.drag=false;camera.pinch=0;if(!wasMoved)handleTap(e.clientX,e.clientY)}});
canvas.addEventListener('wheel',e=>{if(screen!=='world')return;e.preventDefault();camera.zoom=clamp(camera.zoom*Math.exp(-e.deltaY*.001),.38,1.45)},{passive:false});

$$('.tools button').forEach(b=>b.onclick=()=>{const t=b.dataset.tool;play('menu_select.mp3');if(t==='nest'){placement={type:'nest',pointerX:W/2,pointerY:H/2};$$('.tools button').forEach(x=>x.classList.toggle('active',x===b));toast('TAP THE MAP TO PLACE A NEST')}else if(t==='egg'){const nest=save.objects.find(x=>x.type==='nest'&&x.state==='empty');if(nest)openContext(nest);else toast('PLACE OR SELECT AN EMPTY NEST')}else if(t==='birds')showBirds();else showTasks()});
$('#homeButton').onclick=()=>{screen='title';$('#hud').hidden=true;setMusic('title');play('menu_back.mp3')};$('#soundButton').onclick=()=>{soundOn=!soundOn;save.sound=soundOn;persist();if(!soundOn)Object.values(audio).forEach(a=>a.pause());else setMusic(screen==='world'?'ambient':'title');updateHud()};$('#zoomIn').onclick=()=>camera.zoom=clamp(camera.zoom*1.15,.38,1.45);$('#zoomOut').onclick=()=>camera.zoom=clamp(camera.zoom/1.15,.38,1.45);$('.close-context').onclick=()=>$('#contextMenu').hidden=true;$('#closePanel').onclick=closePanel;

function frame(now){const dt=Math.min(.05,(now-last)/1000);last=now;time+=dt;ctx.setTransform(DPR,0,0,DPR,0,0);if(screen==='title')renderTitle();else if(screen==='world')renderWorld();requestAnimationFrame(frame)}
boot();
if('serviceWorker'in navigator&&location.protocol.startsWith('http'))navigator.serviceWorker.register('./sw.js').catch(()=>{});
})();
