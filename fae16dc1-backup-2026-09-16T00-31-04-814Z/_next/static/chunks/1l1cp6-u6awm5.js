(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,44369,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0});var n={assign:function(){return l},searchParamsToUrlQuery:function(){return a},urlQueryToSearchParams:function(){return s}};for(var o in n)Object.defineProperty(r,o,{enumerable:!0,get:n[o]});function a(e){let t={};for(let[r,n]of e.entries()){let e=t[r];void 0===e?t[r]=n:Array.isArray(e)?e.push(n):t[r]=[e,n]}return t}function i(e){return"string"==typeof e?e:("number"!=typeof e||isNaN(e))&&"boolean"!=typeof e?"":String(e)}function s(e){let t=new URLSearchParams;for(let[r,n]of Object.entries(e))if(Array.isArray(n))for(let e of n)t.append(r,i(e));else t.set(r,i(n));return t}function l(e,...t){for(let r of t){for(let t of r.keys())e.delete(t);for(let[t,n]of r.entries())e.append(t,n)}return e}},62423,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0});var n={DecodeError:function(){return g},MiddlewareNotFoundError:function(){return w},MissingStaticPage:function(){return x},NormalizeError:function(){return b},PageNotFoundError:function(){return v},SP:function(){return h},ST:function(){return y},WEB_VITALS:function(){return a},execOnce:function(){return i},getDisplayName:function(){return d},getLocationOrigin:function(){return c},getURL:function(){return u},isAbsoluteUrl:function(){return l},isResSent:function(){return f},loadGetInitialProps:function(){return m},normalizeRepeatedSlashes:function(){return p},stringifyError:function(){return E}};for(var o in n)Object.defineProperty(r,o,{enumerable:!0,get:n[o]});let a=["CLS","FCP","FID","INP","LCP","TTFB"];function i(e){let t,r=!1;return(...n)=>(r||(r=!0,t=e(...n)),t)}let s=/^[a-zA-Z][a-zA-Z\d+\-.]*?:/,l=e=>s.test(e);function c(){let{protocol:e,hostname:t,port:r}=window.location;return`${e}//${t}${r?":"+r:""}`}function u(){let{href:e}=window.location,t=c();return e.substring(t.length)}function d(e){return"string"==typeof e?e:e.displayName||e.name||"Unknown"}function f(e){return e.finished||e.headersSent}function p(e){let t=e.split("?");return t[0].replace(/\\/g,"/").replace(/\/\/+/g,"/")+(t[1]?`?${t.slice(1).join("?")}`:"")}async function m(e,t){let r=t.res||t.ctx&&t.ctx.res;if(!e.getInitialProps)return t.ctx&&t.Component?{pageProps:await m(t.Component,t.ctx)}:{};let n=await e.getInitialProps(t);if(r&&f(r))return n;if(!n)throw Object.defineProperty(Error(`"${d(e)}.getInitialProps()" should resolve to an object. But found "${n}" instead.`),"__NEXT_ERROR_CODE",{value:"E1025",enumerable:!1,configurable:!0});return n}let h="u">typeof performance,y=h&&["mark","measure","getEntriesByName"].every(e=>"function"==typeof performance[e]);class g extends Error{}class b extends Error{}class v extends Error{constructor(e){super(),this.code="ENOENT",this.name="PageNotFoundError",this.message=`Cannot find module for page: ${e}`}}class x extends Error{constructor(e,t){super(),this.message=`Failed to load static file for page: ${e} ${t}`}}class w extends Error{constructor(){super(),this.code="ENOENT",this.message="Cannot find the middleware module"}}function E(e){return JSON.stringify({message:e.message,stack:e.stack})}},98452,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0}),Object.defineProperty(r,"warnOnce",{enumerable:!0,get:function(){return n}});let n=e=>{}},12305,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0});var n={formatUrl:function(){return s},formatWithValidation:function(){return c},urlObjectKeys:function(){return l}};for(var o in n)Object.defineProperty(r,o,{enumerable:!0,get:n[o]});let a=e.r(44066)._(e.r(44369)),i=/https?|ftp|gopher|file/;function s(e){let{auth:t,hostname:r}=e,n=e.protocol||"",o=e.pathname||"",s=e.hash||"",l=e.query||"",c=!1;t=t?encodeURIComponent(t).replace(/%3A/i,":")+"@":"",e.host?c=t+e.host:r&&(c=t+(~r.indexOf(":")?`[${r}]`:r),e.port&&(c+=":"+e.port)),l&&"object"==typeof l&&(l=String(a.urlQueryToSearchParams(l)));let u=e.search||l&&`?${l}`||"";return n&&!n.endsWith(":")&&(n+=":"),e.slashes||(!n||i.test(n))&&!1!==c?(c="//"+(c||""),o&&"/"!==o[0]&&(o="/"+o)):c||(c=""),s&&"#"!==s[0]&&(s="#"+s),u&&"?"!==u[0]&&(u="?"+u),o=o.replace(/[?#]/g,encodeURIComponent),u=u.replace("#","%23"),`${n}${c}${o}${u}${s}`}let l=["auth","hash","host","hostname","href","path","pathname","port","protocol","query","search","slashes"];function c(e){return s(e)}},30154,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0}),Object.defineProperty(r,"useMergedRef",{enumerable:!0,get:function(){return o}});let n=e.r(36859);function o(e,t){let r=(0,n.useRef)(null),o=(0,n.useRef)(null);return(0,n.useCallback)(n=>{if(null===n){let e=r.current;e&&(r.current=null,e());let t=o.current;t&&(o.current=null,t())}else e&&(r.current=a(e,n)),t&&(o.current=a(t,n))},[e,t])}function a(e,t){if("function"!=typeof e)return e.current=t,()=>{e.current=null};{let r=e(t);return"function"==typeof r?r:()=>e(null)}}("function"==typeof r.default||"object"==typeof r.default&&null!==r.default)&&void 0===r.default.__esModule&&(Object.defineProperty(r.default,"__esModule",{value:!0}),Object.assign(r.default,r),t.exports=r.default)},45540,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0}),Object.defineProperty(r,"isLocalURL",{enumerable:!0,get:function(){return a}});let n=e.r(62423),o=e.r(29658);function a(e){if(!(0,n.isAbsoluteUrl)(e))return!0;try{let t=(0,n.getLocationOrigin)(),r=new URL(e,t);return r.origin===t&&(0,o.hasBasePath)(r.pathname)}catch(e){return!1}}},97327,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0}),Object.defineProperty(r,"errorOnce",{enumerable:!0,get:function(){return n}});let n=e=>{}},39742,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0});var n={default:function(){return g},useLinkStatus:function(){return v}};for(var o in n)Object.defineProperty(r,o,{enumerable:!0,get:n[o]});let a=e.r(44066),i=e.r(57692),s=a._(e.r(36859)),l=e.r(12305),c=e.r(37441),u=e.r(30154),d=e.r(62423),f=e.r(51008);e.r(98452);let p=e.r(61105),m=e.r(18840),h=e.r(45540),y=e.r(72068);function g(t){var r,n;let o,a,g,[v,x]=(0,s.useOptimistic)(m.IDLE_LINK_STATUS),w=(0,s.useRef)(null),{href:E,as:k,children:C,prefetch:j=null,passHref:_,replace:S,shallow:O,scroll:P,onClick:T,onMouseEnter:N,onTouchStart:I,legacyBehavior:L=!1,onNavigate:A,transitionTypes:M,ref:$,unstable_dynamicOnHover:R,...D}=t;o=C,L&&("string"==typeof o||"number"==typeof o)&&(o=(0,i.jsx)("a",{children:o}));let U=s.default.useContext(c.AppRouterContext),z=!1!==j,F=!1!==j?null===(n=j)||"auto"===n?y.FetchStrategy.PPR:y.FetchStrategy.Full:y.FetchStrategy.PPR,q="string"==typeof(r=k||E)?r:(0,l.formatUrl)(r);if(L){if(o?.$$typeof===Symbol.for("react.lazy"))throw Object.defineProperty(Error("`<Link legacyBehavior>` received a direct child that is either a Server Component, or JSX that was loaded with React.lazy(). This is not supported. Either remove legacyBehavior, or make the direct child a Client Component that renders the Link's `<a>` tag."),"__NEXT_ERROR_CODE",{value:"E863",enumerable:!1,configurable:!0});a=s.default.Children.only(o)}let B=L?a&&"object"==typeof a&&a.ref:$,H=s.default.useCallback(e=>(null!==U&&(w.current=(0,m.mountLinkInstance)(e,q,U,F,z,x)),()=>{w.current&&((0,m.unmountLinkForCurrentNavigation)(w.current),w.current=null),(0,m.unmountPrefetchableInstance)(e)}),[z,q,U,F,x]),K={ref:(0,u.useMergedRef)(H,B),onClick(t){L||"function"!=typeof T||T(t),L&&a.props&&"function"==typeof a.props.onClick&&a.props.onClick(t),!U||t.defaultPrevented||function(t,r,n,o,a,i,l){if("u">typeof window){let c,{nodeName:u}=t.currentTarget;if("A"===u.toUpperCase()&&((c=t.currentTarget.getAttribute("target"))&&"_self"!==c||t.metaKey||t.ctrlKey||t.shiftKey||t.altKey||t.nativeEvent&&2===t.nativeEvent.which)||t.currentTarget.hasAttribute("download"))return;if(!(0,h.isLocalURL)(r)){o&&(t.preventDefault(),location.replace(r));return}if(t.preventDefault(),i){let e=!1;if(i({preventDefault:()=>{e=!0}}),e)return}let{dispatchNavigateAction:d}=e.r(45273);s.default.startTransition(()=>{d(r,o?"replace":"push",!1===a?p.ScrollBehavior.NoScroll:p.ScrollBehavior.Default,n.current,l)})}}(t,q,w,S,P,A,M)},onMouseEnter(e){L||"function"!=typeof N||N(e),L&&a.props&&"function"==typeof a.props.onMouseEnter&&a.props.onMouseEnter(e),U&&z&&(0,m.onNavigationIntent)(e.currentTarget,!0===R)},onTouchStart:function(e){L||"function"!=typeof I||I(e),L&&a.props&&"function"==typeof a.props.onTouchStart&&a.props.onTouchStart(e),U&&z&&(0,m.onNavigationIntent)(e.currentTarget,!0===R)}};return(0,d.isAbsoluteUrl)(q)?K.href=q:L&&!_&&("a"!==a.type||"href"in a.props)||(K.href=(0,f.addBasePath)(q)),g=L?s.default.cloneElement(a,K):(0,i.jsx)("a",{...D,...K,children:o}),(0,i.jsx)(b.Provider,{value:v,children:g})}e.r(97327);let b=(0,s.createContext)(m.IDLE_LINK_STATUS),v=()=>(0,s.useContext)(b);("function"==typeof r.default||"object"==typeof r.default&&null!==r.default)&&void 0===r.default.__esModule&&(Object.defineProperty(r.default,"__esModule",{value:!0}),Object.assign(r.default,r),t.exports=r.default)},21957,e=>{"use strict";var t=e.i(36859),r=(e,t,r,n,o,a,i,s)=>{let l=document.documentElement,c=["light","dark"];function u(t){var r;(Array.isArray(e)?e:[e]).forEach(e=>{let r="class"===e,n=r&&a?o.map(e=>a[e]||e):o;r?(l.classList.remove(...n),l.classList.add(a&&a[t]?a[t]:t)):l.setAttribute(e,t)}),r=t,s&&c.includes(r)&&(l.style.colorScheme=r)}if(n)u(n);else try{let e=localStorage.getItem(t)||r,n=i&&"system"===e?window.matchMedia("(prefers-color-scheme: dark)").matches?"dark":"light":e;u(n)}catch(e){}},n=["light","dark"],o="(prefers-color-scheme: dark)",a="u"<typeof window,i=t.createContext(void 0),s={setTheme:e=>{},themes:[]},l=["light","dark"],c=({forcedTheme:e,disableTransitionOnChange:r=!1,enableSystem:a=!0,enableColorScheme:s=!0,storageKey:c="theme",themes:m=l,defaultTheme:h=a?"system":"light",attribute:y="data-theme",value:g,children:b,nonce:v,scriptProps:x})=>{let[w,E]=t.useState(()=>d(c,h)),[k,C]=t.useState(()=>"system"===w?p():w),j=g?Object.values(g):m,_=t.useCallback(e=>{let t=e;if(!t)return;"system"===e&&a&&(t=p());let o=g?g[t]:t,i=r?f(v):null,l=document.documentElement,c=e=>{"class"===e?(l.classList.remove(...j),o&&l.classList.add(o)):e.startsWith("data-")&&(o?l.setAttribute(e,o):l.removeAttribute(e))};if(Array.isArray(y)?y.forEach(c):c(y),s){let e=n.includes(h)?h:null,r=n.includes(t)?t:e;l.style.colorScheme=r}null==i||i()},[v]),S=t.useCallback(e=>{let t="function"==typeof e?e(w):e;E(t);try{localStorage.setItem(c,t)}catch(e){}},[w]),O=t.useCallback(t=>{C(p(t)),"system"===w&&a&&!e&&_("system")},[w,e]);t.useEffect(()=>{let e=window.matchMedia(o);return e.addListener(O),O(e),()=>e.removeListener(O)},[O]),t.useEffect(()=>{let e=e=>{e.key===c&&(e.newValue?E(e.newValue):S(h))};return window.addEventListener("storage",e),()=>window.removeEventListener("storage",e)},[S]),t.useEffect(()=>{_(null!=e?e:w)},[e,w]);let P=t.useMemo(()=>({theme:w,setTheme:S,forcedTheme:e,resolvedTheme:"system"===w?k:w,themes:a?[...m,"system"]:m,systemTheme:a?k:void 0}),[w,S,e,k,a,m]);return t.createElement(i.Provider,{value:P},t.createElement(u,{forcedTheme:e,storageKey:c,attribute:y,enableSystem:a,enableColorScheme:s,defaultTheme:h,value:g,themes:m,nonce:v,scriptProps:x}),b)},u=t.memo(({forcedTheme:e,storageKey:n,attribute:o,enableSystem:a,enableColorScheme:i,defaultTheme:s,value:l,themes:c,nonce:u,scriptProps:d})=>{let f=JSON.stringify([o,n,s,e,c,l,a,i]).slice(1,-1);return t.createElement("script",{...d,suppressHydrationWarning:!0,nonce:"u"<typeof window?u:"",dangerouslySetInnerHTML:{__html:`(${r.toString()})(${f})`}})}),d=(e,t)=>{let r;if(!a){try{r=localStorage.getItem(e)||void 0}catch(e){}return r||t}},f=e=>{let t=document.createElement("style");return e&&t.setAttribute("nonce",e),t.appendChild(document.createTextNode("*,*::before,*::after{-webkit-transition:none!important;-moz-transition:none!important;-o-transition:none!important;-ms-transition:none!important;transition:none!important}")),document.head.appendChild(t),()=>{window.getComputedStyle(document.body),setTimeout(()=>{document.head.removeChild(t)},1)}},p=e=>(e||(e=window.matchMedia(o)),e.matches?"dark":"light");e.s(["ThemeProvider",0,e=>t.useContext(i)?t.createElement(t.Fragment,null,e.children):t.createElement(c,{...e}),"useTheme",0,()=>{var e;return null!=(e=t.useContext(i))?e:s}])},98992,e=>{"use strict";let t,r;var n,o=e.i(36859);let a={data:""},i=/(?:([\u0080-\uFFFF\w-%@]+) *:? *([^{;]+?);|([^;}{]*?) *{)|(}\s*)/g,s=/\/\*[^]*?\*\/|  +/g,l=/\n+/g,c=(e,t)=>{let r="",n="",o="";for(let a in e){let i=e[a];"@"==a[0]?"i"==a[1]?r=a+" "+i+";":n+="f"==a[1]?c(i,a):a+"{"+c(i,"k"==a[1]?"":t)+"}":"object"==typeof i?n+=c(i,t?t.replace(/([^,])+/g,e=>a.replace(/([^,]*:\S+\([^)]*\))|([^,])+/g,t=>/&/.test(t)?t.replace(/&/g,e):e?e+" "+t:t)):a):null!=i&&(a="-"==a[1]?a:a.replace(/[A-Z]/g,"-$&").toLowerCase(),o+=c.p?c.p(a,i):a+":"+i+";")}return r+(t&&o?t+"{"+o+"}":o)+n},u={},d=e=>{if("object"==typeof e){let t="";for(let r in e)t+=r+d(e[r]);return t}return e};function f(e){let t,r,n=this||{},o=e.call?e(n.p):e;return((e,t,r,n,o)=>{var a;let f=d(e),p=u[f]||(u[f]=(e=>{let t=0,r=11;for(;t<e.length;)r=101*r+e.charCodeAt(t++)>>>0;return"go"+r})(f));if(!u[p]){let t=f!==e?e:(e=>{let t,r,n=[{}];for(;t=i.exec(e.replace(s,""));)t[4]?n.shift():t[3]?(r=t[3].replace(l," ").trim(),n.unshift(n[0][r]=n[0][r]||{})):n[0][t[1]]=t[2].replace(l," ").trim();return n[0]})(e);u[p]=c(o?{["@keyframes "+p]:t}:t,r?"":"."+p)}let m=r&&u.g;return r&&(u.g=u[p]),a=u[p],m?t.data=t.data.replace(m,a):-1===t.data.indexOf(a)&&(t.data=n?a+t.data:t.data+a),p})(o.unshift?o.raw?(t=[].slice.call(arguments,1),r=n.p,o.reduce((e,n,o)=>{let a=t[o];if(a&&a.call){let e=a(r),t=e&&e.props&&e.props.className||/^go/.test(e)&&e;a=t?"."+t:e&&"object"==typeof e?e.props?"":c(e,""):!1===e?"":e}return e+n+(null==a?"":a)},"")):o.reduce((e,t)=>Object.assign(e,t&&t.call?t(n.p):t),{}):o,(e=>{if("object"==typeof window){let t=(e?e.querySelector("#_goober"):window._goober)||Object.assign(document.createElement("style"),{innerHTML:" ",id:"_goober"});return t.nonce=window.__nonce__,t.parentNode||(e||document.head).appendChild(t),t.firstChild}return e||a})(n.target),n.g,n.o,n.k)}f.bind({g:1});let p,m,h,y=f.bind({k:1});function g(e,t){let r=this||{};return function(){let n=arguments;function o(a,i){let s=Object.assign({},a),l=s.className||o.className;r.p=Object.assign({theme:m&&m()},s),r.o=/go\d/.test(l),s.className=f.apply(r,n)+(l?" "+l:""),t&&(s.ref=i);let c=e;return e[0]&&(c=s.as||e,delete s.as),h&&c[0]&&h(s),p(c,s)}return t?t(o):o}}var b=(e,t)=>"function"==typeof e?e(t):e,v=(t=0,()=>(++t).toString()),x=()=>{if(void 0===r&&"u">typeof window){let e=matchMedia("(prefers-reduced-motion: reduce)");r=!e||e.matches}return r},w="default",E=(e,t)=>{let{toastLimit:r}=e.settings;switch(t.type){case 0:return{...e,toasts:[t.toast,...e.toasts].slice(0,r)};case 1:return{...e,toasts:e.toasts.map(e=>e.id===t.toast.id?{...e,...t.toast}:e)};case 2:let{toast:n}=t;return E(e,{type:+!!e.toasts.find(e=>e.id===n.id),toast:n});case 3:let{toastId:o}=t;return{...e,toasts:e.toasts.map(e=>e.id===o||void 0===o?{...e,dismissed:!0,visible:!1}:e)};case 4:return void 0===t.toastId?{...e,toasts:[]}:{...e,toasts:e.toasts.filter(e=>e.id!==t.toastId)};case 5:return{...e,pausedAt:t.time};case 6:let a=t.time-(e.pausedAt||0);return{...e,pausedAt:void 0,toasts:e.toasts.map(e=>({...e,pauseDuration:e.pauseDuration+a}))}}},k=[],C={toasts:[],pausedAt:void 0,settings:{toastLimit:20}},j={},_=(e,t=w)=>{j[t]=E(j[t]||C,e),k.forEach(([e,r])=>{e===t&&r(j[t])})},S=e=>Object.keys(j).forEach(t=>_(e,t)),O=(e=w)=>t=>{_(t,e)},P={blank:4e3,error:4e3,success:2e3,loading:1/0,custom:4e3},T=e=>(t,r)=>{let n,o=((e,t="blank",r)=>({createdAt:Date.now(),visible:!0,dismissed:!1,type:t,ariaProps:{role:"status","aria-live":"polite"},message:e,pauseDuration:0,...r,id:(null==r?void 0:r.id)||v()}))(t,e,r);return O(o.toasterId||(n=o.id,Object.keys(j).find(e=>j[e].toasts.some(e=>e.id===n))))({type:2,toast:o}),o.id},N=(e,t)=>T("blank")(e,t);N.error=T("error"),N.success=T("success"),N.loading=T("loading"),N.custom=T("custom"),N.dismiss=(e,t)=>{let r={type:3,toastId:e};t?O(t)(r):S(r)},N.dismissAll=e=>N.dismiss(void 0,e),N.remove=(e,t)=>{let r={type:4,toastId:e};t?O(t)(r):S(r)},N.removeAll=e=>N.remove(void 0,e),N.promise=(e,t,r)=>{let n=N.loading(t.loading,{...r,...null==r?void 0:r.loading});return"function"==typeof e&&(e=e()),e.then(e=>{let o=t.success?b(t.success,e):void 0;return o?N.success(o,{id:n,...r,...null==r?void 0:r.success}):N.dismiss(n),e}).catch(e=>{let o=t.error?b(t.error,e):void 0;o?N.error(o,{id:n,...r,...null==r?void 0:r.error}):N.dismiss(n)}),e};var I=1e3,L=y`
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
}`,M=y`
from {
  transform: scale(0) rotate(90deg);
	opacity: 0;
}
to {
  transform: scale(1) rotate(90deg);
	opacity: 1;
}`,$=g("div")`
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
    animation: ${M} 0.15s ease-out forwards;
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
}`,z=y`
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
}`,F=g("div")`
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
    animation: ${z} 0.2s ease-out forwards;
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
`,q=g("div")`
  position: absolute;
`,B=g("div")`
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  min-width: 20px;
  min-height: 20px;
`,H=y`
from {
  transform: scale(0.6);
  opacity: 0.4;
}
to {
  transform: scale(1);
  opacity: 1;
}`,K=g("div")`
  position: relative;
  transform: scale(0.6);
  opacity: 0.4;
  min-width: 20px;
  animation: ${H} 0.3s 0.12s cubic-bezier(0.175, 0.885, 0.32, 1.275)
    forwards;
`,J=({toast:e})=>{let{icon:t,type:r,iconTheme:n}=e;return void 0!==t?"string"==typeof t?o.createElement(K,null,t):t:"blank"===r?null:o.createElement(B,null,o.createElement(D,{...n}),"loading"!==r&&o.createElement(q,null,"error"===r?o.createElement($,{...n}):o.createElement(F,{...n})))},W=g("div")`
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
`,X=o.memo(({toast:e,position:t,style:r,children:n})=>{let a=e.height?((e,t)=>{let r=e.includes("top")?1:-1,[n,o]=x()?["0%{opacity:0;} 100%{opacity:1;}","0%{opacity:1;} 100%{opacity:0;}"]:[`
0% {transform: translate3d(0,${-200*r}%,0) scale(.6); opacity:.5;}
100% {transform: translate3d(0,0,0) scale(1); opacity:1;}
`,`
0% {transform: translate3d(0,0,-1px) scale(1); opacity:1;}
100% {transform: translate3d(0,${-150*r}%,-1px) scale(.6); opacity:0;}
`];return{animation:t?`${y(n)} 0.35s cubic-bezier(.21,1.02,.73,1) forwards`:`${y(o)} 0.4s forwards cubic-bezier(.06,.71,.55,1)`}})(e.position||t||"top-center",e.visible):{opacity:0},i=o.createElement(J,{toast:e}),s=o.createElement(V,{...e.ariaProps},b(e.message,e));return o.createElement(W,{className:e.className,style:{...a,...r,...e.style}},"function"==typeof n?n({icon:i,message:s}):o.createElement(o.Fragment,null,i,s))});n=o.createElement,c.p=void 0,p=n,m=void 0,h=void 0;var G=({id:e,className:t,style:r,onHeightUpdate:n,children:a})=>{let i=o.useCallback(t=>{if(t){let r=()=>{n(e,t.getBoundingClientRect().height)};r(),new MutationObserver(r).observe(t,{subtree:!0,childList:!0,characterData:!0})}},[e,n]);return o.createElement("div",{ref:i,className:t,style:r},a)},Q=f`
  z-index: 9999;
  > * {
    pointer-events: auto;
  }
`;e.s(["Toaster",0,({reverseOrder:e,position:t="top-center",toastOptions:r,gutter:n,children:a,toasterId:i,containerStyle:s,containerClassName:l})=>{let{toasts:c,handlers:u}=((e,t="default")=>{let{toasts:r,pausedAt:n}=((e={},t=w)=>{let[r,n]=(0,o.useState)(j[t]||C),a=(0,o.useRef)(j[t]);(0,o.useEffect)(()=>(a.current!==j[t]&&n(j[t]),k.push([t,n]),()=>{let e=k.findIndex(([e])=>e===t);e>-1&&k.splice(e,1)}),[t]);let i=r.toasts.map(t=>{var r,n,o;return{...e,...e[t.type],...t,removeDelay:t.removeDelay||(null==(r=e[t.type])?void 0:r.removeDelay)||(null==e?void 0:e.removeDelay),duration:t.duration||(null==(n=e[t.type])?void 0:n.duration)||(null==e?void 0:e.duration)||P[t.type],style:{...e.style,...null==(o=e[t.type])?void 0:o.style,...t.style}}});return{...r,toasts:i}})(e,t),a=(0,o.useRef)(new Map).current,i=(0,o.useCallback)((e,t=I)=>{if(a.has(e))return;let r=setTimeout(()=>{a.delete(e),s({type:4,toastId:e})},t);a.set(e,r)},[]);(0,o.useEffect)(()=>{if(n)return;let e=Date.now(),o=r.map(r=>{if(r.duration===1/0)return;let n=(r.duration||0)+r.pauseDuration-(e-r.createdAt);if(n<0){r.visible&&N.dismiss(r.id);return}return setTimeout(()=>N.dismiss(r.id,t),n)});return()=>{o.forEach(e=>e&&clearTimeout(e))}},[r,n,t]);let s=(0,o.useCallback)(O(t),[t]),l=(0,o.useCallback)(()=>{s({type:5,time:Date.now()})},[s]),c=(0,o.useCallback)((e,t)=>{s({type:1,toast:{id:e,height:t}})},[s]),u=(0,o.useCallback)(()=>{n&&s({type:6,time:Date.now()})},[n,s]),d=(0,o.useCallback)((e,t)=>{let{reverseOrder:n=!1,gutter:o=8,defaultPosition:a}=t||{},i=r.filter(t=>(t.position||a)===(e.position||a)&&t.height),s=i.findIndex(t=>t.id===e.id),l=i.filter((e,t)=>t<s&&e.visible).length;return i.filter(e=>e.visible).slice(...n?[l+1]:[0,l]).reduce((e,t)=>e+(t.height||0)+o,0)},[r]);return(0,o.useEffect)(()=>{r.forEach(e=>{if(e.dismissed)i(e.id,e.removeDelay);else{let t=a.get(e.id);t&&(clearTimeout(t),a.delete(e.id))}})},[r,i]),{toasts:r,handlers:{updateHeight:c,startPause:l,endPause:u,calculateOffset:d}}})(r,i);return o.createElement("div",{"data-rht-toaster":i||"",style:{position:"fixed",zIndex:9999,top:16,left:16,right:16,bottom:16,pointerEvents:"none",...s},className:l,onMouseEnter:u.startPause,onMouseLeave:u.endPause},c.map(r=>{let i,s,l=r.position||t,c=u.calculateOffset(r,{reverseOrder:e,gutter:n,defaultPosition:t}),d=(i=l.includes("top"),s=l.includes("center")?{justifyContent:"center"}:l.includes("right")?{justifyContent:"flex-end"}:{},{left:0,right:0,display:"flex",position:"absolute",transition:x()?void 0:"all 230ms cubic-bezier(.21,1.02,.73,1)",transform:`translateY(${c*(i?1:-1)}px)`,...i?{top:0}:{bottom:0},...s});return o.createElement(G,{id:r.id,key:r.id,onHeightUpdate:u.updateHeight,className:r.visible?Q:"",style:d},"custom"===r.type?b(r.message,r):a?a(r):o.createElement(X,{toast:r,position:l}))}))},"default",0,N],98992)},51713,e=>{"use strict";var t=e.i(57692),r=e.i(36859),n=e.i(39742);let o="copiq_consent";function a(e,t,r){if("u"<typeof document)return;let n="https:"===location.protocol?"; Secure":"";document.cookie=`${e}=${encodeURIComponent(t)}; path=/; max-age=${r}; SameSite=Lax${n}`}function i(){a(o,"",0),window.dispatchEvent(new CustomEvent("copiq:consent-reset"))}function s({title:e,desc:r,checked:n,disabled:o,onChange:a}){return(0,t.jsxs)("label",{className:`flex items-start gap-3 ${o?"opacity-60":"cursor-pointer"}`,children:[(0,t.jsx)("input",{type:"checkbox",checked:n,disabled:o,onChange:e=>a?.(e.target.checked),className:"mt-0.5 h-4 w-4 shrink-0"}),(0,t.jsxs)("span",{className:"min-w-0",children:[(0,t.jsxs)("span",{className:"block text-sm font-medium",children:[e,o&&(0,t.jsx)("span",{className:"ml-2 text-[11px] font-normal text-[var(--on-surface-faint)]",children:"toujours actifs"})]}),(0,t.jsx)("span",{className:"block text-xs text-[var(--on-surface-muted)]",children:r})]})]})}e.s(["ConsentLink",0,function({className:e=""}){return(0,t.jsx)("button",{onClick:i,className:`text-sm text-[var(--on-surface-muted)] underline-offset-2 hover:underline ${e}`,children:"Gérer mes cookies"})},"CookieBanner",0,function(){let[e,i]=(0,r.useState)(!1),[l,c]=(0,r.useState)(!1),[u,d]=(0,r.useState)({analytics:!1,marketing:!1});if((0,r.useEffect)(()=>{null===function(){let e=function(e){if("u"<typeof document)return null;let t=document.cookie.split("; ").find(t=>t.startsWith(`${e}=`));return t?decodeURIComponent(t.slice(e.length+1)):null}(o);if(!e)return null;try{let t=JSON.parse(e);if(1!==t.version||!t.categories)return null;return{...t,categories:{...t.categories,necessary:!0}}}catch{return null}}()&&i(!0);let e=()=>{c(!1),d({analytics:!1,marketing:!1}),i(!0)};return window.addEventListener("copiq:consent-reset",e),()=>window.removeEventListener("copiq:consent-reset",e)},[]),!e)return null;function f(e){let t;a(o,JSON.stringify(t={version:1,date:new Date().toISOString(),categories:{necessary:!0,...e}}),33696e3),window.dispatchEvent(new CustomEvent("copiq:consent",{detail:t.categories})),i(!1)}return(0,t.jsx)("div",{role:"dialog","aria-modal":"false","aria-labelledby":"cookie-title","aria-describedby":"cookie-desc",className:"fixed inset-x-0 bottom-0 z-[100] p-3 sm:p-4",children:(0,t.jsxs)("div",{className:"mx-auto max-w-3xl rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-5 shadow-2xl",children:[(0,t.jsx)("h2",{id:"cookie-title",className:"text-base font-semibold",children:"Cookies et données"}),(0,t.jsxs)("p",{id:"cookie-desc",className:"mt-2 text-sm leading-relaxed text-[var(--on-surface-muted)]",children:["Nous utilisons des cookies strictement nécessaires au fonctionnement du site (connexion, sécurité). Avec ton accord, nous pouvons aussi mesurer l'audience pour améliorer la préparation au concours. Tu peux refuser sans conséquence sur ton utilisation du site."," ",(0,t.jsx)(n.default,{href:"/privacy",className:"font-medium text-[var(--brand)] underline underline-offset-2",children:"Politique de confidentialité"})]}),l&&(0,t.jsxs)("div",{className:"mt-4 space-y-2.5 rounded-xl border border-[var(--outline-variant)] p-3.5",children:[(0,t.jsx)(s,{title:"Strictement nécessaires",desc:"Session, authentification, sécurité. Indispensables au fonctionnement du site.",checked:!0,disabled:!0}),(0,t.jsx)(s,{title:"Mesure d'audience",desc:"Pages consultées et parcours, de façon agrégée, pour améliorer le contenu.",checked:u.analytics,onChange:e=>d({...u,analytics:e})}),(0,t.jsx)(s,{title:"Publicité",desc:"Personnalisation des annonces et mesure des campagnes.",checked:u.marketing,onChange:e=>d({...u,marketing:e})})]}),(0,t.jsxs)("div",{className:"mt-4 flex flex-col gap-2 sm:flex-row",children:[(0,t.jsx)("button",{onClick:()=>f({analytics:!1,marketing:!1}),className:"flex-1 rounded-xl border border-[var(--outline)] px-4 py-2.5 text-sm font-semibold transition hover:bg-[var(--surface-container)]",children:"Tout refuser"}),l?(0,t.jsx)("button",{onClick:()=>f(u),className:"flex-1 rounded-xl border border-[var(--outline)] px-4 py-2.5 text-sm font-semibold transition hover:bg-[var(--surface-container)]",children:"Enregistrer mes choix"}):(0,t.jsx)("button",{onClick:()=>c(!0),className:"flex-1 rounded-xl border border-[var(--outline)] px-4 py-2.5 text-sm font-semibold transition hover:bg-[var(--surface-container)]",children:"Personnaliser"}),(0,t.jsx)("button",{onClick:()=>f({analytics:!0,marketing:!0}),className:"flex-1 rounded-xl bg-[var(--brand)] px-4 py-2.5 text-sm font-semibold text-white transition hover:brightness-110",children:"Tout accepter"})]})]})})}],51713)},81193,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0});var n={cancelIdleCallback:function(){return i},requestIdleCallback:function(){return a}};for(var o in n)Object.defineProperty(r,o,{enumerable:!0,get:n[o]});let a="u">typeof self&&self.requestIdleCallback&&self.requestIdleCallback.bind(window)||function(e){let t=Date.now();return self.setTimeout(function(){e({didTimeout:!1,timeRemaining:function(){return Math.max(0,50-(Date.now()-t))}})},1)},i="u">typeof self&&self.cancelIdleCallback&&self.cancelIdleCallback.bind(window)||function(e){return clearTimeout(e)};("function"==typeof r.default||"object"==typeof r.default&&null!==r.default)&&void 0===r.default.__esModule&&(Object.defineProperty(r.default,"__esModule",{value:!0}),Object.assign(r.default,r),t.exports=r.default)},48876,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0});var n={ESCAPE_REGEX:function(){return i},htmlEscapeAttributeString:function(){return u},htmlEscapeJsonString:function(){return c}};for(var o in n)Object.defineProperty(r,o,{enumerable:!0,get:n[o]});let a={"&":"\\u0026",">":"\\u003e","<":"\\u003c","\u2028":"\\u2028","\u2029":"\\u2029"},i=/[&><\u2028\u2029]/g,s={"&":"&amp;",'"':"&quot;","'":"&#39;","<":"&lt;",">":"&gt;"},l=/[&"'<>]/g;function c(e){return e.replace(i,e=>a[e])}function u(e){return e.replace(l,e=>s[e])}},52723,(e,t,r)=>{"use strict";Object.defineProperty(r,"__esModule",{value:!0});var n={default:function(){return x},handleClientScriptLoad:function(){return g},initScriptLoader:function(){return b}};for(var o in n)Object.defineProperty(r,o,{enumerable:!0,get:n[o]});let a=e.r(81258),i=e.r(44066),s=e.r(57692),l=a._(e.r(19893)),c=i._(e.r(36859)),u=e.r(61317),d=e.r(78706),f=e.r(81193),p=e.r(48876),m=new Map,h=new Set,y=e=>{let{src:t,id:r,onLoad:n=()=>{},onReady:o=null,dangerouslySetInnerHTML:a,children:i="",strategy:s="afterInteractive",onError:c,stylesheets:u}=e,f=r||t;if(f&&h.has(f))return;if(m.has(t)){h.add(f),m.get(t).then(n,c);return}let p=()=>{o&&o(),h.add(f)},y=document.createElement("script"),g=new Promise((e,t)=>{y.addEventListener("load",function(t){e(),n&&n.call(this,t),p()}),y.addEventListener("error",function(e){t(e)})}).catch(function(e){c&&c(e)});a?(y.innerHTML=a.__html||"",p()):i?(y.textContent="string"==typeof i?i:Array.isArray(i)?i.join(""):"",p()):t&&(y.src=t,m.set(t,g)),(0,d.setAttributesFromProps)(y,e),"worker"===s&&y.setAttribute("type","text/partytown"),y.setAttribute("data-nscript",s),u&&(e=>{if(l.default.preinit)return e.forEach(e=>{l.default.preinit(e,{as:"style"})});if("u">typeof window){let t=document.head;e.forEach(e=>{let r=document.createElement("link");r.type="text/css",r.rel="stylesheet",r.href=e,t.appendChild(r)})}})(u),document.body.appendChild(y)};function g(e){let{strategy:t="afterInteractive"}=e;"lazyOnload"===t?window.addEventListener("load",()=>{(0,f.requestIdleCallback)(()=>y(e))}):y(e)}function b(e){e.forEach(g),[...document.querySelectorAll('[data-nscript="beforeInteractive"]'),...document.querySelectorAll('[data-nscript="beforePageRender"]')].forEach(e=>{let t=e.id||e.getAttribute("src");h.add(t)})}function v(e){let{id:t,src:r="",onLoad:n=()=>{},onReady:o=null,strategy:a="afterInteractive",onError:i,stylesheets:d,...m}=e,{updateScripts:g,scripts:b,getIsSsr:v,appDir:x,nonce:w}=(0,c.useContext)(u.HeadManagerContext);w=m.nonce||w;let E=(0,c.useRef)(!1);(0,c.useEffect)(()=>{let e=t||r;E.current||(o&&e&&h.has(e)&&o(),E.current=!0)},[o,t,r]);let k=(0,c.useRef)(!1);if((0,c.useEffect)(()=>{if(!k.current){if("afterInteractive"===a)y(e);else"lazyOnload"===a&&("complete"===document.readyState?(0,f.requestIdleCallback)(()=>y(e)):window.addEventListener("load",()=>{(0,f.requestIdleCallback)(()=>y(e))}));k.current=!0}},[e,a]),("beforeInteractive"===a||"worker"===a)&&(g?(b[a]=(b[a]||[]).concat([{id:t,src:r,onLoad:n,onReady:o,onError:i,...m,nonce:w}]),g(b)):v&&v()?h.add(t||r):v&&!v()&&y({...e,nonce:w})),x){if(d&&d.forEach(e=>{l.default.preinit(e,{as:"style"})}),"beforeInteractive"===a)if(!r)return m.dangerouslySetInnerHTML&&(m.children=m.dangerouslySetInnerHTML.__html,delete m.dangerouslySetInnerHTML),(0,s.jsx)("script",{nonce:w,dangerouslySetInnerHTML:{__html:`(self.__next_s=self.__next_s||[]).push(${(0,p.htmlEscapeJsonString)(JSON.stringify([0,{...m,id:t}]))})`}});else return l.default.preload(r,m.integrity?{as:"script",integrity:m.integrity,nonce:w,crossOrigin:m.crossOrigin}:{as:"script",nonce:w,crossOrigin:m.crossOrigin}),(0,s.jsx)("script",{nonce:w,dangerouslySetInnerHTML:{__html:`(self.__next_s=self.__next_s||[]).push(${(0,p.htmlEscapeJsonString)(JSON.stringify([r,{...m,id:t}]))})`}});"afterInteractive"===a&&r&&l.default.preload(r,m.integrity?{as:"script",integrity:m.integrity,nonce:w,crossOrigin:m.crossOrigin}:{as:"script",nonce:w,crossOrigin:m.crossOrigin})}return null}Object.defineProperty(v,"__nextScript",{value:!0});let x=v;("function"==typeof r.default||"object"==typeof r.default&&null!==r.default)&&void 0===r.default.__esModule&&(Object.defineProperty(r.default,"__esModule",{value:!0}),Object.assign(r.default,r),t.exports=r.default)},1661,e=>{"use strict";var t=e.i(57692),r=e.i(21957),n=e.i(98992),o=e.i(51713);e.s(["Providers",0,function({children:e}){return(0,t.jsxs)(r.ThemeProvider,{attribute:"class",defaultTheme:"system",enableSystem:!0,disableTransitionOnChange:!1,children:[e,(0,t.jsx)(n.Toaster,{position:"top-right",toastOptions:{duration:4e3,style:{background:"var(--surface-container)",color:"var(--on-surface)",border:"1px solid var(--outline)",borderRadius:"12px",fontSize:"0.875rem",fontFamily:"var(--font-instrument-sans, system-ui)"},success:{iconTheme:{primary:"#22C55E",secondary:"#fff"}},error:{iconTheme:{primary:"#EF4444",secondary:"#fff"}}}}),(0,t.jsx)(o.CookieBanner,{})]})}])}]);