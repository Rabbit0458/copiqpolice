(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,44369,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0});var n={assign:function(){return l},searchParamsToUrlQuery:function(){return a},urlQueryToSearchParams:function(){return i}};for(var o in n)Object.defineProperty(r,o,{enumerable:!0,get:n[o]});function a(e){let t={};for(let[r,n]of e.entries()){let e=t[r];void 0===e?t[r]=n:Array.isArray(e)?e.push(n):t[r]=[e,n]}return t}function s(e){return"string"==typeof e?e:("number"!=typeof e||isNaN(e))&&"boolean"!=typeof e?"":String(e)}function i(e){let t=new URLSearchParams;for(let[r,n]of Object.entries(e))if(Array.isArray(n))for(let e of n)t.append(r,s(e));else t.set(r,s(n));return t}function l(e,...t){for(let r of t){for(let t of r.keys())e.delete(t);for(let[t,n]of r.entries())e.append(t,n)}return e}},62423,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0});var n={DecodeError:function(){return g},MiddlewareNotFoundError:function(){return w},MissingStaticPage:function(){return x},NormalizeError:function(){return b},PageNotFoundError:function(){return v},SP:function(){return h},ST:function(){return y},WEB_VITALS:function(){return a},execOnce:function(){return s},getDisplayName:function(){return d},getLocationOrigin:function(){return c},getURL:function(){return u},isAbsoluteUrl:function(){return l},isResSent:function(){return f},loadGetInitialProps:function(){return m},normalizeRepeatedSlashes:function(){return p},stringifyError:function(){return E}};for(var o in n)Object.defineProperty(r,o,{enumerable:!0,get:n[o]});let a=["CLS","FCP","FID","INP","LCP","TTFB"];function s(e){let t,r=!1;return(...n)=>(r||(r=!0,t=e(...n)),t)}let i=/^[a-zA-Z][a-zA-Z\d+\-.]*?:/,l=e=>i.test(e);function c(){let{protocol:e,hostname:t,port:r}=window.location;return`${e}//${t}${r?":"+r:""}`}function u(){let{href:e}=window.location,t=c();return e.substring(t.length)}function d(e){return"string"==typeof e?e:e.displayName||e.name||"Unknown"}function f(e){return e.finished||e.headersSent}function p(e){let t=e.split("?");return t[0].replace(/\\/g,"/").replace(/\/\/+/g,"/")+(t[1]?`?${t.slice(1).join("?")}`:"")}async function m(e,t){let r=t.res||t.ctx&&t.ctx.res;if(!e.getInitialProps)return t.ctx&&t.Component?{pageProps:await m(t.Component,t.ctx)}:{};let n=await e.getInitialProps(t);if(r&&f(r))return n;if(!n)throw Object.defineProperty(Error(`"${d(e)}.getInitialProps()" should resolve to an object. But found "${n}" instead.`),"__NEXT_ERROR_CODE",{value:"E1025",enumerable:!1,configurable:!0});return n}let h="u">typeof performance,y=h&&["mark","measure","getEntriesByName"].every(e=>"function"==typeof performance[e]);class g extends Error{}class b extends Error{}class v extends Error{constructor(e){super(),this.code="ENOENT",this.name="PageNotFoundError",this.message=`Cannot find module for page: ${e}`}}class x extends Error{constructor(e,t){super(),this.message=`Failed to load static file for page: ${e} ${t}`}}class w extends Error{constructor(){super(),this.code="ENOENT",this.message="Cannot find the middleware module"}}function E(e){return JSON.stringify({message:e.message,stack:e.stack})}},98452,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0}),Object.defineProperty(r,"warnOnce",{enumerable:!0,get:function(){return n}});let n=e=>{}},12305,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0});var n={formatUrl:function(){return i},formatWithValidation:function(){return c},urlObjectKeys:function(){return l}};for(var o in n)Object.defineProperty(r,o,{enumerable:!0,get:n[o]});let a=e.r(44066)._(e.r(44369)),s=/https?|ftp|gopher|file/;function i(e){let{auth:t,hostname:r}=e,n=e.protocol||"",o=e.pathname||"",i=e.hash||"",l=e.query||"",c=!1;t=t?encodeURIComponent(t).replace(/%3A/i,":")+"@":"",e.host?c=t+e.host:r&&(c=t+(~r.indexOf(":")?`[${r}]`:r),e.port&&(c+=":"+e.port)),l&&"object"==typeof l&&(l=String(a.urlQueryToSearchParams(l)));let u=e.search||l&&`?${l}`||"";return n&&!n.endsWith(":")&&(n+=":"),e.slashes||(!n||s.test(n))&&!1!==c?(c="//"+(c||""),o&&"/"!==o[0]&&(o="/"+o)):c||(c=""),i&&"#"!==i[0]&&(i="#"+i),u&&"?"!==u[0]&&(u="?"+u),o=o.replace(/[?#]/g,encodeURIComponent),u=u.replace("#","%23"),`${n}${c}${o}${u}${i}`}let l=["auth","hash","host","hostname","href","path","pathname","port","protocol","query","search","slashes"];function c(e){return i(e)}},30154,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0}),Object.defineProperty(r,"useMergedRef",{enumerable:!0,get:function(){return o}});let n=e.r(36859);function o(e,t){let r=(0,n.useRef)(null),o=(0,n.useRef)(null);return(0,n.useCallback)(n=>{if(null===n){let e=r.current;e&&(r.current=null,e());let t=o.current;t&&(o.current=null,t())}else e&&(r.current=a(e,n)),t&&(o.current=a(t,n))},[e,t])}function a(e,t){if("function"!=typeof e)return e.current=t,()=>{e.current=null};{let r=e(t);return"function"==typeof r?r:()=>e(null)}}("function"==typeof r.default||"object"==typeof r.default&&null!==r.default)&&void 0===r.default.__esModule&&(Object.defineProperty(r.default,"__esModule",{value:!0}),Object.assign(r.default,r),t.exports=r.default)},45540,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0}),Object.defineProperty(r,"isLocalURL",{enumerable:!0,get:function(){return a}});let n=e.r(62423),o=e.r(29658);function a(e){if(!(0,n.isAbsoluteUrl)(e))return!0;try{let t=(0,n.getLocationOrigin)(),r=new URL(e,t);return r.origin===t&&(0,o.hasBasePath)(r.pathname)}catch(e){return!1}}},97327,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0}),Object.defineProperty(r,"errorOnce",{enumerable:!0,get:function(){return n}});let n=e=>{}},39742,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0});var n={default:function(){return g},useLinkStatus:function(){return v}};for(var o in n)Object.defineProperty(r,o,{enumerable:!0,get:n[o]});let a=e.r(44066),s=e.r(57692),i=a._(e.r(36859)),l=e.r(12305),c=e.r(37441),u=e.r(30154),d=e.r(62423),f=e.r(51008);e.r(98452);let p=e.r(61105),m=e.r(18840),h=e.r(45540),y=e.r(72068);function g(t){var r,n;let o,a,g,[v,x]=(0,i.useOptimistic)(m.IDLE_LINK_STATUS),w=(0,i.useRef)(null),{href:E,as:k,children:C,prefetch:j=null,passHref:S,replace:P,shallow:T,scroll:O,onClick:N,onMouseEnter:_,onTouchStart:$,legacyBehavior:L=!1,onNavigate:A,transitionTypes:I,ref:M,unstable_dynamicOnHover:R,...D}=t;o=C,L&&("string"==typeof o||"number"==typeof o)&&(o=(0,s.jsx)("a",{children:o}));let U=i.default.useContext(c.AppRouterContext),F=!1!==j,z=!1!==j?null===(n=j)||"auto"===n?y.FetchStrategy.PPR:y.FetchStrategy.Full:y.FetchStrategy.PPR,B="string"==typeof(r=k||E)?r:(0,l.formatUrl)(r);if(L){if(o?.$$typeof===Symbol.for("react.lazy"))throw Object.defineProperty(Error("`<Link legacyBehavior>` received a direct child that is either a Server Component, or JSX that was loaded with React.lazy(). This is not supported. Either remove legacyBehavior, or make the direct child a Client Component that renders the Link's `<a>` tag."),"__NEXT_ERROR_CODE",{value:"E863",enumerable:!1,configurable:!0});a=i.default.Children.only(o)}let K=L?a&&"object"==typeof a&&a.ref:M,q=i.default.useCallback(e=>(null!==U&&(w.current=(0,m.mountLinkInstance)(e,B,U,z,F,x)),()=>{w.current&&((0,m.unmountLinkForCurrentNavigation)(w.current),w.current=null),(0,m.unmountPrefetchableInstance)(e)}),[F,B,U,z,x]),H={ref:(0,u.useMergedRef)(q,K),onClick(t){L||"function"!=typeof N||N(t),L&&a.props&&"function"==typeof a.props.onClick&&a.props.onClick(t),!U||t.defaultPrevented||function(t,r,n,o,a,s,l){if("u">typeof window){let c,{nodeName:u}=t.currentTarget;if("A"===u.toUpperCase()&&((c=t.currentTarget.getAttribute("target"))&&"_self"!==c||t.metaKey||t.ctrlKey||t.shiftKey||t.altKey||t.nativeEvent&&2===t.nativeEvent.which)||t.currentTarget.hasAttribute("download"))return;if(!(0,h.isLocalURL)(r)){o&&(t.preventDefault(),location.replace(r));return}if(t.preventDefault(),s){let e=!1;if(s({preventDefault:()=>{e=!0}}),e)return}let{dispatchNavigateAction:d}=e.r(45273);i.default.startTransition(()=>{d(r,o?"replace":"push",!1===a?p.ScrollBehavior.NoScroll:p.ScrollBehavior.Default,n.current,l)})}}(t,B,w,P,O,A,I)},onMouseEnter(e){L||"function"!=typeof _||_(e),L&&a.props&&"function"==typeof a.props.onMouseEnter&&a.props.onMouseEnter(e),U&&F&&(0,m.onNavigationIntent)(e.currentTarget,!0===R)},onTouchStart:function(e){L||"function"!=typeof $||$(e),L&&a.props&&"function"==typeof a.props.onTouchStart&&a.props.onTouchStart(e),U&&F&&(0,m.onNavigationIntent)(e.currentTarget,!0===R)}};return(0,d.isAbsoluteUrl)(B)?H.href=B:L&&!S&&("a"!==a.type||"href"in a.props)||(H.href=(0,f.addBasePath)(B)),g=L?i.default.cloneElement(a,H):(0,s.jsx)("a",{...D,...H,children:o}),(0,s.jsx)(b.Provider,{value:v,children:g})}e.r(97327);let b=(0,i.createContext)(m.IDLE_LINK_STATUS),v=()=>(0,i.useContext)(b);("function"==typeof r.default||"object"==typeof r.default&&null!==r.default)&&void 0===r.default.__esModule&&(Object.defineProperty(r.default,"__esModule",{value:!0}),Object.assign(r.default,r),t.exports=r.default)},21957,e=>{"use strict";var t=e.i(36859),r=(e,t,r,n,o,a,s,i)=>{let l=document.documentElement,c=["light","dark"];function u(t){var r;(Array.isArray(e)?e:[e]).forEach(e=>{let r="class"===e,n=r&&a?o.map(e=>a[e]||e):o;r?(l.classList.remove(...n),l.classList.add(a&&a[t]?a[t]:t)):l.setAttribute(e,t)}),r=t,i&&c.includes(r)&&(l.style.colorScheme=r)}if(n)u(n);else try{let e=localStorage.getItem(t)||r,n=s&&"system"===e?window.matchMedia("(prefers-color-scheme: dark)").matches?"dark":"light":e;u(n)}catch(e){}},n=["light","dark"],o="(prefers-color-scheme: dark)",a="u"<typeof window,s=t.createContext(void 0),i={setTheme:e=>{},themes:[]},l=["light","dark"],c=({forcedTheme:e,disableTransitionOnChange:r=!1,enableSystem:a=!0,enableColorScheme:i=!0,storageKey:c="theme",themes:m=l,defaultTheme:h=a?"system":"light",attribute:y="data-theme",value:g,children:b,nonce:v,scriptProps:x})=>{let[w,E]=t.useState(()=>d(c,h)),[k,C]=t.useState(()=>"system"===w?p():w),j=g?Object.values(g):m,S=t.useCallback(e=>{let t=e;if(!t)return;"system"===e&&a&&(t=p());let o=g?g[t]:t,s=r?f(v):null,l=document.documentElement,c=e=>{"class"===e?(l.classList.remove(...j),o&&l.classList.add(o)):e.startsWith("data-")&&(o?l.setAttribute(e,o):l.removeAttribute(e))};if(Array.isArray(y)?y.forEach(c):c(y),i){let e=n.includes(h)?h:null,r=n.includes(t)?t:e;l.style.colorScheme=r}null==s||s()},[v]),P=t.useCallback(e=>{let t="function"==typeof e?e(w):e;E(t);try{localStorage.setItem(c,t)}catch(e){}},[w]),T=t.useCallback(t=>{C(p(t)),"system"===w&&a&&!e&&S("system")},[w,e]);t.useEffect(()=>{let e=window.matchMedia(o);return e.addListener(T),T(e),()=>e.removeListener(T)},[T]),t.useEffect(()=>{let e=e=>{e.key===c&&(e.newValue?E(e.newValue):P(h))};return window.addEventListener("storage",e),()=>window.removeEventListener("storage",e)},[P]),t.useEffect(()=>{S(null!=e?e:w)},[e,w]);let O=t.useMemo(()=>({theme:w,setTheme:P,forcedTheme:e,resolvedTheme:"system"===w?k:w,themes:a?[...m,"system"]:m,systemTheme:a?k:void 0}),[w,P,e,k,a,m]);return t.createElement(s.Provider,{value:O},t.createElement(u,{forcedTheme:e,storageKey:c,attribute:y,enableSystem:a,enableColorScheme:i,defaultTheme:h,value:g,themes:m,nonce:v,scriptProps:x}),b)},u=t.memo(({forcedTheme:e,storageKey:n,attribute:o,enableSystem:a,enableColorScheme:s,defaultTheme:i,value:l,themes:c,nonce:u,scriptProps:d})=>{let f=JSON.stringify([o,n,i,e,c,l,a,s]).slice(1,-1);return t.createElement("script",{...d,suppressHydrationWarning:!0,nonce:"u"<typeof window?u:"",dangerouslySetInnerHTML:{__html:`(${r.toString()})(${f})`}})}),d=(e,t)=>{let r;if(!a){try{r=localStorage.getItem(e)||void 0}catch(e){}return r||t}},f=e=>{let t=document.createElement("style");return e&&t.setAttribute("nonce",e),t.appendChild(document.createTextNode("*,*::before,*::after{-webkit-transition:none!important;-moz-transition:none!important;-o-transition:none!important;-ms-transition:none!important;transition:none!important}")),document.head.appendChild(t),()=>{window.getComputedStyle(document.body),setTimeout(()=>{document.head.removeChild(t)},1)}},p=e=>(e||(e=window.matchMedia(o)),e.matches?"dark":"light");e.s(["ThemeProvider",0,e=>t.useContext(s)?t.createElement(t.Fragment,null,e.children):t.createElement(c,{...e}),"useTheme",0,()=>{var e;return null!=(e=t.useContext(s))?e:i}])},98992,e=>{"use strict";let t,r;var n,o=e.i(36859);let a={data:""},s=/(?:([\u0080-\uFFFF\w-%@]+) *:? *([^{;]+?);|([^;}{]*?) *{)|(}\s*)/g,i=/\/\*[^]*?\*\/|  +/g,l=/\n+/g,c=(e,t)=>{let r="",n="",o="";for(let a in e){let s=e[a];"@"==a[0]?"i"==a[1]?r=a+" "+s+";":n+="f"==a[1]?c(s,a):a+"{"+c(s,"k"==a[1]?"":t)+"}":"object"==typeof s?n+=c(s,t?t.replace(/([^,])+/g,e=>a.replace(/([^,]*:\S+\([^)]*\))|([^,])+/g,t=>/&/.test(t)?t.replace(/&/g,e):e?e+" "+t:t)):a):null!=s&&(a="-"==a[1]?a:a.replace(/[A-Z]/g,"-$&").toLowerCase(),o+=c.p?c.p(a,s):a+":"+s+";")}return r+(t&&o?t+"{"+o+"}":o)+n},u={},d=e=>{if("object"==typeof e){let t="";for(let r in e)t+=r+d(e[r]);return t}return e};function f(e){let t,r,n=this||{},o=e.call?e(n.p):e;return((e,t,r,n,o)=>{var a;let f=d(e),p=u[f]||(u[f]=(e=>{let t=0,r=11;for(;t<e.length;)r=101*r+e.charCodeAt(t++)>>>0;return"go"+r})(f));if(!u[p]){let t=f!==e?e:(e=>{let t,r,n=[{}];for(;t=s.exec(e.replace(i,""));)t[4]?n.shift():t[3]?(r=t[3].replace(l," ").trim(),n.unshift(n[0][r]=n[0][r]||{})):n[0][t[1]]=t[2].replace(l," ").trim();return n[0]})(e);u[p]=c(o?{["@keyframes "+p]:t}:t,r?"":"."+p)}let m=r&&u.g;return r&&(u.g=u[p]),a=u[p],m?t.data=t.data.replace(m,a):-1===t.data.indexOf(a)&&(t.data=n?a+t.data:t.data+a),p})(o.unshift?o.raw?(t=[].slice.call(arguments,1),r=n.p,o.reduce((e,n,o)=>{let a=t[o];if(a&&a.call){let e=a(r),t=e&&e.props&&e.props.className||/^go/.test(e)&&e;a=t?"."+t:e&&"object"==typeof e?e.props?"":c(e,""):!1===e?"":e}return e+n+(null==a?"":a)},"")):o.reduce((e,t)=>Object.assign(e,t&&t.call?t(n.p):t),{}):o,(e=>{if("object"==typeof window){let t=(e?e.querySelector("#_goober"):window._goober)||Object.assign(document.createElement("style"),{innerHTML:" ",id:"_goober"});return t.nonce=window.__nonce__,t.parentNode||(e||document.head).appendChild(t),t.firstChild}return e||a})(n.target),n.g,n.o,n.k)}f.bind({g:1});let p,m,h,y=f.bind({k:1});function g(e,t){let r=this||{};return function(){let n=arguments;function o(a,s){let i=Object.assign({},a),l=i.className||o.className;r.p=Object.assign({theme:m&&m()},i),r.o=/go\d/.test(l),i.className=f.apply(r,n)+(l?" "+l:""),t&&(i.ref=s);let c=e;return e[0]&&(c=i.as||e,delete i.as),h&&c[0]&&h(i),p(c,i)}return t?t(o):o}}var b=(e,t)=>"function"==typeof e?e(t):e,v=(t=0,()=>(++t).toString()),x=()=>{if(void 0===r&&"u">typeof window){let e=matchMedia("(prefers-reduced-motion: reduce)");r=!e||e.matches}return r},w="default",E=(e,t)=>{let{toastLimit:r}=e.settings;switch(t.type){case 0:return{...e,toasts:[t.toast,...e.toasts].slice(0,r)};case 1:return{...e,toasts:e.toasts.map(e=>e.id===t.toast.id?{...e,...t.toast}:e)};case 2:let{toast:n}=t;return E(e,{type:+!!e.toasts.find(e=>e.id===n.id),toast:n});case 3:let{toastId:o}=t;return{...e,toasts:e.toasts.map(e=>e.id===o||void 0===o?{...e,dismissed:!0,visible:!1}:e)};case 4:return void 0===t.toastId?{...e,toasts:[]}:{...e,toasts:e.toasts.filter(e=>e.id!==t.toastId)};case 5:return{...e,pausedAt:t.time};case 6:let a=t.time-(e.pausedAt||0);return{...e,pausedAt:void 0,toasts:e.toasts.map(e=>({...e,pauseDuration:e.pauseDuration+a}))}}},k=[],C={toasts:[],pausedAt:void 0,settings:{toastLimit:20}},j={},S=(e,t=w)=>{j[t]=E(j[t]||C,e),k.forEach(([e,r])=>{e===t&&r(j[t])})},P=e=>Object.keys(j).forEach(t=>S(e,t)),T=(e=w)=>t=>{S(t,e)},O={blank:4e3,error:4e3,success:2e3,loading:1/0,custom:4e3},N=e=>(t,r)=>{let n,o=((e,t="blank",r)=>({createdAt:Date.now(),visible:!0,dismissed:!1,type:t,ariaProps:{role:"status","aria-live":"polite"},message:e,pauseDuration:0,...r,id:(null==r?void 0:r.id)||v()}))(t,e,r);return T(o.toasterId||(n=o.id,Object.keys(j).find(e=>j[e].toasts.some(e=>e.id===n))))({type:2,toast:o}),o.id},_=(e,t)=>N("blank")(e,t);_.error=N("error"),_.success=N("success"),_.loading=N("loading"),_.custom=N("custom"),_.dismiss=(e,t)=>{let r={type:3,toastId:e};t?T(t)(r):P(r)},_.dismissAll=e=>_.dismiss(void 0,e),_.remove=(e,t)=>{let r={type:4,toastId:e};t?T(t)(r):P(r)},_.removeAll=e=>_.remove(void 0,e),_.promise=(e,t,r)=>{let n=_.loading(t.loading,{...r,...null==r?void 0:r.loading});return"function"==typeof e&&(e=e()),e.then(e=>{let o=t.success?b(t.success,e):void 0;return o?_.success(o,{id:n,...r,...null==r?void 0:r.success}):_.dismiss(n),e}).catch(e=>{let o=t.error?b(t.error,e):void 0;o?_.error(o,{id:n,...r,...null==r?void 0:r.error}):_.dismiss(n)}),e};var $=1e3,L=y`
from {
  transform: scale(0) rotate(45deg);
	opacity: 0;
}
to {
 transform: scale(1) rotate(45deg);
  opacity: 1;
}`,A=y`
from {
  transform: scale(0);
  opacity: 0;
}
to {
  transform: scale(1);
  opacity: 1;
}`,I=y`
from {
  transform: scale(0) rotate(90deg);
	opacity: 0;
}
to {
  transform: scale(1) rotate(90deg);
	opacity: 1;
}`,M=g("div")`
  width: 20px;
  opacity: 0;
  height: 20px;
  border-radius: 10px;
  background: ${e=>e.primary||"#ff4b4b"};
  position: relative;
  transform: rotate(45deg);

  animation: ${L} 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275)
    forwards;
  animation-delay: 100ms;

  &:after,
  &:before {
    content: '';
    animation: ${A} 0.15s ease-out forwards;
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
    animation: ${I} 0.15s ease-out forwards;
    animation-delay: 180ms;
    transform: rotate(90deg);
  }
`,R=y`
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
`,D=g("div")`
  width: 12px;
  height: 12px;
  box-sizing: border-box;
  border: 2px solid;
  border-radius: 100%;
  border-color: ${e=>e.secondary||"#e0e0e0"};
  border-right-color: ${e=>e.primary||"#616161"};
  animation: ${R} 1s linear infinite;
`,U=y`
from {
  transform: scale(0) rotate(45deg);
	opacity: 0;
}
to {
  transform: scale(1) rotate(45deg);
	opacity: 1;
}`,F=y`
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
}`,z=g("div")`
  width: 20px;
  opacity: 0;
  height: 20px;
  border-radius: 10px;
  background: ${e=>e.primary||"#61d345"};
  position: relative;
  transform: rotate(45deg);

  animation: ${U} 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275)
    forwards;
  animation-delay: 100ms;
  &:after {
    content: '';
    box-sizing: border-box;
    animation: ${F} 0.2s ease-out forwards;
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
`,K=g("div")`
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  min-width: 20px;
  min-height: 20px;
`,q=y`
from {
  transform: scale(0.6);
  opacity: 0.4;
}
to {
  transform: scale(1);
  opacity: 1;
}`,H=g("div")`
  position: relative;
  transform: scale(0.6);
  opacity: 0.4;
  min-width: 20px;
  animation: ${q} 0.3s 0.12s cubic-bezier(0.175, 0.885, 0.32, 1.275)
    forwards;
`,W=({toast:e})=>{let{icon:t,type:r,iconTheme:n}=e;return void 0!==t?"string"==typeof t?o.createElement(H,null,t):t:"blank"===r?null:o.createElement(K,null,o.createElement(D,{...n}),"loading"!==r&&o.createElement(B,null,"error"===r?o.createElement(M,{...n}):o.createElement(z,{...n})))},J=g("div")`
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
`,V=g("div")`
  display: flex;
  justify-content: center;
  margin: 4px 10px;
  color: inherit;
  flex: 1 1 auto;
  white-space: pre-line;
`,Q=o.memo(({toast:e,position:t,style:r,children:n})=>{let a=e.height?((e,t)=>{let r=e.includes("top")?1:-1,[n,o]=x()?["0%{opacity:0;} 100%{opacity:1;}","0%{opacity:1;} 100%{opacity:0;}"]:[`
0% {transform: translate3d(0,${-200*r}%,0) scale(.6); opacity:.5;}
100% {transform: translate3d(0,0,0) scale(1); opacity:1;}
`,`
0% {transform: translate3d(0,0,-1px) scale(1); opacity:1;}
100% {transform: translate3d(0,${-150*r}%,-1px) scale(.6); opacity:0;}
`];return{animation:t?`${y(n)} 0.35s cubic-bezier(.21,1.02,.73,1) forwards`:`${y(o)} 0.4s forwards cubic-bezier(.06,.71,.55,1)`}})(e.position||t||"top-center",e.visible):{opacity:0},s=o.createElement(W,{toast:e}),i=o.createElement(V,{...e.ariaProps},b(e.message,e));return o.createElement(J,{className:e.className,style:{...a,...r,...e.style}},"function"==typeof n?n({icon:s,message:i}):o.createElement(o.Fragment,null,s,i))});n=o.createElement,c.p=void 0,p=n,m=void 0,h=void 0;var X=({id:e,className:t,style:r,onHeightUpdate:n,children:a})=>{let s=o.useCallback(t=>{if(t){let r=()=>{n(e,t.getBoundingClientRect().height)};r(),new MutationObserver(r).observe(t,{subtree:!0,childList:!0,characterData:!0})}},[e,n]);return o.createElement("div",{ref:s,className:t,style:r},a)},Z=f`
  z-index: 9999;
  > * {
    pointer-events: auto;
  }
`;e.s(["Toaster",0,({reverseOrder:e,position:t="top-center",toastOptions:r,gutter:n,children:a,toasterId:s,containerStyle:i,containerClassName:l})=>{let{toasts:c,handlers:u}=((e,t="default")=>{let{toasts:r,pausedAt:n}=((e={},t=w)=>{let[r,n]=(0,o.useState)(j[t]||C),a=(0,o.useRef)(j[t]);(0,o.useEffect)(()=>(a.current!==j[t]&&n(j[t]),k.push([t,n]),()=>{let e=k.findIndex(([e])=>e===t);e>-1&&k.splice(e,1)}),[t]);let s=r.toasts.map(t=>{var r,n,o;return{...e,...e[t.type],...t,removeDelay:t.removeDelay||(null==(r=e[t.type])?void 0:r.removeDelay)||(null==e?void 0:e.removeDelay),duration:t.duration||(null==(n=e[t.type])?void 0:n.duration)||(null==e?void 0:e.duration)||O[t.type],style:{...e.style,...null==(o=e[t.type])?void 0:o.style,...t.style}}});return{...r,toasts:s}})(e,t),a=(0,o.useRef)(new Map).current,s=(0,o.useCallback)((e,t=$)=>{if(a.has(e))return;let r=setTimeout(()=>{a.delete(e),i({type:4,toastId:e})},t);a.set(e,r)},[]);(0,o.useEffect)(()=>{if(n)return;let e=Date.now(),o=r.map(r=>{if(r.duration===1/0)return;let n=(r.duration||0)+r.pauseDuration-(e-r.createdAt);if(n<0){r.visible&&_.dismiss(r.id);return}return setTimeout(()=>_.dismiss(r.id,t),n)});return()=>{o.forEach(e=>e&&clearTimeout(e))}},[r,n,t]);let i=(0,o.useCallback)(T(t),[t]),l=(0,o.useCallback)(()=>{i({type:5,time:Date.now()})},[i]),c=(0,o.useCallback)((e,t)=>{i({type:1,toast:{id:e,height:t}})},[i]),u=(0,o.useCallback)(()=>{n&&i({type:6,time:Date.now()})},[n,i]),d=(0,o.useCallback)((e,t)=>{let{reverseOrder:n=!1,gutter:o=8,defaultPosition:a}=t||{},s=r.filter(t=>(t.position||a)===(e.position||a)&&t.height),i=s.findIndex(t=>t.id===e.id),l=s.filter((e,t)=>t<i&&e.visible).length;return s.filter(e=>e.visible).slice(...n?[l+1]:[0,l]).reduce((e,t)=>e+(t.height||0)+o,0)},[r]);return(0,o.useEffect)(()=>{r.forEach(e=>{if(e.dismissed)s(e.id,e.removeDelay);else{let t=a.get(e.id);t&&(clearTimeout(t),a.delete(e.id))}})},[r,s]),{toasts:r,handlers:{updateHeight:c,startPause:l,endPause:u,calculateOffset:d}}})(r,s);return o.createElement("div",{"data-rht-toaster":s||"",style:{position:"fixed",zIndex:9999,top:16,left:16,right:16,bottom:16,pointerEvents:"none",...i},className:l,onMouseEnter:u.startPause,onMouseLeave:u.endPause},c.map(r=>{let s,i,l=r.position||t,c=u.calculateOffset(r,{reverseOrder:e,gutter:n,defaultPosition:t}),d=(s=l.includes("top"),i=l.includes("center")?{justifyContent:"center"}:l.includes("right")?{justifyContent:"flex-end"}:{},{left:0,right:0,display:"flex",position:"absolute",transition:x()?void 0:"all 230ms cubic-bezier(.21,1.02,.73,1)",transform:`translateY(${c*(s?1:-1)}px)`,...s?{top:0}:{bottom:0},...i});return o.createElement(X,{id:r.id,key:r.id,onHeightUpdate:u.updateHeight,className:r.visible?Z:"",style:d},"custom"===r.type?b(r.message,r):a?a(r):o.createElement(Q,{toast:r,position:l}))}))},"default",0,_],98992)},51713,e=>{"use strict";var t=e.i(57692),r=e.i(36859),n=e.i(39742);let o="copiq_consent";function a(e,t,r){if("u"<typeof document)return;let n="https:"===location.protocol?"; Secure":"";document.cookie=`${e}=${encodeURIComponent(t)}; path=/; max-age=${r}; SameSite=Lax${n}`}function s(){a(o,"",0),window.dispatchEvent(new CustomEvent("copiq:consent-reset"))}function i({title:e,desc:r,checked:n,disabled:o,onChange:a}){return(0,t.jsxs)("label",{className:`flex items-start gap-3 ${o?"opacity-60":"cursor-pointer"}`,children:[(0,t.jsx)("input",{type:"checkbox",checked:n,disabled:o,onChange:e=>a?.(e.target.checked),className:"mt-0.5 h-4 w-4 shrink-0"}),(0,t.jsxs)("span",{className:"min-w-0",children:[(0,t.jsxs)("span",{className:"block text-sm font-medium",children:[e,o&&(0,t.jsx)("span",{className:"ml-2 text-[11px] font-normal text-[var(--on-surface-faint)]",children:"toujours actifs"})]}),(0,t.jsx)("span",{className:"block text-xs text-[var(--on-surface-muted)]",children:r})]})]})}e.s(["ConsentLink",0,function({className:e=""}){return(0,t.jsx)("button",{onClick:s,className:`text-sm text-[var(--on-surface-muted)] underline-offset-2 hover:underline ${e}`,children:"Gérer mes cookies"})},"CookieBanner",0,function(){let[e,s]=(0,r.useState)(!1),[l,c]=(0,r.useState)(!1),[u,d]=(0,r.useState)({analytics:!1,marketing:!1});if((0,r.useEffect)(()=>{null===function(){let e=function(e){if("u"<typeof document)return null;let t=document.cookie.split("; ").find(t=>t.startsWith(`${e}=`));return t?decodeURIComponent(t.slice(e.length+1)):null}(o);if(!e)return null;try{let t=JSON.parse(e);if(1!==t.version||!t.categories)return null;return{...t,categories:{...t.categories,necessary:!0}}}catch{return null}}()&&s(!0);let e=()=>{c(!1),d({analytics:!1,marketing:!1}),s(!0)};return window.addEventListener("copiq:consent-reset",e),()=>window.removeEventListener("copiq:consent-reset",e)},[]),!e)return null;function f(e){let t;a(o,JSON.stringify(t={version:1,date:new Date().toISOString(),categories:{necessary:!0,...e}}),33696e3),window.dispatchEvent(new CustomEvent("copiq:consent",{detail:t.categories})),s(!1)}return(0,t.jsx)("div",{role:"dialog","aria-modal":"false","aria-labelledby":"cookie-title","aria-describedby":"cookie-desc",className:"fixed inset-x-0 bottom-0 z-[100] p-3 sm:p-4",children:(0,t.jsxs)("div",{className:"mx-auto max-w-3xl rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-5 shadow-2xl",children:[(0,t.jsx)("h2",{id:"cookie-title",className:"text-base font-semibold",children:"Cookies et données"}),(0,t.jsxs)("p",{id:"cookie-desc",className:"mt-2 text-sm leading-relaxed text-[var(--on-surface-muted)]",children:["Nous utilisons des cookies strictement nécessaires au fonctionnement du site (connexion, sécurité). Avec ton accord, nous pouvons aussi mesurer l'audience pour améliorer la préparation au concours. Tu peux refuser sans conséquence sur ton utilisation du site."," ",(0,t.jsx)(n.default,{href:"/privacy",className:"font-medium text-[var(--brand)] underline underline-offset-2",children:"Politique de confidentialité"})]}),l&&(0,t.jsxs)("div",{className:"mt-4 space-y-2.5 rounded-xl border border-[var(--outline-variant)] p-3.5",children:[(0,t.jsx)(i,{title:"Strictement nécessaires",desc:"Session, authentification, sécurité. Indispensables au fonctionnement du site.",checked:!0,disabled:!0}),(0,t.jsx)(i,{title:"Mesure d'audience",desc:"Pages consultées et parcours, de façon agrégée, pour améliorer le contenu.",checked:u.analytics,onChange:e=>d({...u,analytics:e})}),(0,t.jsx)(i,{title:"Publicité",desc:"Personnalisation des annonces et mesure des campagnes.",checked:u.marketing,onChange:e=>d({...u,marketing:e})})]}),(0,t.jsxs)("div",{className:"mt-4 flex flex-col gap-2 sm:flex-row",children:[(0,t.jsx)("button",{onClick:()=>f({analytics:!1,marketing:!1}),className:"flex-1 rounded-xl border border-[var(--outline)] px-4 py-2.5 text-sm font-semibold transition hover:bg-[var(--surface-container)]",children:"Tout refuser"}),l?(0,t.jsx)("button",{onClick:()=>f(u),className:"flex-1 rounded-xl border border-[var(--outline)] px-4 py-2.5 text-sm font-semibold transition hover:bg-[var(--surface-container)]",children:"Enregistrer mes choix"}):(0,t.jsx)("button",{onClick:()=>c(!0),className:"flex-1 rounded-xl border border-[var(--outline)] px-4 py-2.5 text-sm font-semibold transition hover:bg-[var(--surface-container)]",children:"Personnaliser"}),(0,t.jsx)("button",{onClick:()=>f({analytics:!0,marketing:!0}),className:"flex-1 rounded-xl bg-[var(--brand)] px-4 py-2.5 text-sm font-semibold text-white transition hover:brightness-110",children:"Tout accepter"})]})]})})}],51713)},1661,e=>{"use strict";var t=e.i(57692),r=e.i(21957),n=e.i(98992),o=e.i(51713);e.s(["Providers",0,function({children:e}){return(0,t.jsxs)(r.ThemeProvider,{attribute:"class",defaultTheme:"system",enableSystem:!0,disableTransitionOnChange:!1,children:[e,(0,t.jsx)(n.Toaster,{position:"top-right",toastOptions:{duration:4e3,style:{background:"var(--surface-container)",color:"var(--on-surface)",border:"1px solid var(--outline)",borderRadius:"12px",fontSize:"0.875rem",fontFamily:"var(--font-instrument-sans, system-ui)"},success:{iconTheme:{primary:"#22C55E",secondary:"#fff"}},error:{iconTheme:{primary:"#EF4444",secondary:"#fff"}}}}),(0,t.jsx)(o.CookieBanner,{})]})}])}]);