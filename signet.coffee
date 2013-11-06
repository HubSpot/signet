return unless window.console?.log?

getMetaList = (name) ->
    content = document.head.querySelector("meta[name='#{ name }']")?.content
    if content
        return (element.trim() for element in content.split(','))
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
            console[type] = -> messages.push [type, arguments]

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
        'twitter.com': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAIAAACQKrqGAAABj0lEQVR4AW2RP8sTQRDG5wP4CcRSo0aNiBFLQT+ArZVdjJ2VhWBt8RKNGjV3ScDYhCAmoIjpYvxTiYIIFonvVRoQk+xc9nKXu9ztrnPLciTowxR3O78Z5pkBpZSUSqodya1/Icwv/JvOPtAXscgeNerMkkSnE5EGab4SN197Z5t49flyNIneTiIMRIpe7/O94Upt6dYbD/YWRy088IjBXXa5s5y6SYrW3vtwZ1Hq8Q/7kR9JHspLbfdIHQsNLDYRaqz7ZW1m/ehExZYLDxncZxfb7rUeJ+JwHY9beMpGeMDGv2ODVkc+3GOUPt3Ag4+RanKay1tIvXMW/sLEoFNMrnSXeRspTtpYsFPumJVWUlnpBVdaILT3Z58CGv+EZSAK8nSuifQ4HIcEEAZSo/t/4nKP03Zymqbe51tIU90eeGavSqNC0848HYOanWngoScIlcWNlzzYyOwoQPegDZf7nOxDhUGVkeULT93O50CfyjQytjaJdGbxux/Rq2/rwffw68+NF8rdIxv0/xIy44z+Ao9k3z0IqK6zAAAAAElFTkSuQmCC'
        'github.com': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAMAAAAolt3jAAAAwFBMVEWBgIDAv8CZmJmqqqqsrKy2tbXFxcXR0dHk5OTW1taRkZF4d3ihoaE8Ozxwb3Cko6QzMjIaGRrQz9B/fn/Qz88xMDBvbm9+fX4XFxe0s7NtbG38/Pzi4uKCgoIdHBwlJCW0s7Te3d4YFxizsrNAPz+vr68wLy9HRkfa2trw8PB7enu7u7vJycmioqLl5eUQDw/d3d2Af3+Yl5goJygqKSqgoKB/fn7+/v7b29sRDxD7+/v9/f0REBASERITEhL////VYqnUAAAAm0lEQVQI1wXBhWEDAQwEQYXJYXaYzOxnSbf9d5UZc2jW27bdrhtwg3koM1MxB6PMWErSMrLERpHTWbXZVLNpxshuFTcAcBeqrNBwTOfeMR6qsNAEr6F2Jgpr9cBLB53TV2v3elpBDXx9aGCPeXXeO4bFz2/qzZrri7PYg1Kp75Vxmbs7C3hOxR8G+4PiEA70/gnm0NgRnJy+gv8DuGIma39KSZAAAAAASUVORK5CYII='
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
            leftMargin = - domainPartWidth
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
