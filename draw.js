(function() {
  var authors, drawLinks, drawSignet, links, _ref, _ref1, _ref2, _ref3;

  authors = (_ref = document.head.querySelector('meta[name="signet:authors"]')) != null ? (_ref1 = _ref.content) != null ? _ref1.split(', ') : void 0 : void 0;

  links = (_ref2 = document.head.querySelector('meta[name="signet:links"]')) != null ? (_ref3 = _ref2.content) != null ? _ref3.split(', ') : void 0 : void 0;

  drawSignet = function() {
    var author, authorHeight, barHeight, barTop, barWidth, canvas, canvasHeight, canvasWidth, colors, context, drawRectangle, drawText, height, hue, i, imageCSS, individualBarLeft, individualBarWidth, j, leftOffsetHack, letter, lineHeightHack, repeatHack, _i, _j, _len, _len1, _ref4;
    if (!authors.length) {
      return;
    }
    canvasHeight = 480;
    canvasWidth = ((_ref4 = document.body) != null ? _ref4.clientWidth : void 0) || 480;
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
    for (i = _i = 0, _len = authors.length; _i < _len; i = ++_i) {
      author = authors[i];
      drawText(author, (authorHeight * i) + 14);
      colors = author.replace(/\s/g, '');
      barTop = authorHeight * i + ((authorHeight - barHeight) / 2);
      for (j = _j = 0, _len1 = colors.length; _j < _len1; j = ++_j) {
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
    var charsOffset, firstPartLength, githubImage, i, image, leftMargin, lineHeight, link, linkFontCharWidth, linkFontSize, linksArgs, secondPartLength, twitterImage, _i, _len;
    if (!links.length) {
      return;
    }
    twitterImage = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAMAAAAolt3jAAABDlBMVEX6/P7Q4/qy0vfd7Pzz+P631fgAjO7B2/kAj+7d6/tnrvKTwvXE3florvI0nPAAhu2PwPXl7/yKvvTd6/xlrfIxmu8/n/ArmO9nrfL8/v/D3Pnc6vsclu+hyvZCoPD1+f4ale+mzPYAjO1mrfIume/y+P7l8PxPpvGozfcAk+7v9v3Z6Pvk7/zA2vkMlO4umu8tme9eqvFlrPIqmO8Aiu1DoPAkl+83nO/9/f/v9f11tPN5tvPs9P01m+8ml+++2fhvsfJ8t/P2+v4AkO5YqPEqme8Ake4zm++/2vkmmO8sme8Aju4vmu8ll+/8/f/+//8Aku40m+8nmO8Aje77/f8omO8pmO/9/v/+/v////82XKzkAAAAr0lEQVR42i2HhXJCQRRDLxQpWiq4Fajj7lbcn+5u/v9H2MdwJpnkEMQFEiHbEyDr3tI35BBe4zifMRps6uXtHyHwAsmwpVX07y+C7+ktkf1sn6rq7w8I/qCyyBTUDquti1JDB/X4rkxY87QrSX1erlb7D2YelQZAHGk9ykxTG+tTcBJIxjY7tu8e5sCFBMfDUgun8rN/CJCx9S5cj+tIzgAHCORx2502ByBg6R1uGa5fdzNEjg+lPgAAAABJRU5ErkJggg==';
    githubImage = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAMAAAAolt3jAAAA1VBMVEUTERIPDg8QDw8TDxMSEhIREREQEBATERETEBAREREQEBATEBMRERERERESEhISEBISEBIREBESERIREBAVFRUQDxAUDxQSERIUDw8TEBAREBASERIQDxASEBISEBIQEBAAAAAREREQDw8QDxAODg4TEBMVDhUQDxATEBMSEhIREBAREBATExMRDxEQEBASEBIRERESEhISEhISEhITERESEBIREBEREBESEhISEREAAAAUFBQAAAAAAAAAAAAQDw8SERITEhIQDw8RDxAQDw8REBASERLudflrAAAAP3RSTlP+/P5EHVs+iE9ZMW4sdmWRYtGa2yX0M4ozUd2L95udHwOG8ekkUST2UlbN3ijFEI5JHDpkiW/m5GaKAScEAgDgPKx8AAAApklEQVR42h3PxXLDUBBE0YnDzGiHOWaUZOldT5dq/v+XovLZ3t60JShni7pezEpIBtOQNxRTMHJvrdRYtTzHeuGjSTGfF5ORR89uFTes3YUKy9QfUKVUMegrs9CQtIRlYqiwWo+8VDQDnlTbgzpX0GS+3tW1tl+en2zB+OfP9Wrl9cVpbEMu1/eHcbZxuDmGe1f8YrDfzXZgT2+fsL6wewBHx8+Q/gFJwSeod8cM9gAAAABJRU5ErkJggg==';
    linksArgs = [''];
    linksArgs[0] += '%c\n';
    linksArgs.push('line-height: 0; font-size: 0');
    linkFontSize = 12;
    linkFontCharWidth = 7;
    lineHeight = 16;
    for (i = _i = 0, _len = links.length; _i < _len; i = ++_i) {
      link = links[i];
      firstPartLength = (link.replace(/(https?:\/\/\w+\.\w+\/)(.+)/, '$1')).length;
      secondPartLength = link.length - firstPartLength;
      linksArgs[0] += "%c" + link + "%c %c %c\n";
      image = /twitter/.test(link) ? twitterImage : /github/.test(link) ? githubImage : '';
      leftMargin = -linkFontCharWidth * (firstPartLength - 1);
      linksArgs.push("-webkit-font-smoothing: antialiased; font: 400 " + linkFontSize + "px monospace; margin-left: " + leftMargin + "px");
      charsOffset = 5;
      leftMargin = -linkFontCharWidth * (secondPartLength + charsOffset) + 1;
      linksArgs.push("background: #fff; line-height: " + lineHeight + "px; padding: " + ((lineHeight / 2) + 2) + "px " + (Math.floor(charsOffset / 2) * linkFontCharWidth) + "px " + ((lineHeight / 2) + 2) + "px " + (Math.ceil(charsOffset / 2) * linkFontCharWidth) + "px; font-size: 0; margin-left: " + leftMargin + "px");
      leftMargin = -linkFontCharWidth * 3;
      linksArgs.push("background: #fff url(" + image + "); line-height: " + lineHeight + "px; padding: 11px 14px 3px 0; font-size: 0; margin-left: " + leftMargin + "px");
      linksArgs.push('');
    }
    return console.log.apply(console, linksArgs);
  };

  setTimeout(function() {
    drawSignet();
    return drawLinks();
  }, 0);

}).call(this);
