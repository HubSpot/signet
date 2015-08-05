return unless window.console?.log?

getMetaList = (name) ->
    head = document.head or document.getElementsByTagName("head")[0]
    content = head.querySelector("meta[name='#{ name }']")?.content
    if content
        return (element.trim?() for element in content.split(','))
    return undefined

authors = getMetaList('signet:authors')
links = getMetaList('signet:links')

textFont = '400 12px "Helvetica Neue", Helvetica, Arial, sans-serif'
textFontSize = 12
textLineHeight = 16

supportsLogBackgroundImage = do ->
    isIE = -> /MSIE/.test(navigator.userAgent)
    isFF = -> /Firefox/.test(navigator.userAgent)
    isOpera = -> /OPR/.test(navigator.userAgent) and /Opera/.test(navigator.vendor)
    isSafari = -> /Safari/.test(navigator.userAgent) and /Apple Computer/.test(navigator.vendor)

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

    (not isIE() and not isFF() and (not isOpera() or operaSupport()) and (not isSafari() or safariSupport()))

# Defer execution until the next event loop tick, but don't let anything be rendered to the console
# until we can run our function.  This will break console.log line numbers, but only for the first tick.
# The fn is passed a special console which will actually log immediately.
deferConsole = (fn) ->
    types = ['log', 'debug', 'warn', 'error']
    old = {}
    callable = {}
    messages = []

    i = types.length

    for type, i in types
        do (type) ->
            old[type] = console[type]
            callable[type] = -> old[type].apply console, arguments
            console[type] = ->
                messages.push [type, arguments]
                return undefined

    setTimeout ->
        for type in types
            console[type] = old[type]

        fn()

        while messages.length
            block = messages.shift()
            type = block[0]
            message = block[1]
            console[type].apply console, message
    , 0

drawSignet = ->
    return unless authors?.length

    unless supportsLogBackgroundImage
        console.log "Author#{ if authors.length is 1 then '' else 's' }:"
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

    context.font = textFont

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
            drawRectangle individualBarLeft, barTop, individualBarWidth, barHeight, "hsl(#{ hue }, 80%, 80%)"

    # Debugging
    # drawRectangle 0, 0, canvasWidth, 1, 'red'
    # drawRectangle 0, 0, 1, canvasHeight, 'red'

    imageCSS = """font-size: 0; line-height: #{ height + lineHeightHack }px; padding: #{ Math.floor(height / 2) }px #{ canvasWidth }px #{ Math.ceil(height / 2) }px 0; background-image: url("#{ canvas.toDataURL() }"); margin-left: #{ leftOffsetHack }px"""
    console.log '%c ', imageCSS

drawLinks = ->
    return unless links?.length

    unless supportsLogBackgroundImage
        console.log(link) for link in links
        return

    IMAGES =
        'twitter.com': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAMAAAAolt3jAAAAGFBMVEWEu/Tf7fxirPK41vg3nPABj+4omO/+//+b16fMAAAAVklEQVR42lXNQRJEUQRDUSRh/ztu8QZd/46cokrMpz/zMR+CBSwrzFBLlbFDYYbdlLegxFq2crzlTu3MrH6p7hF0onDM4inGtJs+PaK0EdYdA8iD+ekHsEgEIt/uHNUAAAAASUVORK5CYII='
        'github.com': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAMAAAAolt3jAAAAGFBMVEVCQUIsKyu8u7ugn6B7envc29wSERH+/v6nd/awAAAAWklEQVQIHT3BiQ0CQBDEsNkv6b9jEDphR70tqD01Ojyjcfgbc9C9M9sNl4Xz52BTxCdUYH0WAuuzkILz54rKUpnT68Dm2GV0+Lo4TJ820EanqrWhNert6c2pH7EtBBOlbNv9AAAAAElFTkSuQmCC'
        'plus.google.com': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAMAAAAolt3jAAAAFVBMVEXic2r88vHLOCDzzMnpoJvVDQDdSzg1eZqZAAAAWklEQVR42lXPORIDQAgDQV3o/082a5x4qhR0QADaajb1hRWy4bhyTEbHMb/rHzHJPIau3bdlG9MDksZSConCRlHFfr7bCTNTerodC+fYmrbTHtUk0I/SfXB9AElwAxEwF7nBAAAAAElFTkSuQmCC'

    linksArgs = ['%c\n', 'line-height: 0; font-size: 0']

    for link, i in links
        domainPart = link.replace(/(https?:\/\/[^\/]+(\/|$))(.*)/, '$1')
        pathPart = link.substr(domainPart.length)

        domainPartWidth = measureTextWidth domainPart
        pathPartWidth = measureTextWidth pathPart

        image = null
        for domain, img of IMAGES
            if (new RegExp("^(https?://)?(www\.)?#{ domain }/", 'i')).test(link)
                image = img
                break

        if image
            linksArgs[0] += "%c#{ link }%c %c %c\n"
            leftMargin = - (domainPartWidth / 2) # The console now wraps the link with a <span><a></a></span> and both get the same margin-left, so we need to halve it so that together we’re at the correct position
        else
            linksArgs[0] += "%c#{ link }\n"
            leftMargin = 0

        linksArgs.push "-webkit-font-smoothing: antialiased; font: #{ textFont }; margin-left: #{ leftMargin }px"

        if image
            whiteCoverWidth = 42

            leftMargin = - pathPartWidth - whiteCoverWidth # Position this white text over part of the URL
            linksArgs.push "background: #fff; line-height: #{ textLineHeight }px; padding: #{ (textLineHeight / 2) + 2 }px #{ whiteCoverWidth / 2 }px #{ (textLineHeight / 2) + 2 }px #{ whiteCoverWidth / 2 }px; font-size: 0; margin-left: #{ leftMargin }px"

            leftMargin = - (whiteCoverWidth / 2) + 2 # Position the logo over the slash part of the URL
            linksArgs.push "background: #fff url(#{ image }); line-height: #{ textLineHeight }px; padding: 11px 14px 3px 0; font-size: 0; margin-left: #{ leftMargin }px"
            linksArgs.push ''

    console.log linksArgs...

measureTextWidth = (text) ->
    canvas = document.createElement 'canvas'
    context = canvas.getContext '2d'
    context.font = textFont
    context.measureText(text).width

deferConsole ->
    drawSignet()
    drawLinks()
