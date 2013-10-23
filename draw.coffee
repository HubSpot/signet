authors = document.head.querySelector('meta[name="signet:authors"]')?.content?.split(', ')
links = document.head.querySelector('meta[name="signet:links"]')?.content?.split(', ')

canvasHeight = 3000
canvasWidth = 3000

authorHeight = 20
barHeight = authorHeight / 2
barWidth = 60
height = authors.length * authorHeight + 20

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

drawSignet = ->
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
    twitterImage = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAMAAAAolt3jAAABDlBMVEX6/P7Q4/qy0vfd7Pzz+P631fgAjO7B2/kAj+7d6/tnrvKTwvXE3florvI0nPAAhu2PwPXl7/yKvvTd6/xlrfIxmu8/n/ArmO9nrfL8/v/D3Pnc6vsclu+hyvZCoPD1+f4ale+mzPYAjO1mrfIume/y+P7l8PxPpvGozfcAk+7v9v3Z6Pvk7/zA2vkMlO4umu8tme9eqvFlrPIqmO8Aiu1DoPAkl+83nO/9/f/v9f11tPN5tvPs9P01m+8ml+++2fhvsfJ8t/P2+v4AkO5YqPEqme8Ake4zm++/2vkmmO8sme8Aju4vmu8ll+/8/f/+//8Aku40m+8nmO8Aje77/f8omO8pmO/9/v/+/v////82XKzkAAAAr0lEQVR42i2HhXJCQRRDLxQpWiq4Fajj7lbcn+5u/v9H2MdwJpnkEMQFEiHbEyDr3tI35BBe4zifMRps6uXtHyHwAsmwpVX07y+C7+ktkf1sn6rq7w8I/qCyyBTUDquti1JDB/X4rkxY87QrSX1erlb7D2YelQZAHGk9ykxTG+tTcBJIxjY7tu8e5sCFBMfDUgun8rN/CJCx9S5cj+tIzgAHCORx2502ByBg6R1uGa5fdzNEjg+lPgAAAABJRU5ErkJggg=='
    githubImage = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAMAAAAolt3jAAAA1VBMVEUTERIPDg8QDw8TDxMSEhIREREQEBATERETEBAREREQEBATEBMRERERERESEhISEBISEBIREBESERIREBAVFRUQDxAUDxQSERIUDw8TEBAREBASERIQDxASEBISEBIQEBAAAAAREREQDw8QDxAODg4TEBMVDhUQDxATEBMSEhIREBAREBATExMRDxEQEBASEBIRERESEhISEhISEhITERESEBIREBEREBESEhISEREAAAAUFBQAAAAAAAAAAAAQDw8SERITEhIQDw8RDxAQDw8REBASERLudflrAAAAP3RSTlP+/P5EHVs+iE9ZMW4sdmWRYtGa2yX0M4ozUd2L95udHwOG8ekkUST2UlbN3ijFEI5JHDpkiW/m5GaKAScEAgDgPKx8AAAApklEQVR42h3PxXLDUBBE0YnDzGiHOWaUZOldT5dq/v+XovLZ3t60JShni7pezEpIBtOQNxRTMHJvrdRYtTzHeuGjSTGfF5ORR89uFTes3YUKy9QfUKVUMegrs9CQtIRlYqiwWo+8VDQDnlTbgzpX0GS+3tW1tl+en2zB+OfP9Wrl9cVpbEMu1/eHcbZxuDmGe1f8YrDfzXZgT2+fsL6wewBHx8+Q/gFJwSeod8cM9gAAAABJRU5ErkJggg=='

    linksArgs = ['']
    linksArgs[0] += '%c\n'
    linksArgs.push 'line-height: 0; font-size: 0'
    linkFontSize = 12
    linkFontCharWidth = 7
    lineHeight = 16

    for link, i in links
        firstPartLength = (link.replace(/(https?:\/\/\w+\.\w+\/)(.+)/, '$1')).length
        secondPartLength = link.length - firstPartLength
        linksArgs[0] += "%c#{ link }%c %c %c\n"
        image = if /twitter/.test link then twitterImage else if /github/.test link then githubImage else ''
        leftMargin = -linkFontCharWidth * (firstPartLength - 1) # Hide the domain part of the URL
        linksArgs.push "-webkit-font-smoothing: antialiased; font: 400 #{ linkFontSize }px monospace; margin-left: #{ leftMargin }px"

        charsOffset = 5
        leftMargin = -linkFontCharWidth * (secondPartLength + charsOffset) + 1 # Position this white text over part of the URL
        linksArgs.push "background: #fff; line-height: #{ lineHeight }px; padding: #{ (lineHeight / 2) + 2 }px #{ Math.floor(charsOffset / 2) * linkFontCharWidth }px #{ (lineHeight / 2) + 2 }px #{ Math.ceil(charsOffset / 2) * linkFontCharWidth }px; font-size: 0; margin-left: #{ leftMargin }px"

        leftMargin = -linkFontCharWidth * 3 # Position the logo over the slash part of the URL
        linksArgs.push "background: #fff url(#{ image }); line-height: #{ lineHeight }px; padding: 11px 14px 3px 0; font-size: 0; margin-left: #{ leftMargin }px"
        linksArgs.push ''

    console.log.apply console, linksArgs

drawSignet()
drawLinks()