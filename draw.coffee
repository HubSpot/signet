return unless window.console?.log?

getMetaList = (name) ->
    content = document.head.querySelector("meta[name='#{ name }']")?.content
    if content
        return (element.trim() for element in content.split(','))
    return undefined

authors = getMetaList("signet:authors")
links = getMetaList("signet:links")

hasStyledLogSupport = ->
    isSafari = -> /Safari/.test(navigator.userAgent) and /Apple Computer/.test(navigator.vendor)
    isOpera = -> /OPR/.test(navigator.userAgent) and /Opera/.test(navigator.vendor)
    isFF = -> /Firefox/.test(navigator.userAgent)
    isIE = -> /MSIE/.test(navigator.userAgent)

    # Safari starting supporting stylized logs in Nightly 537.38+
    # See https://github.com/adamschwartz/log/issues/6
    safariSupport = ->
        m = navigator.userAgent.match /AppleWebKit\/(\d+)\.(\d+)(\.|\+|\s)/
        return false unless m
        return 537.38 <= parseInt(m[1], 10) + (parseInt(m[2], 10) / 100)

    operaSupport = ->
        m = navigator.userAgent.match /OPR\/(\d+)\./
        return false unless m
        return 15 <= parseInt(m[1], 10)

    # Detect for Firebug http://stackoverflow.com/a/398120/131898
    ffSupport = ->
        window.console.firebug or window.console.exception

    (not isIE() and (not isFF() or ffSupport()) and (not isOpera() or operaSupport()) and (not isSafari() or safariSupport()))

supportsStyledLogs = hasStyledLogSupport()

drawSignet = ->
    return unless authors.length

    unless supportsStyledLogs
        console.log 'Authors:'
        console.log(author) for author in authors
        return

    canvasHeight = 480
    canvasWidth = document.body?.clientWidth or 480

    authorHeight = 20
    barHeight = authorHeight / 2
    barWidth = 60
    height = authors.length * authorHeight + 25

    repeatHack = 14
    lineHeightHack = -35
    leftOffsetHack = -24

    canvas = document.createElement 'canvas'
    canvas.height = 1000
    canvas.width = canvasWidth
    context = canvas.getContext '2d'

    context.font = '400 12px "Helvetica Neue", Helvetica, Arial, sans-serif'

    drawRectangle = (left, top, width, height, color) ->
        context.fillStyle = color
        context.fillRect left, top + repeatHack, width, height

    drawText = (text, top) ->
        context.fillStyle = '#444'
        context.fillText text, barWidth + 10, top + repeatHack

    drawRectangle 0, - repeatHack, canvasWidth, height, 'white'

    for author, i in authors
        drawText author, (authorHeight * i) + 14

        colors = author.replace(/\s/g, '')
        barTop = authorHeight * i + ((authorHeight - barHeight) / 2)

        for letter, j in colors
            individualBarLeft = Math.floor((barWidth * j) / colors.length)
            individualBarWidth = Math.ceil(((barWidth * (j + 1)) / colors.length) - individualBarLeft)
            hue = ((letter.toLowerCase().charCodeAt(0) * 2) + (colors.toLowerCase().charCodeAt(0) * 5)) % 256
            drawRectangle individualBarLeft, barTop, individualBarWidth, barHeight, 'hsl(' + hue + ', 80%, 80%)'

    # Debugging
    # drawRectangle 0, 0, canvasWidth, 1, 'red'
    # drawRectangle 0, 0, 1, canvasHeight, 'red'

    imageCSS = 'font-size: 0; line-height: ' + (height + lineHeightHack) + 'px; padding: ' + Math.floor(height / 2) + 'px ' + canvasWidth + 'px ' + (Math.ceil(height / 2)) + 'px 0; background-image: url("' + canvas.toDataURL() + '"); margin-left: ' + leftOffsetHack + 'px'
    console.log '%c ', imageCSS

drawLinks = ->
    return unless links.length

    unless supportsStyledLogs
        console.log(link) for link in links
        return

    IMAGES =
        'twitter.com': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAMAAAAolt3jAAABDlBMVEX6/P7Q4/qy0vfd7Pzz+P631fgAjO7B2/kAj+7d6/tnrvKTwvXE3florvI0nPAAhu2PwPXl7/yKvvTd6/xlrfIxmu8/n/ArmO9nrfL8/v/D3Pnc6vsclu+hyvZCoPD1+f4ale+mzPYAjO1mrfIume/y+P7l8PxPpvGozfcAk+7v9v3Z6Pvk7/zA2vkMlO4umu8tme9eqvFlrPIqmO8Aiu1DoPAkl+83nO/9/f/v9f11tPN5tvPs9P01m+8ml+++2fhvsfJ8t/P2+v4AkO5YqPEqme8Ake4zm++/2vkmmO8sme8Aju4vmu8ll+/8/f/+//8Aku40m+8nmO8Aje77/f8omO8pmO/9/v/+/v////82XKzkAAAAr0lEQVR42i2HhXJCQRRDLxQpWiq4Fajj7lbcn+5u/v9H2MdwJpnkEMQFEiHbEyDr3tI35BBe4zifMRps6uXtHyHwAsmwpVX07y+C7+ktkf1sn6rq7w8I/qCyyBTUDquti1JDB/X4rkxY87QrSX1erlb7D2YelQZAHGk9ykxTG+tTcBJIxjY7tu8e5sCFBMfDUgun8rN/CJCx9S5cj+tIzgAHCORx2502ByBg6R1uGa5fdzNEjg+lPgAAAABJRU5ErkJggg=='
        'github.com': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAMAAAAolt3jAAAA1VBMVEUTERIPDg8QDw8TDxMSEhIREREQEBATERETEBAREREQEBATEBMRERERERESEhISEBISEBIREBESERIREBAVFRUQDxAUDxQSERIUDw8TEBAREBASERIQDxASEBISEBIQEBAAAAAREREQDw8QDxAODg4TEBMVDhUQDxATEBMSEhIREBAREBATExMRDxEQEBASEBIRERESEhISEhISEhITERESEBIREBEREBESEhISEREAAAAUFBQAAAAAAAAAAAAQDw8SERITEhIQDw8RDxAQDw8REBASERLudflrAAAAP3RSTlP+/P5EHVs+iE9ZMW4sdmWRYtGa2yX0M4ozUd2L95udHwOG8ekkUST2UlbN3ijFEI5JHDpkiW/m5GaKAScEAgDgPKx8AAAApklEQVR42h3PxXLDUBBE0YnDzGiHOWaUZOldT5dq/v+XovLZ3t60JShni7pezEpIBtOQNxRTMHJvrdRYtTzHeuGjSTGfF5ORR89uFTes3YUKy9QfUKVUMegrs9CQtIRlYqiwWo+8VDQDnlTbgzpX0GS+3tW1tl+en2zB+OfP9Wrl9cVpbEMu1/eHcbZxuDmGe1f8YrDfzXZgT2+fsL6wewBHx8+Q/gFJwSeod8cM9gAAAABJRU5ErkJggg=='

    linksArgs = ['%c\n', 'line-height: 0; font-size: 0']
    linkFontSize = 12
    linkFontCharWidth = 7
    lineHeight = 16

    for link, i in links
        firstPartLength = (link.replace(/(https?:\/\/[^\/]+(\/|$))(.*)/, '$1')).length
        secondPartLength = link.length - firstPartLength

        for domain, img of IMAGES
            if (new RegExp("^(https?://)?(www\.)?#{ domain }/", 'i')).test(link)
                image = img
                break

        if image
            linksArgs[0] += "%c#{ link }%c %c %c\n"
            leftMargin = -linkFontCharWidth * (firstPartLength - 1) # Hide the domain part of the URL
        else
            linksArgs[0] += "%c#{ link }\n"
            leftMargin = linkFontCharWidth

        linksArgs.push "-webkit-font-smoothing: antialiased; font: 400 #{ linkFontSize }px monospace; margin-left: #{ leftMargin }px"

        if image
            charsOffset = 5
            leftMargin = -linkFontCharWidth * (secondPartLength + charsOffset) + 1 # Position this white text over part of the URL
            linksArgs.push "background: #fff; line-height: #{ lineHeight }px; padding: #{ (lineHeight / 2) + 2 }px #{ Math.floor(charsOffset / 2) * linkFontCharWidth }px #{ (lineHeight / 2) + 2 }px #{ Math.ceil(charsOffset / 2) * linkFontCharWidth }px; font-size: 0; margin-left: #{ leftMargin }px"

            leftMargin = -linkFontCharWidth * 3 # Position the logo over the slash part of the URL
            linksArgs.push "background: #fff url(#{ image }); line-height: #{ lineHeight }px; padding: 11px 14px 3px 0; font-size: 0; margin-left: #{ leftMargin }px"
            linksArgs.push ''

    console.log linksArgs...

setTimeout ->
    drawSignet()
    drawLinks()
, 0
