(function(){try{var b={pluginName:"mention"};G_DEPlugin.mention=b;b.event={onLoadedMentionPlugin:DEXTTOP.DEXTWIN.dext_editor_loaded_mention_plugin_event,onEnableMentionEvent:DEXTTOP.DEXTWIN.dext_editor_enable_mention_event,onClickedMentionListEvent:DEXTTOP.DEXTWIN.dext_editor_clicked_mention_event,onBeforeCreateMentionList:DEXTTOP.DEXTWIN.dext_editor_before_create_mention_list_event};b.execInfo={mentionStart:!1,last:{node:null,mentionString:null},startText:"@",allowMentionRegExp:"a-z|A-Z|0-9|\u3131-\u314e|\uac00-\ud7a3",
cursorNodeId:["de_cursor1","de_cursor2"],browserBugFix:{deleteBug:!1}};b.mentionListUI={listID:"dext_mention_iframe"+DEXTTOP.G_CURREDITOR._config.editor_id,bgId:"dext_context_background"+DEXTTOP.G_CURREDITOR._config.editor_id,zIndex:G_MAIN_ZINDEX+2E3,bgZIndex:G_MAIN_ZINDEX+1E3,width:"120px",selectedClass:"mListSelected",mentionList:null,mentionListFooter:null};b.mentionUI={cssId:"keMentionCss",className:"KE_Mention"};b.onInit=function(){var a="../plugin/mention/js"+(DEXTTOP.DEXT5.isRelease?"":"_dev")+
"/config.js",a="1"==DEXTTOP.G_CURREDITOR._config.useConfigTimeStamp?a+("?t="+DEXTTOP.DEXT5.util.getTimeStamp()):a+("?t="+DEXTTOP.DEXT5.UrlStamp),c=document.getElementsByTagName("head")[0],d=document.createElement("script");d.type="text/javascript";d.src=a;d.onload=b.configLoaded;c.appendChild(d)};b.configLoaded=function(){"string"==typeof b.config.allowMentionRegExp&&(b.execInfo.allowMentionRegExp=b.config.allowMentionRegExp);"string"==typeof b.config.listUI.width&&(b.mentionListUI.width=b.config.listUI.width);
"string"==typeof b.config.listUI.selectedClass&&(b.mentionListUI.selectedClass=b.config.listUI.selectedClass);for(var a in b.config.event)null!=b.config.event[a]&&(b.event[a]=b.config.event[a]);"string"==typeof b.config.appliedMentionClass&&(b.mentionUI.className=b.config.appliedMentionClass);null!=b.config.listUI.mentionList&&b.updateMentionList(b.config.listUI.mentionList);b.overrideFn()};b.onLoaded=function(){b.addMentionCss();b.createMentionListFrame();if("function"==typeof b.event.onLoadedMentionPlugin)b.event.onLoadedMentionPlugin(b)};
b.onKeyDown=function(a){a=a.evt;if(a.key==b.execInfo.startText){var c=!1,d=getFirstRange();a=d.range;d=d.sel;if(a.startContainer)if(3==a.startContainer.nodeType){var e=a.startContainer.textContent;if(0==e.length)c=!0;else if(0==a.startOffset&&null==a.startContainer.previousSibling)c=!0;else if(e=e.charAt(a.startOffset-1),"\u00a0"==e||" "==e)c=!0}else if(1==a.startContainer.nodeType){e="";if(0==a.startOffset)for(var f=a.startContainer,g=getClientRect(f);f.previousSibling;){var h=getClientRect(f.previousSibling);
if(g.top==h.top)e+=f.previousSibling.textContent,f=f.previousSibling;else break}else e=a.startContainer.textContent;if(0==e.length)c=!0;else if("\u00a0"==e.charAt(e.length-1)||" "==e.charAt(e.length-1))c=!0}if(c)return b.mentionStart(!0),c=b.createMentionNode(),a.insertNode(c),a.setStart(c,1),a.setEnd(c,1),d.removeAllRanges(),d.addRange(a),!1}else if("ArrowUp"==a.key||"ArrowDown"==a.key){if(b.isActiveMentionListFrame())return b.selectMentionInListFrame(a.key),!1}else if("Enter"==a.key){if(b.isActiveMentionListFrame())return b.getSelectedMentionInListFrame().click(),
!1}else if("Backspace"==a.key){a=getFirstRange().range;try{a.collapsed&&(c=a.startContainer,d=c.childNodes[a.startOffset],b.isMentionNode(d)&&c.previousSibling&&(b.execInfo.browserBugFix.deleteBug=!0,d.contentEditable=!0))}catch(l){DEXTTOP&&DEXTTOP.DEXT5&&DEXTTOP.DEXT5.logMode&&window&&window.console&&console.log(l)}}};b.onKeyUp=function(a){a=a.evt;if(1==b.execInfo.mentionStart){if("Enter"==a.key){b.mentionStart(!1);return}if("Escape"==a.key){b.mentionStart(!1);return}a=getFirstRange().range;a=a.startContainer;
3==a.nodeType&&(a=a.parentNode);if("1"==a.getAttribute("dm")){var c=b.getMentionData(a);if((new RegExp("[^"+b.execInfo.allowMentionRegExp+"]","g")).test(c)){b.mentionStart(!1);return}if(b.execInfo.last.node!=a||c!=b.execInfo.last.mentionString)if(b.execInfo.last.mentionString=c,b.execInfo.last.node=a,a={mentionData:c},"function"==typeof b.event.onEnableMentionEvent)b.event.onEnableMentionEvent(b,a);else b.showMentionListFrame(c)}else b.mentionStart(!1)}else if(b.setCaretBetweenMentionNode(),"Backspace"==
a.key&&b.execInfo.browserBugFix.deleteBug){var d=getFirstRange();a=d.range;d=d.sel;try{b.execInfo.browserBugFix.deleteBug=!1,c=a.startContainer,3==c.nodeType&&(c=c.parentNode,b.isMentionNode(c)&&(c.contentEditable=!1,a.setStartBefore(c),a.setEndBefore(c),d.removeAllRanges(),d.addRange(a)))}catch(e){DEXTTOP&&DEXTTOP.DEXT5&&DEXTTOP.DEXT5.logMode&&window&&window.console&&console.log(e)}}b.execInfo.browserBugFix.deleteBug&&(b.execInfo.browserBugFix.deleteBug=!1)};b.onInput=function(a){if(DEXTTOP.DEXT5.browser.mobile){a=
a.evt;if(0==b.execInfo.mentionStart&&a.data==b.execInfo.startText){var c=!1,d=getFirstRange(),e=d.range,d=d.sel;if(e.startContainer)if(3==e.startContainer.nodeType){var f=e.startContainer.textContent;if(1==f.length)c=!0;else if(1==e.startOffset&&null==e.startContainer.previousSibling)c=!0;else if(f=f.charAt(e.startOffset-2),"\u00a0"==f||" "==f)c=!0}else if(1==e.startContainer.nodeType){f="";if(0==e.startOffset)for(var g=e.startContainer,h=getClientRect(g);g.previousSibling;){var l=getClientRect(g.previousSibling);
if(h.top==l.top)f+=g.previousSibling.textContent,g=g.previousSibling;else break}else f=e.startContainer.textContent;if(1==f.length)c=!0;else if("\u00a0"==f.charAt(f.length-2)||" "==f.charAt(f.length-2))c=!0}c&&(e.startContainer.data=e.startContainer.data.replace(new RegExp(a.data+"$","g"),""),e.setStart(e.startContainer,e.startContainer.length),e.setEnd(e.endContainer,e.endContainer.length),d.removeAllRanges(),d.addRange(e),d=getFirstRange(),e=d.range,d=d.sel,b.mentionStart(!0),c=b.createMentionNode(),
e.insertNode(c),e.setStart(c,1),e.setEnd(c,1),d.removeAllRanges(),d.addRange(e))}if(1==b.execInfo.mentionStart)if("Enter"==a.key)b.mentionStart(!1);else if(e=getFirstRange().range,a=e.startContainer,3==a.nodeType&&(a=a.parentNode),"1"==a.getAttribute("dm"))if(e=b.getMentionData(a),(new RegExp("[^"+b.execInfo.allowMentionRegExp+"]","g")).test(e))b.mentionStart(!1);else{if(b.execInfo.last.node!=a||e!=b.execInfo.last.mentionString){b.execInfo.last.mentionString=e;b.execInfo.last.node=a;a={mentionData:e};
try{b.event.onEnableMentionEvent(b,a)}catch(k){DEXTTOP&&DEXTTOP.DEXT5&&DEXTTOP.DEXT5.logMode&&window&&window.console&&console.log(k)}}}else b.mentionStart(!1)}};b.onMouseUp=function(a){var c=getFirstRange(),d=c.range,c=c.sel;a=d.startContainer;3==a.nodeType&&(a=a.parentNode);d=a.getAttribute("dm");null!=d&&"1"==d||1!=b.execInfo.mentionStart||b.mentionStart(!1);if(d&&"2"==d)return c=getFirstRange(),d=c.range,c=c.sel,d.setStartAfter(a),d.setEndAfter(a),c.removeAllRanges(),c.addRange(d),b.setCaretBetweenMentionNode(),
!1};b.createMentionNode=function(a){if(a)return'<span dm="1">'+b.execInfo.startText+"</span>";a=_iframeDoc.createElement("span");a.innerHTML=b.execInfo.startText;a.setAttribute("dm","1");return a};b.removeMentionNode=function(){for(var a=_iframeDoc.querySelectorAll('[dm="1"]'),b=0,d=a.length;b<d;b++){for(;a[b].hasChildNodes();)a[b].parentNode.insertBefore(a[b].firstChild,a[b]);a[b].parentNode.removeChild(a[b])}};b.initCheckLastNode=function(){b.execInfo.last.node=null;b.execInfo.last.mentionString=
null};b.removeMentionAndAdjustCaret=function(){var a=getFirstRange(),c=a.sel,d=a.range;if(1==d.collapsed){var e=_iframeDoc.createElement("span");e.id=b.execInfo.cursorNodeId[0];d.insertNode(e);b.removeMentionNode();d.setStartBefore(e);d.setEndBefore(e)}else a=d.cloneRange(),e=_iframeDoc.createElement("span"),e.id=b.execInfo.cursorNodeId[1],d.collapse(!1),d.insertNode(e),c.removeAllRanges(),c.addRange(a),a=getFirstRange(),d=a.range,c=a.sel,a=_iframeDoc.createElement("span"),a.id=b.execInfo.cursorNodeId[0],
d.collapse(!0),d.insertNode(a),b.removeMentionNode(),d.setStartBefore(a),d.setEndBefore(e),a.parentNode.removeChild(a);e.parentNode.removeChild(e);c.removeAllRanges();c.addRange(d)};b.getMention=function(a){var b=null;(a=a?a:DEXTTOP.G_CURREDITOR._DOC.querySelector('[dm="1"]'))&&(b=a);return b};b.getMentionData=function(a){var c=null;if(a=b.getMention(a))c=a.innerHTML,c=c.replace(b.execInfo.startText,"");return c};b.mentionStart=function(a){b.execInfo.mentionStart=a;!1===a&&(b.removeMentionAndAdjustCaret(),
b.hiddenMentionListFrame(),b.initCheckLastNode())};b.createMentionListFrame=function(){var a=getDialogDocument(),c=b.getMentionListFrame();c&&c.parentNode.removeChild(c);try{c=a.createElement("iframe")}catch(d){c=a.createElement("<iframe>")}a.body.appendChild(c);c.id=b.mentionListUI.listID;c.title="RAON K Editor mention "+DEXTTOP.G_CURREDITOR._config.editor_id;c.style.margin="0px";c.style.padding="0px";c.style.zIndex=b.mentionListUI.zIndex;c.style.position="absolute";c.scrolling="no";c.style.overflow=
"auto";c.style.overflowX="hidden";c.style.display="none";c.allowTransparency="true";c.frameBorder="0";a="document.open();"+(isCustomDomain(document)?'document.domain="'+document.domain+'";':"")+" document.close();";a=DEXTTOP.DEXT5.browser.ie&&12>DEXTTOP.DEXT5.browser.ieVersion?"javascript:void(function(){"+encodeURIComponent(a)+"}())":"";c.src=a;a=DEXTTOP.G_CURREDITOR._config.lang;-1<a.indexOf("-")&&(a=a.split("-")[0]);for(var a=""+('<html lang="'+a+'" xml:lang="'+a+'"><head>')+"<title>RAON K Editor Mention List</title>",
e=b.config.listUI.css,f=0;f<e.length;f++){var g='<link rel="stylesheet" type="text/css" href="{cssHref}?t='+DEXTTOP.DEXT5.UrlStamp+'" charset="utf-8">',h=e[f];0!=h.indexOf("/")&&0!=h.indexOf("http")&&(h=b.getPluginCssUrl(h));g=g.replace("{cssHref}",h);a+=g}a+="</head>";a+='<body style="margin:0; padding:0;">';a+='<div id="mentionContainer" class="mentionContainer" style="width: '+b.mentionListUI.width+';">';a+='<div id="mentionBody" class="mentionBody"></div>';a+='<div id="mentionFooter" class="mentionFooter"></div>';
a+="</div>";a+="</body></html>";c=c.contentWindow.document;c.open("text/html","replace");isCustomDomain(document)&&(c.domain=document.domain);c.write(a);c.close()};b.showMentionListFrame=function(a){var c=getDialogDocument(),d=b.getMentionListFrame(),e=b.getMention(),f=d.contentWindow.document,g=f.getElementById("mentionBody");g.innerHTML="";var h=b.mentionListUI.mentionList;"string"==typeof a&&""!=a&&(h=h.filter(function(b){return b.displayName.toLowerCase().includes(a.toLowerCase())}).sort(function(b,
c){return b.displayName.toLowerCase().indexOf(a.toLowerCase())>c.displayName.toLowerCase().indexOf(a.toLowerCase())?1:b.displayName.toLowerCase().indexOf(a.toLowerCase())<c.displayName.toLowerCase().indexOf(a.toLowerCase())?-1:b.displayName>c.displayName?1:-1}));for(var l=h.length,k=0;k<l;k++){var m=null;"function"==typeof b.event.onBeforeCreateMentionList&&(m=b.event.onBeforeCreateMentionList(b,h[k]));0==!!m&&(m=c.createElement("div"),m.innerHTML=h[k].displayName,m.className="mList");0==k&&m.classList.add(b.mentionListUI.selectedClass);
m.onclick=function(a){return function(c){c=h[a];"function"==typeof b.event.onClickedMentionListEvent?null!==b.event.onClickedMentionListEvent(b,{selectedMention:c})&&b.setMention(c):b.setMention(c)}}(k);g.appendChild(m)}c=f.getElementById("mentionFooter");c.innerHTML="";null!=b.mentionListUI.mentionListFooter&&c.appendChild(b.mentionListUI.mentionListFooter);setZoomValueToBody(f,DEXTTOP.G_CURREDITOR);d.style.display="";f=f.getElementById("mentionContainer");f=getClientRect(f);d.style.width=f.width+
"px";d.style.height=f.height+"px";c=getDialogWindow();f={};f=getWindowScrollPos(c);l=getClientRect(_iframeWin.parent.frameElement);k=getClientRect(_iframeWin.frameElement);m=g=0;if(null!=DEXTTOP.G_CURREDITOR.dialogWindow)for(var n=_iframeWin.parent.parent;n!=c;)var p=getClientRect(n.frameElement),g=g+p.left,m=m+p.top,n=n.parent;e=getClientRect(e);p=Math.round(e.left);n=Math.round(e.bottom);g=p+k.left+l.left+g+f[0]+5;l=n+k.top+l.top+m+f[1]+4;k=getWindowClientSize(c);c=f[0]+k[0]-20;f=f[1]+k[1]-10;k=
getClientRect(d);c=g+k.width-c;0<=c&&(g=g-c-2);0<l+k.height-f&&(l=l-e.height-k.height-4);d.style.left=g+"px";d.style.top=l+"px"};b.hiddenMentionListFrame=function(){b.getMentionListFrame().style.display="none"};b.isActiveMentionListFrame=function(){var a=!1,c=b.getMentionListFrame();c&&""==c.style.display&&(a=!0);return a};b.getMentionListFrame=function(){return getDialogDocument().getElementById(b.mentionListUI.listID)};b.setMention=function(a){var c=b.getMention();c.innerHTML="@"+a.displayName;
c.contentEditable=!1;c.setAttribute("dm","2");c.className=b.mentionUI.className;b.execInfo.mentionStart=!1;b.initCheckLastNode();var d=_iframeDoc.createTextNode("\u00a0");c.nextSibling?c.parentNode.insertBefore(d,c.nextSibling):c.parentNode.appendChild(d);if(a.attributes)for(var e in a.attributes)c.setAttribute(e,a.attributes[e]);b.hiddenMentionListFrame();c=getFirstRange();a=c.range;c=c.sel;a.setStart(d,1);a.setEnd(d,1);c.removeAllRanges();c.addRange(a);_iframeDoc.body.focus()};b.onBeforeGetApi=
function(a){!0!==a.isAuto&&(b.mentionStart(!1),b.removeMentionCss())};b.onAfterGetApi=function(a){!0!==a.isAuto&&b.addMentionCss()};b.onAfterDocumentWrite=function(a){b.clearMention();b.addMentionCss()};b.clearMention=function(){b.removeMentionNode();for(var a=b.execInfo.cursorNodeId,c=0;c<a.length;c++){var d=_iframeDoc.querySelector("#"+a[c]);d&&d.parentNode.removeChild(d)}b.initCheckLastNode()};b.isExistMentionCss=function(){return _iframeDoc.querySelector("#"+b.mentionUI.cssId)?!0:!1};b.addMentionCss=
function(){if(0==b.isExistMentionCss()){var a=b.config.appliedMentionCss;0!=a.indexOf("/")&&0!=a.indexOf("http")&&(a=b.getPluginCssUrl(a));var c=_iframeDoc.getElementsByTagName("head")[0],d=_iframeDoc.createElement("link");d.type="text/css";d.rel="stylesheet";d.href=a;d.id=b.mentionUI.cssId;c.appendChild(d)}};b.removeMentionCss=function(){var a=_iframeDoc.querySelector("#"+b.mentionUI.cssId);a&&a.parentNode.removeChild(a)};b.getPluginCssUrl=function(a){var b=DEXTTOP.G_CURREDITOR._config.webPath.plugin+
"mention/",b=DEXTTOP.DEXT5.isRelease?b+"css/":b+"css_dev/";return b+a};b.updateMentionList=function(a){b.mentionListUI.mentionList=a};b.insertMention=function(a){b.getMention()&&b.setMention(a)};b.selectMentionInListFrame=function(a){var c=b.getMentionListFrame().contentWindow.document.querySelector("#mentionBody"),d=b.mentionListUI.selectedClass;if(c=c.querySelector("."+d)){var e="";"ArrowUp"==a?e="previousSibling":"ArrowDown"==a&&(e="nextSibling");if(a=c[e])c.classList.remove(d),a.classList.add(d)}};
b.getSelectedMentionInListFrame=function(){return b.getMentionListFrame().contentWindow.document.querySelector("#mentionBody").querySelector("."+b.mentionListUI.selectedClass)};b.onDestroy=function(){var a=b.getMentionListFrame();try{DEXTTOP.DEXT5.util.removeElementWithChildNodes(a)}catch(c){DEXTTOP&&DEXTTOP.DEXT5&&DEXTTOP.DEXT5.logMode&&window&&window.console&&console.log(c)}};b.overrideFn=function(){var a=DoExecuteCommand;DoExecuteCommand=function(c,d,e,f){b.tempChangeContentEditable(!0,_iframeDoc);
a(c,d,e,f);b.tempChangeContentEditable(!1,_iframeDoc)};var c=command_insertOrderedList;command_insertOrderedList=function(a,d){b.tempChangeContentEditable(!0,_iframeDoc);c(a,d);b.tempChangeContentEditable(!1,_iframeDoc)};var d=command_insertUnOrderedList;command_insertUnOrderedList=function(a,c){b.tempChangeContentEditable(!0,_iframeDoc);d(a,c);b.tempChangeContentEditable(!1,_iframeDoc)};var e=command_listNumberBullets;command_listNumberBullets=function(a,c,d,f){b.tempChangeContentEditable(!0,_iframeDoc);
e(a,c,d,f);b.tempChangeContentEditable(!1,_iframeDoc)};var f=command_pasteHtml5_After;command_pasteHtml5_After=function(a,c,d){if(RegExp('<span .*dm="2"?[^>].*?>',"gi").test(a)){a=a.replace(/<br class="Apple-interchange-newline">/gi,"");var e=document.createElement("div");e.innerHTML=a;b.tempChangeContentEditable(!0,e);a=e.innerHTML}f(a,c,d);b.tempChangeContentEditable(!1,_iframeDoc)}};b.tempChangeContentEditable=function(a,b){for(var d=b.querySelectorAll('[dm="2"]'),e=d.length,f=0;f<e;f++)d[f].contentEditable=
a};b.isMentionNode=function(a){var b=!1;"1"==a.nodeType&&"2"==a.getAttribute("dm")&&(b=!0);return b};b.setCaretBetweenMentionNode=function(){var a=getFirstRange(),c=a.range,a=a.sel;if(c.collapsed)try{var d=c.startContainer;if(1==d.nodeType){var e=d.childNodes[c.startOffset];if(b.isMentionNode(e)&&b.isMentionNode(d.childNodes[c.startOffset-1])){var f=_iframeDoc.createElement("span"),g=_iframeDoc.createTextNode("\u00a0");f.appendChild(g);d.insertBefore(f,d.childNodes[c.startOffset]);c.setStart(f,0);
c.setEnd(f,0);a.removeAllRanges();a.addRange(c);f.removeChild(g)}else"SPAN"==e.tagName&&""==e.innerHTML&&(f=e,g=_iframeDoc.createTextNode("\u00a0"),f.appendChild(g),c.setStart(f,0),c.setEnd(f,0),a.removeAllRanges(),a.addRange(c),f.removeChild(g))}}catch(h){DEXTTOP&&DEXTTOP.DEXT5&&DEXTTOP.DEXT5.logMode&&window&&window.console&&console.log(h)}};b.onInit()}catch(q){DEXTTOP&&DEXTTOP.DEXT5&&DEXTTOP.DEXT5.logMode&&window&&window.console&&console.log(q)}})();