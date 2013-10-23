(function() {
  var authors, drawLinks, drawSignet, getMetaList, hasStyledLogSupport, links, supportsStyledLogs, _ref;

  if (((_ref = window.console) != null ? _ref.log : void 0) == null) {
    return;
  }

  getMetaList = function(name) {
    var content, element, _ref1;
    content = (_ref1 = document.head.querySelector("meta[name='" + name + "']")) != null ? _ref1.content : void 0;
    if (content) {
      return (function() {
        var _i, _len, _ref2, _results;
        _ref2 = content.split(',');
        _results = [];
        for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
          element = _ref2[_i];
          _results.push(element.trim());
        }
        return _results;
      })();
    }
    return void 0;
  };

  authors = getMetaList("signet:authors");

  links = getMetaList("signet:links");

  hasStyledLogSupport = function() {
    var ffSupport, isFF, isIE, isOpera, isSafari, operaSupport, safariSupport;
    isSafari = function() {
      return /Safari/.test(navigator.userAgent) && /Apple Computer/.test(navigator.vendor);
    };
    isOpera = function() {
      return /OPR/.test(navigator.userAgent) && /Opera/.test(navigator.vendor);
    };
    isFF = function() {
      return /Firefox/.test(navigator.userAgent);
    };
    isIE = function() {
      return /MSIE/.test(navigator.userAgent);
    };
    safariSupport = function() {
      var m;
      m = navigator.userAgent.match(/AppleWebKit\/(\d+)\.(\d+)(\.|\+|\s)/);
      if (!m) {
        return false;
      }
      return 537.38 <= parseInt(m[1], 10) + (parseInt(m[2], 10) / 100);
    };
    operaSupport = function() {
      var m;
      m = navigator.userAgent.match(/OPR\/(\d+)\./);
      if (!m) {
        return false;
      }
      return 15 <= parseInt(m[1], 10);
    };
    ffSupport = function() {
      return window.console.firebug || window.console.exception;
    };
    return !isIE() && (!isFF() || ffSupport()) && (!isOpera() || operaSupport()) && (!isSafari() || safariSupport());
  };

  supportsStyledLogs = hasStyledLogSupport();

  drawSignet = function() {
    var author, authorHeight, barHeight, barTop, barWidth, canvas, canvasHeight, canvasWidth, colors, context, drawRectangle, drawText, height, hue, i, imageCSS, individualBarLeft, individualBarWidth, j, leftOffsetHack, letter, lineHeightHack, repeatHack, _i, _j, _k, _len, _len1, _len2, _ref1;
    if (!authors.length) {
      return;
    }
    if (!supportsStyledLogs) {
      console.log('Authors:');
      for (_i = 0, _len = authors.length; _i < _len; _i++) {
        author = authors[_i];
        console.log(author);
      }
      return;
    }
    canvasHeight = 480;
    canvasWidth = ((_ref1 = document.body) != null ? _ref1.clientWidth : void 0) || 480;
    authorHeight = 20;
    barHeight = authorHeight / 2;
    barWidth = 60;
    height = authors.length * authorHeight + 25;
    repeatHack = 14;
    lineHeightHack = -35;
    leftOffsetHack = -24;
    canvas = document.createElement('canvas');
    canvas.height = 1000;
    canvas.width = canvasWidth;
    context = canvas.getContext('2d');
    context.font = '400 12px "Helvetica Neue", Helvetica, Arial, sans-serif';
    drawRectangle = function(left, top, width, height, color) {
      context.fillStyle = color;
      return context.fillRect(left, top + repeatHack, width, height);
    };
    drawText = function(text, top) {
      context.fillStyle = '#444';
      return context.fillText(text, barWidth + 10, top + repeatHack);
    };
    drawRectangle(0, -repeatHack, canvasWidth, height, 'white');
    for (i = _j = 0, _len1 = authors.length; _j < _len1; i = ++_j) {
      author = authors[i];
      drawText(author, (authorHeight * i) + 14);
      colors = author.replace(/\s/g, '');
      barTop = authorHeight * i + ((authorHeight - barHeight) / 2);
      for (j = _k = 0, _len2 = colors.length; _k < _len2; j = ++_k) {
        letter = colors[j];
        individualBarLeft = Math.floor((barWidth * j) / colors.length);
        individualBarWidth = Math.ceil(((barWidth * (j + 1)) / colors.length) - individualBarLeft);
        hue = ((letter.toLowerCase().charCodeAt(0) * 2) + (colors.toLowerCase().charCodeAt(0) * 5)) % 256;
        drawRectangle(individualBarLeft, barTop, individualBarWidth, barHeight, 'hsl(' + hue + ', 80%, 80%)');
      }
    }
    imageCSS = 'font-size: 0; line-height: ' + (height + lineHeightHack) + 'px; padding: ' + Math.floor(height / 2) + 'px ' + canvasWidth + 'px ' + (Math.ceil(height / 2)) + 'px 0; background-image: url("' + canvas.toDataURL() + '"); margin-left: ' + leftOffsetHack + 'px';
    return console.log('%c ', imageCSS);
  };

  drawLinks = function() {
    var IMAGES, charsOffset, domain, domainLength, i, image, img, leftMargin, lineHeight, link, linkFontCharWidth, linkFontSize, linksArgs, pathLength, _i, _j, _len, _len1;
    if (!links.length) {
      return;
    }
    if (!supportsStyledLogs) {
      for (_i = 0, _len = links.length; _i < _len; _i++) {
        link = links[_i];
        console.log(link);
      }
      return;
    }
    IMAGES = {
      'twitter.com': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAMAAAAolt3jAAABDlBMVEX6/P7Q4/qy0vfd7Pzz+P631fgAjO7B2/kAj+7d6/tnrvKTwvXE3florvI0nPAAhu2PwPXl7/yKvvTd6/xlrfIxmu8/n/ArmO9nrfL8/v/D3Pnc6vsclu+hyvZCoPD1+f4ale+mzPYAjO1mrfIume/y+P7l8PxPpvGozfcAk+7v9v3Z6Pvk7/zA2vkMlO4umu8tme9eqvFlrPIqmO8Aiu1DoPAkl+83nO/9/f/v9f11tPN5tvPs9P01m+8ml+++2fhvsfJ8t/P2+v4AkO5YqPEqme8Ake4zm++/2vkmmO8sme8Aju4vmu8ll+/8/f/+//8Aku40m+8nmO8Aje77/f8omO8pmO/9/v/+/v////82XKzkAAAAr0lEQVR42i2HhXJCQRRDLxQpWiq4Fajj7lbcn+5u/v9H2MdwJpnkEMQFEiHbEyDr3tI35BBe4zifMRps6uXtHyHwAsmwpVX07y+C7+ktkf1sn6rq7w8I/qCyyBTUDquti1JDB/X4rkxY87QrSX1erlb7D2YelQZAHGk9ykxTG+tTcBJIxjY7tu8e5sCFBMfDUgun8rN/CJCx9S5cj+tIzgAHCORx2502ByBg6R1uGa5fdzNEjg+lPgAAAABJRU5ErkJggg==',
      'github.com': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAMAAAAolt3jAAAA1VBMVEUTERIPDg8QDw8TDxMSEhIREREQEBATERETEBAREREQEBATEBMRERERERESEhISEBISEBIREBESERIREBAVFRUQDxAUDxQSERIUDw8TEBAREBASERIQDxASEBISEBIQEBAAAAAREREQDw8QDxAODg4TEBMVDhUQDxATEBMSEhIREBAREBATExMRDxEQEBASEBIRERESEhISEhISEhITERESEBIREBEREBESEhISEREAAAAUFBQAAAAAAAAAAAAQDw8SERITEhIQDw8RDxAQDw8REBASERLudflrAAAAP3RSTlP+/P5EHVs+iE9ZMW4sdmWRYtGa2yX0M4ozUd2L95udHwOG8ekkUST2UlbN3ijFEI5JHDpkiW/m5GaKAScEAgDgPKx8AAAApklEQVR42h3PxXLDUBBE0YnDzGiHOWaUZOldT5dq/v+XovLZ3t60JShni7pezEpIBtOQNxRTMHJvrdRYtTzHeuGjSTGfF5ORR89uFTes3YUKy9QfUKVUMegrs9CQtIRlYqiwWo+8VDQDnlTbgzpX0GS+3tW1tl+en2zB+OfP9Wrl9cVpbEMu1/eHcbZxuDmGe1f8YrDfzXZgT2+fsL6wewBHx8+Q/gFJwSeod8cM9gAAAABJRU5ErkJggg=='
    };
    linksArgs = ['%c\n', 'line-height: 0; font-size: 0'];
    linkFontSize = 12;
    linkFontCharWidth = 7;
    lineHeight = 16;
    for (i = _j = 0, _len1 = links.length; _j < _len1; i = ++_j) {
      link = links[i];
      domainLength = (link.replace(/(https?:\/\/[^\/]+(\/|$))(.*)/, '$1')).length;
      pathLength = link.length - domainLength;
      image = null;
      for (domain in IMAGES) {
        img = IMAGES[domain];
        if ((new RegExp("^(https?://)?(www\.)?" + domain + "/", 'i')).test(link)) {
          image = img;
          break;
        }
      }
      if (image) {
        linksArgs[0] += "%c" + link + "%c %c %c\n";
        leftMargin = -linkFontCharWidth * (domainLength - 1);
      } else {
        linksArgs[0] += "%c" + link + "\n";
        leftMargin = linkFontCharWidth;
      }
      linksArgs.push("-webkit-font-smoothing: antialiased; font: 400 " + linkFontSize + "px monospace; margin-left: " + leftMargin + "px");
      if (image) {
        charsOffset = 5;
        leftMargin = -linkFontCharWidth * (pathLength + charsOffset) + 1;
        linksArgs.push("background: #fff; line-height: " + lineHeight + "px; padding: " + ((lineHeight / 2) + 2) + "px " + (Math.floor(charsOffset / 2) * linkFontCharWidth) + "px " + ((lineHeight / 2) + 2) + "px " + (Math.ceil(charsOffset / 2) * linkFontCharWidth) + "px; font-size: 0; margin-left: " + leftMargin + "px");
        leftMargin = -linkFontCharWidth * 3;
        linksArgs.push("background: #fff url(" + image + "); line-height: " + lineHeight + "px; padding: 11px 14px 3px 0; font-size: 0; margin-left: " + leftMargin + "px");
        linksArgs.push('');
      }
    }
    return console.log.apply(console, linksArgs);
  };

  setTimeout(function() {
    drawSignet();
    return drawLinks();
  }, 0);

}).call(this);
