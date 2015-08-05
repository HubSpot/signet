## Signet

#### Display a unique seal in the developer console of your page.

### [Demo](http://github.hubspot.com/signet)

### Features

- Display a unique seal in the console
- Display links in the console to your Twitter and GitHub sites with icons displayed next to them

### Use

First, make sure you include the script in your page.

```html
<script src="signet.min.js"></script>
```

[CDN Support by MaxCDN](http://osscdn.com/#/signet)

```html
<script src="//oss.maxcdn.com/signet/0.4.4/signet.min.js"></script>
```

Next, add either or both of the following `<meta>` tags to the `<head>` of your page:

```html
<meta name="signet:authors" content="Example Name, AnotherExample Name">
<meta name="signet:links" content="http://github.com/example, http://twitter.com/example, http://example.com">
```

#### Download

##### [script.min.js](https://raw.github.com/HubSpot/signet/v0.4.8/signet.min.js)
##### [script.js](https://raw.github.com/HubSpot/signet/v0.4.8/signet.js)

### Dependencies

None.

### Support

- Chrome 26+
- Opera with Blink (15+)
- Safari Nightly (537.38+)

Signet will harmelessly disable itself on older browsers without advanced console styling support.

### Screenshot

![](http://github.hubspot.com/signet/images/signet/preview.png)

---------------

### Title Signet

An earlier version of this library featured the ability to display a unique seal based on the title of the page, rather than the author list. This has been moved to the [titleSignet](https://github.com/HubSpot/signet/tree/master/titleSignet) directory of this repo. It contains its own README and has a different configuration.
