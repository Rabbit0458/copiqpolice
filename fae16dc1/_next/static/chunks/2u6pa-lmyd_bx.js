(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,33525,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0}),Object.defineProperty(r,"warnOnce",{enumerable:!0,get:function(){return o}});let o=e=>{}},18967,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0});var o={DecodeError:function(){return g},MiddlewareNotFoundError:function(){return w},MissingStaticPage:function(){return x},NormalizeError:function(){return b},PageNotFoundError:function(){return v},SP:function(){return y},ST:function(){return h},WEB_VITALS:function(){return n},execOnce:function(){return s},getDisplayName:function(){return u},getLocationOrigin:function(){return c},getURL:function(){return d},isAbsoluteUrl:function(){return l},isResSent:function(){return m},loadGetInitialProps:function(){return p},normalizeRepeatedSlashes:function(){return f},stringifyError:function(){return E}};for(var a in o)Object.defineProperty(r,a,{enumerable:!0,get:o[a]});let n=["CLS","FCP","FID","INP","LCP","TTFB"];function s(e){let t,r=!1;return(...o)=>(r||(r=!0,t=e(...o)),t)}let i=/^[a-zA-Z][a-zA-Z\d+\-.]*?:/,l=e=>i.test(e);function c(){let{protocol:e,hostname:t,port:r}=window.location;return`${e}//${t}${r?":"+r:""}`}function d(){let{href:e}=window.location,t=c();return e.substring(t.length)}function u(e){return"string"==typeof e?e:e.displayName||e.name||"Unknown"}function m(e){return e.finished||e.headersSent}function f(e){let t=e.split("?");return t[0].replace(/\\/g,"/").replace(/\/\/+/g,"/")+(t[1]?`?${t.slice(1).join("?")}`:"")}async function p(e,t){let r=t.res||t.ctx&&t.ctx.res;if(!e.getInitialProps)return t.ctx&&t.Component?{pageProps:await p(t.Component,t.ctx)}:{};let o=await e.getInitialProps(t);if(r&&m(r))return o;if(!o)throw Object.defineProperty(Error(`"${u(e)}.getInitialProps()" should resolve to an object. But found "${o}" instead.`),"__NEXT_ERROR_CODE",{value:"E1025",enumerable:!1,configurable:!0});return o}let y="u">typeof performance,h=y&&["mark","measure","getEntriesByName"].every(e=>"function"==typeof performance[e]);class g extends Error{}class b extends Error{}class v extends Error{constructor(e){super(),this.code="ENOENT",this.name="PageNotFoundError",this.message=`Cannot find module for page: ${e}`}}class x extends Error{constructor(e,t){super(),this.message=`Failed to load static file for page: ${e} ${t}`}}class w extends Error{constructor(){super(),this.code="ENOENT",this.message="Cannot find the middleware module"}}function E(e){return JSON.stringify({message:e.message,stack:e.stack})}},98183,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0});var o={assign:function(){return l},searchParamsToUrlQuery:function(){return n},urlQueryToSearchParams:function(){return i}};for(var a in o)Object.defineProperty(r,a,{enumerable:!0,get:o[a]});function n(e){let t={};for(let[r,o]of e.entries()){let e=t[r];void 0===e?t[r]=o:Array.isArray(e)?e.push(o):t[r]=[e,o]}return t}function s(e){return"string"==typeof e?e:("number"!=typeof e||isNaN(e))&&"boolean"!=typeof e?"":String(e)}function i(e){let t=new URLSearchParams;for(let[r,o]of Object.entries(e))if(Array.isArray(o))for(let e of o)t.append(r,s(e));else t.set(r,s(o));return t}function l(e,...t){for(let r of t){for(let t of r.keys())e.delete(t);for(let[t,o]of r.entries())e.append(t,o)}return e}},5766,e=>{"use strict";let t,r;var o,a=e.i(71645);let n={data:""},s=/(?:([\u0080-\uFFFF\w-%@]+) *:? *([^{;]+?);|([^;}{]*?) *{)|(}\s*)/g,i=/\/\*[^]*?\*\/|  +/g,l=/\n+/g,c=(e,t)=>{let r="",o="",a="";for(let n in e){let s=e[n];"@"==n[0]?"i"==n[1]?r=n+" "+s+";":o+="f"==n[1]?c(s,n):n+"{"+c(s,"k"==n[1]?"":t)+"}":"object"==typeof s?o+=c(s,t?t.replace(/([^,])+/g,e=>n.replace(/([^,]*:\S+\([^)]*\))|([^,])+/g,t=>/&/.test(t)?t.replace(/&/g,e):e?e+" "+t:t)):n):null!=s&&(n="-"==n[1]?n:n.replace(/[A-Z]/g,"-$&").toLowerCase(),a+=c.p?c.p(n,s):n+":"+s+";")}return r+(t&&a?t+"{"+a+"}":a)+o},d={},u=e=>{if("object"==typeof e){let t="";for(let r in e)t+=r+u(e[r]);return t}return e};function m(e){let t,r,o=this||{},a=e.call?e(o.p):e;return((e,t,r,o,a)=>{var n;let m=u(e),f=d[m]||(d[m]=(e=>{let t=0,r=11;for(;t<e.length;)r=101*r+e.charCodeAt(t++)>>>0;return"go"+r})(m));if(!d[f]){let t=m!==e?e:(e=>{let t,r,o=[{}];for(;t=s.exec(e.replace(i,""));)t[4]?o.shift():t[3]?(r=t[3].replace(l," ").trim(),o.unshift(o[0][r]=o[0][r]||{})):o[0][t[1]]=t[2].replace(l," ").trim();return o[0]})(e);d[f]=c(a?{["@keyframes "+f]:t}:t,r?"":"."+f)}let p=r&&d.g;return r&&(d.g=d[f]),n=d[f],p?t.data=t.data.replace(p,n):-1===t.data.indexOf(n)&&(t.data=o?n+t.data:t.data+n),f})(a.unshift?a.raw?(t=[].slice.call(arguments,1),r=o.p,a.reduce((e,o,a)=>{let n=t[a];if(n&&n.call){let e=n(r),t=e&&e.props&&e.props.className||/^go/.test(e)&&e;n=t?"."+t:e&&"object"==typeof e?e.props?"":c(e,""):!1===e?"":e}return e+o+(null==n?"":n)},"")):a.reduce((e,t)=>Object.assign(e,t&&t.call?t(o.p):t),{}):a,(e=>{if("object"==typeof window){let t=(e?e.querySelector("#_goober"):window._goober)||Object.assign(document.createElement("style"),{innerHTML:" ",id:"_goober"});return t.nonce=window.__nonce__,t.parentNode||(e||document.head).appendChild(t),t.firstChild}return e||n})(o.target),o.g,o.o,o.k)}m.bind({g:1});let f,p,y,h=m.bind({k:1});function g(e,t){let r=this||{};return function(){let o=arguments;function a(n,s){let i=Object.assign({},n),l=i.className||a.className;r.p=Object.assign({theme:p&&p()},i),r.o=/go\d/.test(l),i.className=m.apply(r,o)+(l?" "+l:""),t&&(i.ref=s);let c=e;return e[0]&&(c=i.as||e,delete i.as),y&&c[0]&&y(i),f(c,i)}return t?t(a):a}}var b=(e,t)=>"function"==typeof e?e(t):e,v=(t=0,()=>(++t).toString()),x=()=>{if(void 0===r&&"u">typeof window){let e=matchMedia("(prefers-reduced-motion: reduce)");r=!e||e.matches}return r},w="default",E=(e,t)=>{let{toastLimit:r}=e.settings;switch(t.type){case 0:return{...e,toasts:[t.toast,...e.toasts].slice(0,r)};case 1:return{...e,toasts:e.toasts.map(e=>e.id===t.toast.id?{...e,...t.toast}:e)};case 2:let{toast:o}=t;return E(e,{type:+!!e.toasts.find(e=>e.id===o.id),toast:o});case 3:let{toastId:a}=t;return{...e,toasts:e.toasts.map(e=>e.id===a||void 0===a?{...e,dismissed:!0,visible:!1}:e)};case 4:return void 0===t.toastId?{...e,toasts:[]}:{...e,toasts:e.toasts.filter(e=>e.id!==t.toastId)};case 5:return{...e,pausedAt:t.time};case 6:let n=t.time-(e.pausedAt||0);return{...e,pausedAt:void 0,toasts:e.toasts.map(e=>({...e,pauseDuration:e.pauseDuration+n}))}}},T=[],C={toasts:[],pausedAt:void 0,settings:{toastLimit:20}},k={},P=(e,t=w)=>{k[t]=E(k[t]||C,e),T.forEach(([e,r])=>{e===t&&r(k[t])})},O=e=>Object.keys(k).forEach(t=>P(e,t)),S=(e=w)=>t=>{P(t,e)},N={blank:4e3,error:4e3,success:2e3,loading:1/0,custom:4e3},$=e=>(t,r)=>{let o,a=((e,t="blank",r)=>({createdAt:Date.now(),visible:!0,dismissed:!1,type:t,ariaProps:{role:"status","aria-live":"polite"},message:e,pauseDuration:0,...r,id:(null==r?void 0:r.id)||v()}))(t,e,r);return S(a.toasterId||(o=a.id,Object.keys(k).find(e=>k[e].toasts.some(e=>e.id===o))))({type:2,toast:a}),a.id},A=(e,t)=>$("blank")(e,t);A.error=$("error"),A.success=$("success"),A.loading=$("loading"),A.custom=$("custom"),A.dismiss=(e,t)=>{let r={type:3,toastId:e};t?S(t)(r):O(r)},A.dismissAll=e=>A.dismiss(void 0,e),A.remove=(e,t)=>{let r={type:4,toastId:e};t?S(t)(r):O(r)},A.removeAll=e=>A.remove(void 0,e),A.promise=(e,t,r)=>{let o=A.loading(t.loading,{...r,...null==r?void 0:r.loading});return"function"==typeof e&&(e=e()),e.then(e=>{let a=t.success?b(t.success,e):void 0;return a?A.success(a,{id:o,...r,...null==r?void 0:r.success}):A.dismiss(o),e}).catch(e=>{let a=t.error?b(t.error,e):void 0;a?A.error(a,{id:o,...r,...null==r?void 0:r.error}):A.dismiss(o)}),e};var j=1e3,I=h`
from {
  transform: scale(0) rotate(45deg);
	opacity: 0;
}
to {
 transform: scale(1) rotate(45deg);
  opacity: 1;
}`,L=h`
from {
  transform: scale(0);
  opacity: 0;
}
to {
  transform: scale(1);
  opacity: 1;
}`,_=h`
from {
  transform: scale(0) rotate(90deg);
	opacity: 0;
}
to {
  transform: scale(1) rotate(90deg);
	opacity: 1;
}`,D=g("div")`
  width: 20px;
  opacity: 0;
  height: 20px;
  border-radius: 10px;
  background: ${e=>e.primary||"#ff4b4b"};
  position: relative;
  transform: rotate(45deg);

  animation: ${I} 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275)
    forwards;
  animation-delay: 100ms;

  &:after,
  &:before {
    content: '';
    animation: ${L} 0.15s ease-out forwards;
    animation-delay: 150ms;
    position: absolute;
    border-radius: 3px;
    opacity: 0;
    background: ${e=>e.secondary||"#fff"};
    bottom: 9px;
    left: 4px;
    height: 2px;
    width: 12px;
  }

  &:before {
    animation: ${_} 0.15s ease-out forwards;
    animation-delay: 180ms;
    transform: rotate(90deg);
  }
`,z=h`
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
`,M=g("div")`
  width: 12px;
  height: 12px;
  box-sizing: border-box;
  border: 2px solid;
  border-radius: 100%;
  border-color: ${e=>e.secondary||"#e0e0e0"};
  border-right-color: ${e=>e.primary||"#616161"};
  animation: ${z} 1s linear infinite;
`,F=h`
from {
  transform: scale(0) rotate(45deg);
	opacity: 0;
}
to {
  transform: scale(1) rotate(45deg);
	opacity: 1;
}`,R=h`
0% {
	height: 0;
	width: 0;
	opacity: 0;
}
40% {
  height: 0;
	width: 6px;
	opacity: 1;
}
100% {
  opacity: 1;
  height: 10px;
}`,U=g("div")`
  width: 20px;
  opacity: 0;
  height: 20px;
  border-radius: 10px;
  background: ${e=>e.primary||"#61d345"};
  position: relative;
  transform: rotate(45deg);

  animation: ${F} 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275)
    forwards;
  animation-delay: 100ms;
  &:after {
    content: '';
    box-sizing: border-box;
    animation: ${R} 0.2s ease-out forwards;
    opacity: 0;
    animation-delay: 200ms;
    position: absolute;
    border-right: 2px solid;
    border-bottom: 2px solid;
    border-color: ${e=>e.secondary||"#fff"};
    bottom: 6px;
    left: 6px;
    height: 10px;
    width: 6px;
  }
`,B=g("div")`
  position: absolute;
`,H=g("div")`
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  min-width: 20px;
  min-height: 20px;
`,K=h`
from {
  transform: scale(0.6);
  opacity: 0.4;
}
to {
  transform: scale(1);
  opacity: 1;
}`,V=g("div")`
  position: relative;
  transform: scale(0.6);
  opacity: 0.4;
  min-width: 20px;
  animation: ${K} 0.3s 0.12s cubic-bezier(0.175, 0.885, 0.32, 1.275)
    forwards;
`,W=({toast:e})=>{let{icon:t,type:r,iconTheme:o}=e;return void 0!==t?"string"==typeof t?a.createElement(V,null,t):t:"blank"===r?null:a.createElement(H,null,a.createElement(M,{...o}),"loading"!==r&&a.createElement(B,null,"error"===r?a.createElement(D,{...o}):a.createElement(U,{...o})))},Z=g("div")`
  display: flex;
  align-items: center;
  background: #fff;
  color: #363636;
  line-height: 1.3;
  will-change: transform;
  box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1), 0 3px 3px rgba(0, 0, 0, 0.05);
  max-width: 350px;
  pointer-events: auto;
  padding: 8px 10px;
  border-radius: 8px;
`,J=g("div")`
  display: flex;
  justify-content: center;
  margin: 4px 10px;
  color: inherit;
  flex: 1 1 auto;
  white-space: pre-line;
`,Q=a.memo(({toast:e,position:t,style:r,children:o})=>{let n=e.height?((e,t)=>{let r=e.includes("top")?1:-1,[o,a]=x()?["0%{opacity:0;} 100%{opacity:1;}","0%{opacity:1;} 100%{opacity:0;}"]:[`
0% {transform: translate3d(0,${-200*r}%,0) scale(.6); opacity:.5;}
100% {transform: translate3d(0,0,0) scale(1); opacity:1;}
`,`
0% {transform: translate3d(0,0,-1px) scale(1); opacity:1;}
100% {transform: translate3d(0,${-150*r}%,-1px) scale(.6); opacity:0;}
`];return{animation:t?`${h(o)} 0.35s cubic-bezier(.21,1.02,.73,1) forwards`:`${h(a)} 0.4s forwards cubic-bezier(.06,.71,.55,1)`}})(e.position||t||"top-center",e.visible):{opacity:0},s=a.createElement(W,{toast:e}),i=a.createElement(J,{...e.ariaProps},b(e.message,e));return a.createElement(Z,{className:e.className,style:{...n,...r,...e.style}},"function"==typeof o?o({icon:s,message:i}):a.createElement(a.Fragment,null,s,i))});o=a.createElement,c.p=void 0,f=o,p=void 0,y=void 0;var q=({id:e,className:t,style:r,onHeightUpdate:o,children:n})=>{let s=a.useCallback(t=>{if(t){let r=()=>{o(e,t.getBoundingClientRect().height)};r(),new MutationObserver(r).observe(t,{subtree:!0,childList:!0,characterData:!0})}},[e,o]);return a.createElement("div",{ref:s,className:t,style:r},n)},G=m`
  z-index: 9999;
  > * {
    pointer-events: auto;
  }
`;e.s(["Toaster",0,({reverseOrder:e,position:t="top-center",toastOptions:r,gutter:o,children:n,toasterId:s,containerStyle:i,containerClassName:l})=>{let{toasts:c,handlers:d}=((e,t="default")=>{let{toasts:r,pausedAt:o}=((e={},t=w)=>{let[r,o]=(0,a.useState)(k[t]||C),n=(0,a.useRef)(k[t]);(0,a.useEffect)(()=>(n.current!==k[t]&&o(k[t]),T.push([t,o]),()=>{let e=T.findIndex(([e])=>e===t);e>-1&&T.splice(e,1)}),[t]);let s=r.toasts.map(t=>{var r,o,a;return{...e,...e[t.type],...t,removeDelay:t.removeDelay||(null==(r=e[t.type])?void 0:r.removeDelay)||(null==e?void 0:e.removeDelay),duration:t.duration||(null==(o=e[t.type])?void 0:o.duration)||(null==e?void 0:e.duration)||N[t.type],style:{...e.style,...null==(a=e[t.type])?void 0:a.style,...t.style}}});return{...r,toasts:s}})(e,t),n=(0,a.useRef)(new Map).current,s=(0,a.useCallback)((e,t=j)=>{if(n.has(e))return;let r=setTimeout(()=>{n.delete(e),i({type:4,toastId:e})},t);n.set(e,r)},[]);(0,a.useEffect)(()=>{if(o)return;let e=Date.now(),a=r.map(r=>{if(r.duration===1/0)return;let o=(r.duration||0)+r.pauseDuration-(e-r.createdAt);if(o<0){r.visible&&A.dismiss(r.id);return}return setTimeout(()=>A.dismiss(r.id,t),o)});return()=>{a.forEach(e=>e&&clearTimeout(e))}},[r,o,t]);let i=(0,a.useCallback)(S(t),[t]),l=(0,a.useCallback)(()=>{i({type:5,time:Date.now()})},[i]),c=(0,a.useCallback)((e,t)=>{i({type:1,toast:{id:e,height:t}})},[i]),d=(0,a.useCallback)(()=>{o&&i({type:6,time:Date.now()})},[o,i]),u=(0,a.useCallback)((e,t)=>{let{reverseOrder:o=!1,gutter:a=8,defaultPosition:n}=t||{},s=r.filter(t=>(t.position||n)===(e.position||n)&&t.height),i=s.findIndex(t=>t.id===e.id),l=s.filter((e,t)=>t<i&&e.visible).length;return s.filter(e=>e.visible).slice(...o?[l+1]:[0,l]).reduce((e,t)=>e+(t.height||0)+a,0)},[r]);return(0,a.useEffect)(()=>{r.forEach(e=>{if(e.dismissed)s(e.id,e.removeDelay);else{let t=n.get(e.id);t&&(clearTimeout(t),n.delete(e.id))}})},[r,s]),{toasts:r,handlers:{updateHeight:c,startPause:l,endPause:d,calculateOffset:u}}})(r,s);return a.createElement("div",{"data-rht-toaster":s||"",style:{position:"fixed",zIndex:9999,top:16,left:16,right:16,bottom:16,pointerEvents:"none",...i},className:l,onMouseEnter:d.startPause,onMouseLeave:d.endPause},c.map(r=>{let s,i,l=r.position||t,c=d.calculateOffset(r,{reverseOrder:e,gutter:o,defaultPosition:t}),u=(s=l.includes("top"),i=l.includes("center")?{justifyContent:"center"}:l.includes("right")?{justifyContent:"flex-end"}:{},{left:0,right:0,display:"flex",position:"absolute",transition:x()?void 0:"all 230ms cubic-bezier(.21,1.02,.73,1)",transform:`translateY(${c*(s?1:-1)}px)`,...s?{top:0}:{bottom:0},...i});return a.createElement(q,{id:r.id,key:r.id,onHeightUpdate:d.updateHeight,className:r.visible?G:"",style:u},"custom"===r.type?b(r.message,r):n?n(r):a.createElement(Q,{toast:r,position:l}))}))},"default",0,A],5766)},63178,e=>{"use strict";var t=e.i(71645),r=(e,t,r,o,a,n,s,i)=>{let l=document.documentElement,c=["light","dark"];function d(t){var r;(Array.isArray(e)?e:[e]).forEach(e=>{let r="class"===e,o=r&&n?a.map(e=>n[e]||e):a;r?(l.classList.remove(...o),l.classList.add(n&&n[t]?n[t]:t)):l.setAttribute(e,t)}),r=t,i&&c.includes(r)&&(l.style.colorScheme=r)}if(o)d(o);else try{let e=localStorage.getItem(t)||r,o=s&&"system"===e?window.matchMedia("(prefers-color-scheme: dark)").matches?"dark":"light":e;d(o)}catch(e){}},o=["light","dark"],a="(prefers-color-scheme: dark)",n="u"<typeof window,s=t.createContext(void 0),i={setTheme:e=>{},themes:[]},l=["light","dark"],c=({forcedTheme:e,disableTransitionOnChange:r=!1,enableSystem:n=!0,enableColorScheme:i=!0,storageKey:c="theme",themes:p=l,defaultTheme:y=n?"system":"light",attribute:h="data-theme",value:g,children:b,nonce:v,scriptProps:x})=>{let[w,E]=t.useState(()=>u(c,y)),[T,C]=t.useState(()=>"system"===w?f():w),k=g?Object.values(g):p,P=t.useCallback(e=>{let t=e;if(!t)return;"system"===e&&n&&(t=f());let a=g?g[t]:t,s=r?m(v):null,l=document.documentElement,c=e=>{"class"===e?(l.classList.remove(...k),a&&l.classList.add(a)):e.startsWith("data-")&&(a?l.setAttribute(e,a):l.removeAttribute(e))};if(Array.isArray(h)?h.forEach(c):c(h),i){let e=o.includes(y)?y:null,r=o.includes(t)?t:e;l.style.colorScheme=r}null==s||s()},[v]),O=t.useCallback(e=>{let t="function"==typeof e?e(w):e;E(t);try{localStorage.setItem(c,t)}catch(e){}},[w]),S=t.useCallback(t=>{C(f(t)),"system"===w&&n&&!e&&P("system")},[w,e]);t.useEffect(()=>{let e=window.matchMedia(a);return e.addListener(S),S(e),()=>e.removeListener(S)},[S]),t.useEffect(()=>{let e=e=>{e.key===c&&(e.newValue?E(e.newValue):O(y))};return window.addEventListener("storage",e),()=>window.removeEventListener("storage",e)},[O]),t.useEffect(()=>{P(null!=e?e:w)},[e,w]);let N=t.useMemo(()=>({theme:w,setTheme:O,forcedTheme:e,resolvedTheme:"system"===w?T:w,themes:n?[...p,"system"]:p,systemTheme:n?T:void 0}),[w,O,e,T,n,p]);return t.createElement(s.Provider,{value:N},t.createElement(d,{forcedTheme:e,storageKey:c,attribute:h,enableSystem:n,enableColorScheme:i,defaultTheme:y,value:g,themes:p,nonce:v,scriptProps:x}),b)},d=t.memo(({forcedTheme:e,storageKey:o,attribute:a,enableSystem:n,enableColorScheme:s,defaultTheme:i,value:l,themes:c,nonce:d,scriptProps:u})=>{let m=JSON.stringify([a,o,i,e,c,l,n,s]).slice(1,-1);return t.createElement("script",{...u,suppressHydrationWarning:!0,nonce:"u"<typeof window?d:"",dangerouslySetInnerHTML:{__html:`(${r.toString()})(${m})`}})}),u=(e,t)=>{let r;if(!n){try{r=localStorage.getItem(e)||void 0}catch(e){}return r||t}},m=e=>{let t=document.createElement("style");return e&&t.setAttribute("nonce",e),t.appendChild(document.createTextNode("*,*::before,*::after{-webkit-transition:none!important;-moz-transition:none!important;-o-transition:none!important;-ms-transition:none!important;transition:none!important}")),document.head.appendChild(t),()=>{window.getComputedStyle(document.body),setTimeout(()=>{document.head.removeChild(t)},1)}},f=e=>(e||(e=window.matchMedia(a)),e.matches?"dark":"light");e.s(["ThemeProvider",0,e=>t.useContext(s)?t.createElement(t.Fragment,null,e.children):t.createElement(c,{...e}),"useTheme",0,()=>{var e;return null!=(e=t.useContext(s))?e:i}])},1661,e=>{"use strict";var t=e.i(43476),r=e.i(63178),o=e.i(5766);e.s(["Providers",0,function({children:e}){return(0,t.jsxs)(r.ThemeProvider,{attribute:"class",defaultTheme:"system",enableSystem:!0,disableTransitionOnChange:!1,children:[e,(0,t.jsx)(o.Toaster,{position:"top-right",toastOptions:{duration:4e3,style:{background:"var(--surface-container)",color:"var(--on-surface)",border:"1px solid var(--outline)",borderRadius:"12px",fontSize:"0.875rem",fontFamily:"var(--font-instrument-sans, system-ui)"},success:{iconTheme:{primary:"#22C55E",secondary:"#fff"}},error:{iconTheme:{primary:"#EF4444",secondary:"#fff"}}}})]})}])}]);