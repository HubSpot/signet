getOptions = (options) ->
  options.title = orDefault options.title, getContent('meta[name="application-name"]'), getContent('meta[property="og:title"]'), document.title.split(/\u0020[\/\\\|\-\u8211\u8212]\u0020|\:\u0020/)[0], ''
  options.author = orDefault options.author, getContent('meta[name=author]'), ''
  options.description = orDefault options.description, getContent('meta[name=description]'), getContent('meta[property="og:description"]'), ''
  options.image = orDefault options.image, getContent('meta[property="og:image"]'), getContent('meta[name=image]')
  options.hue = options.hue or 0
  options.baseStyles = orDefault options.baseStyles, 'color: #444; font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;'
  options.titleStyles = orDefault options.titleStyles, "#{ options.baseStyles }; font-size: 20px; line-height: 30px;"
  options.authorStyles = orDefault options.authorStyles, "#{ options.baseStyles }; font-size: 12px; line-height: 30px; padding-left: 20px;"
  options.descriptionStyles = orDefault options.descriptionStyles, "#{ options.baseStyles }; font-size: 14px; line-height: 20px;"
  options

orDefault = ->
  for argument in arguments when typeof argument isnt 'undefined'
    return argument
  arguments[arguments.length - 1]

getContent = (selector) ->
  document.head.querySelector(selector)?.content

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

  setTimeout (->
    _then = ->
      while messages.length
        block = messages.shift()
        type = block[0]
        message = block[1]
        old[type].apply console, message

      for type in types
        console[type] = old[type]

    fn callable, _then
  ), 0

draw = (options, _console, cb) ->
  _draw = ->
    if options.title
      unless options.image
        args = ['']
        i = 0
        while i < options.title.length
          args[0] += "%c#{ options.title[i] }"
          if options.title[i] is ' '
            args.push options.titleStyles
          else
            hue = ((options.title[i].toLowerCase().charCodeAt(0) * 2) + options.hue) % 255
            args.push "#{ options.titleStyles }; background: hsl(#{ hue }, 80%, 80%); color: transparent; line-height: 0;"
          i++
        _console.log.apply console, args
      if options.author
        _console.log "%c#{ options.title }%c#{ options.author }", options.titleStyles, options.authorStyles
      else
        _console.log "%c#{ options.title }", options.titleStyles

    _console.log "%c#{ options.description }", options.descriptionStyles if options.description

    cb() if cb

  _console = _console or window.console
  options = options or window.signet.options or enabled: true

  return if options.enabled is false

  options = getOptions options

  unless options.image
    _draw()
  else
    img = new Image()
    img.onload = ->
      _console.log '%c ', """font-size: 0; line-height: #{ img.height }px; padding: #{ Math.floor(img.height / 2) }px #{ img.width }px #{ Math.ceil(img.height / 2) }px 0; background-image: url("#{ img.src }");"""
      _draw()

    img.src = options.image

window.signet = window.signet or {}
window.signet.options = window.signet.options or window.signetOptions or {}

if not window.console or not window.console.log or not document.head or not document.querySelector
  window.signet.draw = ->
  return

autoInit = true
tag = document.querySelector('[data-signet-draw]')
autoInit = (tag.getAttribute('data-signet-draw').toLowerCase() isnt 'false') if tag
autoInit = false if signet.options.draw is false

if autoInit
  deferConsole (_console, _then) ->
    draw null, _console, _then

window.signet.draw = draw
