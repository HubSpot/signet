## Title Signet

#### Display a unique seal in the developer console of your page.

### [Demo](http://github.hubspot.com/signet/titleSignet)

### Features

- Display a unique seal (automatically generated from the title) in the console.
- Display page title, author, and description in the console. (Automatically grabs from respective `<meta>` tags)
- Use the description to provide a link to other developers to learn more about your app, your development processes, or even your hiring information ;).
- Optionally display an image instead of the unique seal.
- Manual configuration possible in javascript by disabling the auto-initialization and setting your own options. (See below.)

### Simple Use

Simply include the script in your page and you're done.

```html
<script src="signet.min.js"></script>
```

To get the most out of Signet, you'll want to make sure you have the following `<meta>` tags in the `<head>` of your page:

```html
<meta name="application-name" content="Example Title">
<meta name="description" content="Example description. More info: http://example.com">
<meta name="author" content="Example Author">
```

By adding these `<meta>` tags to your page, you'll get the added benefit of __improving your SEO__.

#### Download

##### [titleSignet.min.js](http://github.hubspot.com/signet/signet.min.js)
##### [titleSignet.js](http://github.hubspot.com/signet/signet.js)

### Advanced Use

If you want full control, you can disable the autoinitialization and set your own options.

Here's an example of how you might go about that:

```html
<script src="titleSignet.min.js" data-signet-draw="false"></script>
<script>
    var signetOptions = {
        hue: 50 // Rotates the hue of the signet color bars by 50 (mod 256),
        title: 'Custom Example Title',
        description: 'Custom example description. More info: http://example.com'
    };
</script>
```

#### Configuration Options

By default, no configuration is required. View the [demo page](http://github.hubspot.com/signet/titleSignet) for an example which uses no configuration.

However, if desired, you can configure the following:

    window.signetOptions
      .title             - string  - title of your page (required to show color bars signet)
      .author            - string  - author of your page
      .description       - string  - description of your page
      .hue               - integer - hue offset for the color bars
      .image             - string  - url of an image to dipslay instead of the color bars
      .baseStyles        - string  - base style string for all parst of the singet (best used to set base font or color)
      .titleStyles       - string  - title styles
      .authorStyles      - string  - author styles
      .descriptionStyles - string  - description styles

### Dependencies

None.

### Support

Stylized logs are supported in the following browsers:

- Chrome 26+
- Firefox with [Firebug 1.11 beta 2](http://blog.getfirebug.com/2012/11/16/firebug-1-11-beta-2/) or later
- Opera with Blink (15+)
- Safari Nightly (537.38+)

Signet will harmelessly disable itself on older browsers without console support.

### Screenshot

![](http://github.hubspot.com/signet/images/titleSignet/preview.png)