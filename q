<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>移动德州扑克</title>
<style>
:root{
  --bg:#071425; --panel:#0e2a3b; --glass:rgba(255,255,255,0.03);
  --accent:#21d4fd; --accent2:#b621fe; --muted:#9fc7e0; --chip:#ffd966;
  --card-back:#183041; --danger:#ff6b6b; --font-sans:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial;
}
html,body{height:100%;margin:0;font-family:var(--font-sans);-webkit-font-smoothing:antialiased;background:
radial-gradient(1200px 600px at 10% 10%, rgba(33,212,253,0.06), transparent 10%),
radial-gradient(800px 350px at 90% 90%, rgba(182,33,254,0.04), transparent 10%),
var(--bg);color:#e6f6ff;}
.app{display:flex;flex-direction:column;height:100vh;padding:calc(12px + env(safe-area-inset-top)) 12px calc(12px + env(safe-area-inset-bottom));gap:10px;}
header{display:flex;align-items:center;justify-content:space-between;gap:8px;}
.brand{display:flex;align-items:center;gap:10px;}
.logo{width:44px;height:44px;border-radius:10px;background:linear-gradient(135deg,var(--accent),var(--accent2));display:flex;align-items:center;justify-content:center;box-shadow:0 6px 18px rgba(0,0,0,0.5);font-weight:800;color:white;}
h1{font-size:16px;margin:0;letter-spacing:0.2px;}
.subtitle{font-size:11px;color:var(--muted);margin-top:2px;}
.controls{display:flex;gap:8px;align-items:center;}
.btn{background:linear-gradient(180deg,rgba(255,255,255,0.04),rgba(255,255,255,0.01));border:1px solid rgba(255,255,255,0.03);color:#e6f6ff;padding:8px 12px;border-radius:12px;font-weight:600;font-size:14px;box-shadow:0 8px 20px rgba(2,6,23,0.6);backdrop-filter: blur(6px);-webkit-tap-highlight-color: transparent;}
.btn.ghost{background:transparent;border:1px solid rgba(255,255,255,0.06);color:var(--muted);}
.btn.primary{background:linear-gradient(90deg,var(--accent),var(--accent2));border:none;color:white;box-shadow:0 8px 28px rgba(34,211,238,0.08);}
.table-wrap{flex:1;display:grid;grid-template-columns:1fr;gap:10px;align-items:stretch;}
.table{border-radius:16px;padding:14px;background:linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01));border:1px solid rgba(255,255,255,0.03);display:flex;flex-direction:column;align-items:center;position:relative;overflow:hidden;box-shadow: inset 0 -60px 120px rgba(0,0,0,0.25);}
.felt{width:100%;max-width:920px;aspect-ratio:16/9;border-radius:12px;background:linear-gradient(180deg,#073243 0%,#04202a 100%);display:flex;flex-direction:column;align-items:center;justify-content:center;gap:12px;padding:12px;position:relative;}
.community{display:flex;gap:8px;align-items:center;justify-content:center;transform-style:preserve-3d;perspective:900px;}
.card{width:54px;height:78px;border-radius:8px;background:white;color:#101018;display:flex;align-items:center;justify-content:center;font-weight:800;box-shadow:0 6px 20px rgba(0,0,0,0.45);transition: transform .28s cubic-bezier(.2,.9,.3,1), box-shadow .18s;user-select:none;}
.card.red{color:#b9272f;}
.card.back{background:linear-gradient(90deg,var(--card-back), #0d2b36);color:#9fc7e0;display:flex;flex-direction:column;gap:2px;font-weight:700;padding:6px;}
.card.small{width:44px;height:60px;border-radius:7px;font-size:13px;}
.players-row{width:100%;display:flex;gap:10px;justify-content:space-between;padding:4px 6px;box-sizing:border-box;}
.player{background:linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01));padding:8px;border-radius:10px;min-width:88px;display:flex;flex-direction:column;align-items:center;gap:6px;border:1px solid rgba(255,255,255,0.03);}
.player .name{font-size:12px;font-weight:700;}
.player .chips{font-size:13px;font-weight:800;color:var(--chip);background:rgba(255,255,255,0.03);padding:6px 8px;border-radius:10px;}
.dealer-badge{font-size:11px;color:var(--muted);border-radius:8px;padding:4px 6px;background:rgba(255,255,255,0.02);}
.pot{position:absolute;top:12px;left:50%;transform:translateX(-50%);background:linear-gradient(90deg,var(--accent),var(--accent2));padding:6px 10px;border-radius:999px;font-weight:800;color:white;box-shadow:0 10px 30px rgba(34,211,238,0.08);}
.info-bar{display:flex;gap:8px;align-items:center;justify-content:space-between;width:100%;margin-top:8px;}
.log{font-size:12px;color:var(--muted);background:linear-gradient(180deg, rgba(255,255,255,0.01), transparent);padding:8px;border-radius:10px;flex:1;min-height:40px;max-height:110px;overflow:auto;}
.action-row{display:flex;gap:8px;align-items:center;justify-content:center;width:100%;margin-top:8px;}
.raise-input{width:110px;padding:8px;border-radius:10px;background:rgba(255,255,255,0.02);border:1px solid rgba(255,255,255,0.03);color:var(--muted);text-align:center;font-weight:700;}
footer{font-size:12px;color:var(--muted);text-align:center;margin-top:4px;}
.deal-anim{animation:deal .45s ease forwards;}
@keyframes deal{from{transform: translateY(-18px) rotateX(20deg) scale(.6);opacity:0;}to{transform: none;opacity:1;}}
@media(min-width:700px){.app{padding:20px;}.card{width:72px;height:100px;}.card.small{width:56px;height:78px;}}
</style>
</head>
<body>
<div class="app" id="app">
<header>
<div class="brand">
<div class="logo">PK</div>
<div>
<h1>移动德州扑克</h1>
<div class="subtitle">精美触控 UI — 直接在手机上打开</div>
</div>
</div>
<div class="controls">
<button class="btn ghost" id="btnTheme">主题</button>
<button class="btn primary" id="startBtn">开始新局</button>
</div>
</header>

<div class="table-wrap">
<div class="table">
<div class="pot" id="pot">底池 • 0</div>
<div class="felt" id="felt">
<div class="players-row" id="topRow" aria-hidden="true"></div>
<div class="community" id="community" aria-live="polite"></div>
<div class="players-row" id="bottomRow" style="margin-top:6px;"></div>
</div>
<div class="info-bar">
<div class="log" id="log">准备就绪 — 点击“开始新局”。</div>
<div style="display:flex;gap:8px;align-items:center;">
<div class="muted">大盲</div>
<div class="chips" id="bbDisplay" style="background:transparent;color:var(--muted);font-weight:700;">20</div>
</div>
</div>
<div style="width:100%;margin-top:8px;">
<div style="display:flex;gap:8px;align-items:center;">
<input id="numPlayers" type="range" min="2" max="6" value="4" style="flex:1">
<div class="muted" id="numPlayersVal">4 人</div>
</div>
<div class="action-row" style="margin-top:8px;">
<button class="btn" id="btnFold">弃牌</button>
<button class="btn ghost" id="btnCheck">过牌</button>
<button class="btn" id="btnCall">跟注</button>
<button class="btn primary" id="btnRaise">加注</button>
<input id="raiseAmt" class="raise-input" type="number" value="100">
</div>
</div>
</div>
</div>
<footer>保存为单文件 HTML，直接在手机浏览器打开即可。</footer>
</div>

<script>
// —— 游戏逻辑（精简整理版） ——
const RANKS="23456789TJQKA", SUITS=["♠","♥","♦","♣"], HAND_RANKS=["高牌","一对","两对","三条","顺子","同花","葫芦","四条","同花顺"];
let state={players:[],deck:[],community:[],pot:0,dealer:0,sb:1,bb:2,currentBet:0,minRaise:0,street:'idle',turn:0,finished:true,logs:[]};
const el=id=>document.getElementById(id);
const logEl=el('log'), commEl=el('community'), topRow=el('topRow'), bottomRow=el('bottomRow'), potEl=el('pot'), numPlayersRange=el('numPlayers'), numPlayersVal=el('numPlayersVal'), bbDisplay=el('bbDisplay');

function shuffle(arr){for(let i=arr.length-1;i>0;i--){const j=Math.floor(Math.random()*(i+1));[arr[i],arr[j]]=[arr[j],arr[i];}}
function makeDeck(){const d=[];for(const r of RANKS)for(const s of SUITS)d.push(r+s);return d;}
function appendLog(s){state.logs.push(s);logEl.innerHTML=state.logs.slice(-6).join('<br>');logEl.scrollTop=logEl.scrollHeight;}
function cardHTML(c,small=false){if(!c)return`<div class="card back ${small?'small':''}">?</div>`;const suit=c[1];const colorClass=(suit==='♥'||suit==='♦')?'red':'';return`<div class="card ${small?'small':''} ${colorClass}" data-card="${c}">${c[0]}${suit}</div>`;}
function setPot(n){potEl.innerText=`底池 • ${n}`;}
function renderPlayers(){topRow.innerHTML='';bottomRow.innerHTML='';const n=state.players.length;for(let i=0;i<n;i++){const p=state.players[i];const elDiv=document.createElement('div');elDiv.className='player';elDiv.innerHTML=`<div class="name">${p.name}${p.dealer?'<div class="dealer-badge">BTN</div>':''}</div><div class="chips">${p.chips}</div><div class="muted" style="font-size:12px">${p.folded?'已弃':''}${p.allin?' 全下':''}</div><div style="margin-top:6px">${p.isHero?p.hole.map(c=>cardHTML(c,true)).join(''):(p.folded?'<div class="muted">-</div>':'<div class="card small back">?</div>')}</div>`;i===0?bottomRow.appendChild(elDiv):topRow.appendChild(elDiv);}setPot(state.pot);}
function renderCommunity(){commEl.innerHTML='';state.community.forEach(c=>{const node=document.createElement('div');node.className='card deal-anim '+((c[1]==='♥'||c[1]==='♦')?'red':'');node.innerHTML=`${c[0]}${c[1]}`;commEl.appendChild(node);});}
function startNewHand(){const num=parseInt(numPlayersRange.value);numPlayersVal.innerText=`${num} 人`;const bigBlind=parseInt(el('raiseAmt').value)||20;bbDisplay.innerText=bigBlind;state.deck=makeDeck();shuffle(state.deck);state.community=[];state.pot=0;state.currentBet=bigBlind;state.minRaise=bigBlind;state.street='preflop';state.finished=false;state.logs=[];logEl.innerHTML='';const arr=[];for(let i=0;i<num;i++)arr.push({id:i,name:i===0?'你':'AI_'+i,chips:2000,hole:[],folded:false,allin:false,bet:0,dealer:i===num-1});state.players=arr;postBlind(1%num,Math.floor(bigBlind/2));postBlind(2%num,bigBlind);state.currentBet=bigBlind;state.turn=(2+1)%num;for(let r=0;r<2;r++)for(let i=0;i<num;i++)state.players[i].hole.push(state.deck.pop());appendLog(`发牌 — BTN:${state.players[num-1].name}，大盲 ${bigBlind}`);renderPlayers();renderCommunity();}
function postBlind(idx,amt){const p=state.players[idx];const pay=Math.min(p.chips,amt);p.chips-=pay;p.bet+=pay;state.pot+=pay;if(p.chips===0)p.allin=true;appendLog(`${p.name} 支付盲注 ${pay}`);}
el('startBtn').addEventListener('click',()=>startNewHand());
numPlayersRange.addEventListener('input',()=>{numPlayersVal.innerText=`${numPlayersRange.value} 人`;});
appendLog('提示：保存为 .html 文件后通过手机浏览器打开。');
renderPlayers();
renderCommunity();
setPot(0);
</script>
</body>
</html>