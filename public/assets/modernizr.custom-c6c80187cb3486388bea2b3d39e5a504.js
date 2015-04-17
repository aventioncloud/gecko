window.Modernizr=function(e,t,n){function r(e){v.cssText=e}function o(e,t){return typeof e===t}function i(e,t){return!!~(""+e).indexOf(t)}function a(e,t){for(var r in e){var o=e[r];if(!i(o,"-")&&v[o]!==n)return"pfx"==t?o:!0}return!1}function c(e,t,r){for(var i in e){var a=t[e[i]];if(a!==n)return r===!1?e[i]:o(a,"function")?a.bind(r||t):a}return!1}function s(e,t,n){var r=e.charAt(0).toUpperCase()+e.slice(1),i=(e+" "+E.join(r+" ")+r).split(" ");return o(t,"string")||o(t,"undefined")?a(i,t):(i=(e+" "+j.join(r+" ")+r).split(" "),c(i,t,n))}var l,u,f,p="2.6.2",d={},h=!0,m=t.documentElement,y="modernizr",g=t.createElement(y),v=g.style,b=({}.toString,"Webkit Moz O ms"),E=b.split(" "),j=b.toLowerCase().split(" "),S={},C=[],w=C.slice,x={}.hasOwnProperty;f=o(x,"undefined")||o(x.call,"undefined")?function(e,t){return t in e&&o(e.constructor.prototype[t],"undefined")}:function(e,t){return x.call(e,t)},Function.prototype.bind||(Function.prototype.bind=function(e){var t=this;if("function"!=typeof t)throw new TypeError;var n=w.call(arguments,1),r=function(){if(this instanceof r){var o=function(){};o.prototype=t.prototype;var i=new o,a=t.apply(i,n.concat(w.call(arguments)));return Object(a)===a?a:i}return t.apply(e,n.concat(w.call(arguments)))};return r}),S.csstransitions=function(){return s("transition")};for(var F in S)f(S,F)&&(u=F.toLowerCase(),d[u]=S[F](),C.push((d[u]?"":"no-")+u));return d.addTest=function(e,t){if("object"==typeof e)for(var r in e)f(e,r)&&d.addTest(r,e[r]);else{if(e=e.toLowerCase(),d[e]!==n)return d;t="function"==typeof t?t():t,"undefined"!=typeof h&&h&&(m.className+=" "+(t?"":"no-")+e),d[e]=t}return d},r(""),g=l=null,function(e,t){function n(e,t){var n=e.createElement("p"),r=e.getElementsByTagName("head")[0]||e.documentElement;return n.innerHTML="x<style>"+t+"</style>",r.insertBefore(n.lastChild,r.firstChild)}function r(){var e=g.elements;return"string"==typeof e?e.split(" "):e}function o(e){var t=y[e[h]];return t||(t={},m++,e[h]=m,y[m]=t),t}function i(e,n,r){if(n||(n=t),u)return n.createElement(e);r||(r=o(n));var i;return i=r.cache[e]?r.cache[e].cloneNode():d.test(e)?(r.cache[e]=r.createElem(e)).cloneNode():r.createElem(e),i.canHaveChildren&&!p.test(e)?r.frag.appendChild(i):i}function a(e,n){if(e||(e=t),u)return e.createDocumentFragment();n=n||o(e);for(var i=n.frag.cloneNode(),a=0,c=r(),s=c.length;s>a;a++)i.createElement(c[a]);return i}function c(e,t){t.cache||(t.cache={},t.createElem=e.createElement,t.createFrag=e.createDocumentFragment,t.frag=t.createFrag()),e.createElement=function(n){return g.shivMethods?i(n,e,t):t.createElem(n)},e.createDocumentFragment=Function("h,f","return function(){var n=f.cloneNode(),c=n.createElement;h.shivMethods&&("+r().join().replace(/\w+/g,function(e){return t.createElem(e),t.frag.createElement(e),'c("'+e+'")'})+");return n}")(g,t.frag)}function s(e){e||(e=t);var r=o(e);return g.shivCSS&&!l&&!r.hasCSS&&(r.hasCSS=!!n(e,"article,aside,figcaption,figure,footer,header,hgroup,nav,section{display:block}mark{background:#FF0;color:#000}")),u||c(e,r),e}var l,u,f=e.html5||{},p=/^<|^(?:button|map|select|textarea|object|iframe|option|optgroup)$/i,d=/^(?:a|b|code|div|fieldset|h1|h2|h3|h4|h5|h6|i|label|li|ol|p|q|span|strong|style|table|tbody|td|th|tr|ul)$/i,h="_html5shiv",m=0,y={};!function(){try{var e=t.createElement("a");e.innerHTML="<xyz></xyz>",l="hidden"in e,u=1==e.childNodes.length||function(){t.createElement("a");var e=t.createDocumentFragment();return"undefined"==typeof e.cloneNode||"undefined"==typeof e.createDocumentFragment||"undefined"==typeof e.createElement}()}catch(n){l=!0,u=!0}}();var g={elements:f.elements||"abbr article aside audio bdi canvas data datalist details figcaption figure footer header hgroup mark meter nav output progress section summary time video",shivCSS:f.shivCSS!==!1,supportsUnknownElements:u,shivMethods:f.shivMethods!==!1,type:"default",shivDocument:s,createElement:i,createDocumentFragment:a};e.html5=g,s(t)}(this,t),d._version=p,d._domPrefixes=j,d._cssomPrefixes=E,d.testProp=function(e){return a([e])},d.testAllProps=s,m.className=m.className.replace(/(^|\s)no-js(\s|$)/,"$1$2")+(h?" js "+C.join(" "):""),d}(this,this.document),function(e,t,n){function r(e){return"[object Function]"==y.call(e)}function o(e){return"string"==typeof e}function i(){}function a(e){return!e||"loaded"==e||"complete"==e||"uninitialized"==e}function c(){var e=g.shift();v=1,e?e.t?h(function(){("c"==e.t?p.injectCss:p.injectJs)(e.s,0,e.a,e.x,e.e,1)},0):(e(),c()):v=0}function s(e,n,r,o,i,s,l){function u(t){if(!d&&a(f.readyState)&&(b.r=d=1,!v&&c(),f.onload=f.onreadystatechange=null,t)){"img"!=e&&h(function(){j.removeChild(f)},50);for(var r in F[n])F[n].hasOwnProperty(r)&&F[n][r].onload()}}var l=l||p.errorTimeout,f=t.createElement(e),d=0,y=0,b={t:r,s:n,e:i,a:s,x:l};1===F[n]&&(y=1,F[n]=[]),"object"==e?f.data=n:(f.src=n,f.type=e),f.width=f.height="0",f.onerror=f.onload=f.onreadystatechange=function(){u.call(this,y)},g.splice(o,0,b),"img"!=e&&(y||2===F[n]?(j.insertBefore(f,E?null:m),h(u,l)):F[n].push(f))}function l(e,t,n,r,i){return v=0,t=t||"j",o(e)?s("c"==t?C:S,e,t,this.i++,n,r,i):(g.splice(this.i++,0,e),1==g.length&&c()),this}function u(){var e=p;return e.loader={load:l,i:0},e}var f,p,d=t.documentElement,h=e.setTimeout,m=t.getElementsByTagName("script")[0],y={}.toString,g=[],v=0,b="MozAppearance"in d.style,E=b&&!!t.createRange().compareNode,j=E?d:m.parentNode,d=e.opera&&"[object Opera]"==y.call(e.opera),d=!!t.attachEvent&&!d,S=b?"object":d?"script":"img",C=d?"script":S,w=Array.isArray||function(e){return"[object Array]"==y.call(e)},x=[],F={},N={timeout:function(e,t){return t.length&&(e.timeout=t[0]),e}};p=function(e){function t(e){var t,n,r,e=e.split("!"),o=x.length,i=e.pop(),a=e.length,i={url:i,origUrl:i,prefixes:e};for(n=0;a>n;n++)r=e[n].split("="),(t=N[r.shift()])&&(i=t(i,r));for(n=0;o>n;n++)i=x[n](i);return i}function a(e,o,i,a,c){var s=t(e),l=s.autoCallback;s.url.split(".").pop().split("?").shift(),s.bypass||(o&&(o=r(o)?o:o[e]||o[a]||o[e.split("/").pop().split("?")[0]]),s.instead?s.instead(e,o,i,a,c):(F[s.url]?s.noexec=!0:F[s.url]=1,i.load(s.url,s.forceCSS||!s.forceJS&&"css"==s.url.split(".").pop().split("?").shift()?"c":n,s.noexec,s.attrs,s.timeout),(r(o)||r(l))&&i.load(function(){u(),o&&o(s.origUrl,c,a),l&&l(s.origUrl,c,a),F[s.url]=2})))}function c(e,t){function n(e,n){if(e){if(o(e))n||(f=function(){var e=[].slice.call(arguments);p.apply(this,e),d()}),a(e,f,t,0,l);else if(Object(e)===e)for(s in c=function(){var t,n=0;for(t in e)e.hasOwnProperty(t)&&n++;return n}(),e)e.hasOwnProperty(s)&&(!n&&!--c&&(r(f)?f=function(){var e=[].slice.call(arguments);p.apply(this,e),d()}:f[s]=function(e){return function(){var t=[].slice.call(arguments);e&&e.apply(this,t),d()}}(p[s])),a(e[s],f,t,s,l))}else!n&&d()}var c,s,l=!!e.test,u=e.load||e.both,f=e.callback||i,p=f,d=e.complete||i;n(l?e.yep:e.nope,!!u),u&&n(u)}var s,l,f=this.yepnope.loader;if(o(e))a(e,0,f,0);else if(w(e))for(s=0;s<e.length;s++)l=e[s],o(l)?a(l,0,f,0):w(l)?p(l):Object(l)===l&&c(l,f);else Object(e)===e&&c(e,f)},p.addPrefix=function(e,t){N[e]=t},p.addFilter=function(e){x.push(e)},p.errorTimeout=1e4,null==t.readyState&&t.addEventListener&&(t.readyState="loading",t.addEventListener("DOMContentLoaded",f=function(){t.removeEventListener("DOMContentLoaded",f,0),t.readyState="complete"},0)),e.yepnope=u(),e.yepnope.executeStack=c,e.yepnope.injectJs=function(e,n,r,o,s,l){var u,f,d=t.createElement("script"),o=o||p.errorTimeout;d.src=e;for(f in r)d.setAttribute(f,r[f]);n=l?c:n||i,d.onreadystatechange=d.onload=function(){!u&&a(d.readyState)&&(u=1,n(),d.onload=d.onreadystatechange=null)},h(function(){u||(u=1,n(1))},o),s?d.onload():m.parentNode.insertBefore(d,m)},e.yepnope.injectCss=function(e,n,r,o,a,s){var l,o=t.createElement("link"),n=s?c:n||i;o.href=e,o.rel="stylesheet",o.type="text/css";for(l in r)o.setAttribute(l,r[l]);a||(m.parentNode.insertBefore(o,m),h(n,0))}}(this,document),Modernizr.load=function(){yepnope.apply(window,[].slice.call(arguments,0))};