(function(){
    if (!window.console || !window.console.log || !window.signet)
        return;

    setTimeout(function(){
        if (signet.name)
            console.log('%' + signet.name, 'color: #444; font-size: 20px; font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; padding: 10px 20px 10px; line-height: 50px; border: 2px solid #444;');

        if (signet.description)
            console.log('%c' + signet.description, 'color: #444; font-size: 15px; font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; padding-top: 40px; line-height: 30px');

        if (signet.authors)
            console.log('%c' + signet.authors.join(', '), 'color: #444; font-size: 12px; font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; padding-top: 35px; line-height: 30px');
    }, 0);
})();