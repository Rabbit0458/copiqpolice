(globalThis.TURBOPACK||(globalThis.TURBOPACK=[])).push(["object"==typeof document?document.currentScript:void 0,89750,(e,r,s)=>{r.exports=e.r(37977)},37076,e=>{"use strict";var r=e.i(84527),s=e.i(57692),t=e.i(36859),a=e.i(89750);function i({status:e}){let r="success"===e,t="loading"===e?"var(--brand)":r?"#22C55E":"#EF4444";return(0,s.jsxs)("div",{className:"copiq-icon-pop",style:{width:96,height:96,position:"relative"},children:["loading"!==e&&(0,s.jsx)("div",{className:"copiq-glow",style:{background:`radial-gradient(circle, ${r?"rgba(34,197,94,.4)":"rgba(239,68,68,.4)"}, transparent 70%)`}}),(0,s.jsxs)("svg",{width:"96",height:"96",viewBox:"0 0 96 96",fill:"none",children:[(0,s.jsx)("circle",{cx:"48",cy:"48",r:"42",stroke:t,strokeWidth:"3",strokeLinecap:"round",className:"loading"===e?"copiq-circle-spin":"copiq-circle-draw",style:{opacity:"loading"===e?.25:1}}),"loading"===e&&(0,s.jsx)("path",{d:"M48 6a42 42 0 0 1 42 42",stroke:t,strokeWidth:"3",strokeLinecap:"round",className:"copiq-arc-spin"}),r&&(0,s.jsx)("path",{d:"M30 49l12 12 24-26",stroke:t,strokeWidth:"4.5",strokeLinecap:"round",strokeLinejoin:"round",className:"copiq-check-draw"}),"error"===e&&(0,s.jsxs)(s.Fragment,{children:[(0,s.jsx)("path",{d:"M34 34l28 28",stroke:t,strokeWidth:"4.5",strokeLinecap:"round",className:"copiq-cross-draw-1"}),(0,s.jsx)("path",{d:"M62 34L34 62",stroke:t,strokeWidth:"4.5",strokeLinecap:"round",className:"copiq-cross-draw-2"})]})]})]})}function o(){return(0,s.jsx)("style",{children:`
      @keyframes copiq-fade-up {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
      }
      @keyframes copiq-pop {
        0% { opacity: 0; transform: scale(.7); }
        60% { opacity: 1; transform: scale(1.06); }
        100% { opacity: 1; transform: scale(1); }
      }
      @keyframes copiq-draw { to { stroke-dashoffset: 0; } }
      @keyframes copiq-spin { to { transform: rotate(360deg); } }
      @keyframes copiq-glow-pulse {
        0% { opacity: 0; transform: scale(.6); }
        45% { opacity: 1; transform: scale(1.05); }
        100% { opacity: 0; transform: scale(1.7); }
      }
      @keyframes copiq-settle {
        0% { transform: scale(1); }
        50% { transform: scale(1.08); }
        100% { transform: scale(1); }
      }

      .copiq-card { animation: copiq-fade-up .5s cubic-bezier(.16,1,.3,1) both; }
      .copiq-logo { animation: copiq-fade-up .5s cubic-bezier(.16,1,.3,1) both; }
      .copiq-icon-pop {
        animation: copiq-pop .55s cubic-bezier(.16,1,.3,1) both .1s,
                   copiq-settle .4s cubic-bezier(.34,1.56,.64,1) both .85s;
        opacity: 0;
      }
      .copiq-glow {
        position: absolute;
        inset: -24px;
        border-radius: 50%;
        opacity: 0;
        animation: copiq-glow-pulse 1.1s ease-out .5s forwards;
        pointer-events: none;
      }

      .copiq-circle-draw {
        stroke-dasharray: 264;
        stroke-dashoffset: 264;
        animation: copiq-draw .6s ease-out .15s forwards;
      }
      .copiq-check-draw {
        stroke-dasharray: 50;
        stroke-dashoffset: 50;
        animation: copiq-draw .35s ease-out .55s forwards;
      }
      .copiq-cross-draw-1, .copiq-cross-draw-2 {
        stroke-dasharray: 40;
        stroke-dashoffset: 40;
        animation: copiq-draw .3s ease-out forwards;
      }
      .copiq-cross-draw-1 { animation-delay: .5s; }
      .copiq-cross-draw-2 { animation-delay: .68s; }

      .copiq-circle-spin, .copiq-arc-spin {
        transform-origin: 48px 48px;
        animation: copiq-spin 1s linear infinite;
      }
    `})}function n({href:e,onClick:r,children:t,variant:a="primary"}){let i="primary"===a?"w-full h-12 rounded-full bg-brand text-white text-[15px] font-semibold flex items-center justify-center hover:bg-brand-mid active:scale-[.98] transition-all":"w-full h-12 rounded-full text-[var(--on-surface-muted)] text-[15px] font-medium flex items-center justify-center hover:text-[var(--on-surface)] transition-colors";return e?(0,s.jsx)("a",{href:e,className:i,children:t}):(0,s.jsx)("button",{type:"button",onClick:r,className:i,children:t})}function c({status:e,title:r,message:t,detail:a,primary:n}){return(0,s.jsxs)("div",{className:"fixed inset-0 z-[999] flex items-center justify-center px-6",style:{background:"var(--surface)"},children:[(0,s.jsx)(o,{}),(0,s.jsxs)("div",{className:"w-full max-w-[340px] flex flex-col items-center text-center",children:[(0,s.jsx)("img",{src:"https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/logo_gris.png",alt:"COP'IQ",width:64,height:64,className:"copiq-logo w-16 h-16 object-contain mb-10"}),(0,s.jsx)(i,{status:e}),(0,s.jsx)("h1",{className:"copiq-card text-[var(--on-surface)] text-[22px] font-bold tracking-tight mt-7 mb-2",style:{animationDelay:".2s"},children:r}),(0,s.jsx)("p",{className:"copiq-card text-[var(--on-surface-muted)] text-[14px] leading-relaxed mb-1",style:{animationDelay:".28s"},children:t}),a&&(0,s.jsx)("p",{className:"copiq-card text-[var(--on-surface-faint)] text-[12px] leading-relaxed mb-2",style:{animationDelay:".32s"},children:a}),n&&(0,s.jsx)("div",{className:"copiq-card w-full mt-8 flex flex-col gap-2",style:{animationDelay:".38s"},children:n})]})]})}function l(){let e=(0,a.useRouter)(),i=(0,a.useSearchParams)(),[o,l]=(0,t.useState)("loading"),[d,p]=(0,t.useState)(""),u=(0,t.useRef)(!1);return((0,t.useEffect)(()=>{if(u.current)return;u.current=!0;let s=i.get("token_hash"),t=i.get("type"),a=i.get("code"),o=i.get("error"),n=i.get("error_description"),c=i.get("status"),d=new URLSearchParams(window.location.hash.replace(/^#/,"")),m=d.get("access_token"),f=d.get("error"),h=d.get("error_description");if(o||n||f||h){p(decodeURIComponent(n??o??h??f??"Erreur inconnue")),l("error"),e.replace("/confirm");return}if(m||"success"===c||a){l("success"),e.replace("/confirm?status=success");return}if(!s||!t){p("Aucun paramètre de confirmation dans le lien."),l("error");return}let x=r.default.env.NEXT_PUBLIC_SUPABASE_URL??"https://nuoonagnkhbeeymtvrcn.supabase.co",g=window.location.origin+"/confirm";window.location.replace(`${x}/auth/v1/verify?token_hash=${encodeURIComponent(s)}&type=${encodeURIComponent(t)}&redirect_to=${encodeURIComponent(g)}`)},[]),"loading"===o)?(0,s.jsx)(c,{status:"loading",title:"Vérification…",message:"Un instant, on confirme ton adresse email."}):"success"===o?(0,s.jsx)(c,{status:"success",title:"Email confirmé",message:"Ton compte COP'IQ est activé.",primary:(0,s.jsxs)(s.Fragment,{children:[(0,s.jsx)(n,{href:"copiq://",variant:"primary",children:"Ouvrir l’application"}),(0,s.jsx)(n,{href:"/login",variant:"ghost",children:"Se connecter sur le web"})]})}):(0,s.jsx)(c,{status:"error",title:"Échec de la confirmation",message:"Ce lien est invalide, expiré, ou déjà utilisé.",detail:d||void 0,primary:(0,s.jsxs)(s.Fragment,{children:[(0,s.jsx)(n,{href:"copiq://",variant:"primary",children:"Ouvrir l’application"}),(0,s.jsx)(n,{href:"/login",variant:"ghost",children:"Se connecter sur le web"})]})})}e.s(["ConfirmEmailPage",0,function(){return(0,s.jsx)(t.Suspense,{fallback:(0,s.jsx)("div",{className:"fixed inset-0 z-[999] flex items-center justify-center",style:{background:"var(--surface)"},children:(0,s.jsx)("div",{className:"w-9 h-9 rounded-full border-2 border-brand border-t-transparent animate-spin"})}),children:(0,s.jsx)(l,{})})}])}]);