/*

    ||||||
    Signet   Adam Schwartz

    Display a unique seal in the developer console of your page.
    https://github.com/HubSpot/signet

    Settings:

    - signet.title             - string  - title of your page (required to show color bars signet)
    - signet.author            - string  - author of your page
    - signet.description       - string  - description of your page

    - signet.signet            - boolean - show color bars signet above the title
    - signet.hue               - integer - hue offset for the color bars

    - signet.baseStyles        - string  - base style string for all parst of the singet (best used to set base font or color)
    - signet.titleStyles       - string  - title styles
    - signet.authorStyles      - string  - author styles
    - signet.descriptionStyles - string  - description styles

*/

(function(){
    if (!window.console || !window.console.log)
        return;

    // Defer execution until the next event loop tick, but don't let anything be rendered to the console
    // until we can run our function.  This will break console.log line numbers, but only for the first tick.
    // The fn is passed a special console which will actually log immediately.
    function deferConsole(fn){
        var messages, message, block, old, callable, types, type, i;

        types = ['log', 'debug', 'warn', 'error'];
        old = {};
        callable = {};
        messages = [];

        for(i=types.length; i--;){
            (function(type){
                old[type] = console[type];

                callable[type] = function(){
                    old[type].apply(console, arguments);
                };

                console[type] = function(){
                    messages.push([type, arguments]);
                }
            })(types[i]);
        }
        setTimeout(function(){
            fn(callable);

            while(messages.length){
                block = messages.shift();
                type = block[0];
                message = block[1];

                old[type].apply(console, message);
            }

            for(i=types.length; i--;){
                console[type] = old[type];
            }
        }, 0);
    }

    deferConsole(function(_console){
        var i, args;

        if ((!document.head && !window.signet) || window.signet === false)
            return;

        window.signet = window.signet || {
            signet: true
        };

        function orDefault(a, b){
            if (typeof a !== 'undefined')
                return a;
            return b;
        }

        signet.title = orDefault(signet.title, document.title);
        signet.author = orDefault(signet.author, document.head.querySelector('meta[name=author]').content);
        signet.description = orDefault(signet.description, document.head.querySelector('meta[name=description]').content);
    
        signet.hue = signet.hue || 0;

        signet.baseStyles = orDefault(signet.baseStyles, 'color: #444; font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;');

        signet.titleStyles = orDefault(signet.titleStyles, 'font-size: 20px; line-height: 30px;' + signet.baseStyles);
        signet.authorStyles = orDefault(signet.authorStyles, 'font-size: 12px; line-height: 30px; padding-left: 20px;' + signet.baseStyles);
        signet.descriptionStyles = orDefault(signet.descriptionStyles, 'font-size: 14px; line-height: 20px;' + signet.baseStyles);

        if (signet.signet !== false && signet.title) {
            args = [''];
            for (i = 0; i < signet.title.length; i++) {
                args[0] += '%c' + signet.title[i];
                if (signet.title[i] === ' ') {
                    args.push(signet.titleStyles);
                } else {
                    args.push(signet.titleStyles + ';background: hsl(' + (((signet.title[i].toLowerCase().charCodeAt(0) * 2) + signet.signet) % 255) + ', 80%, 80%); color: transparent; line-height: 0;');
                }
            }
            _console.log.apply(console, args);
        }

        if (signet.title && signet.author)
            _console.log('%c' + signet.title + '%c' + signet.author, signet.titleStyles, signet.authorStyles);

        if (signet.title && !signet.author)
            _console.log('%c' + signet.title, signet.titleStyles);

        if (signet.description)
            _console.log('%c' + signet.description, signet.descriptionStyles);
    });
})();
