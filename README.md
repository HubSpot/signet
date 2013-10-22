## Signet

> Make your mark.

### [Demo](http://github.hubspot.com/signet)

### Features

- Display a unique seal in the console of your page.
- Automatically grabs `title`, `author`, and `description`, from respective `<meta>` tags.
- Manual configuration possible in javascript by settings `window.signet` object options. (See below.)

### Configuration

By default, no configuration is required. View the [demo page](http://github.hubspot.com/signet) for an example which uses no configuration.

However, if desired, you can configure the following:


    - signet.title             - string  - title of your page (required to show color bars signet)
    - signet.author            - string  - author of your page
    - signet.description       - string  - description of your page

    - signet.signet            - boolean - show color bars signet above the title
    - signet.hue               - integer - hue offset for the color bars

    - signet.baseStyles        - string  - base style string for all parst of the singet (best used to set base font or color)
    - signet.titleStyles       - string  - title styles
    - signet.authorStyles      - string  - author styles
    - signet.descriptionStyles - string  - description styles

### Support

Stylized logs are supported in the following browsers:

- Chrome 26+
- Firefox with [Firebug 1.11 beta 2](http://blog.getfirebug.com/2012/11/16/firebug-1-11-beta-2/) or later
- Opera with Blink (15+)
- Safari Nightly (537.38+)

### Screenshot

![](https://raw.github.com/HubSpot/signet/gh-pages/images/preview.png)
