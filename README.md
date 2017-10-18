# NavbarComponent Framer Module

[![license](https://img.shields.io/github/license/bpxl-labs/RemoteLayer.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](.github/CONTRIBUTING.md)
[![Maintenance](https://img.shields.io/maintenance/yes/2017.svg)]()

<a href="https://open.framermodules.com/navbarcomponent"><img alt="Install with Framer Modules" src="https://www.framermodules.com/assets/badge@2x.png" width='160' height='40' /></a>

The NavbarComponent module allows you to generate an iOS-style navigation bar with title, action buttons, and search bar. Scroll effects mimic those on iOS, and views can be navigated forward and reverse.
	
<img src="https://user-images.githubusercontent.com/935/28231662-46b639f2-68b2-11e7-8ae7-c3bef444be02.gif" width="500" style="display: block; margin: auto" alt="NavbarComponent preview" />	

### Installation

#### NPM Installation

```
$ cd /your/framer/project
$ npm i @blackpixel/framer-navbarcomponent
```

#### Manual installation

Copy or save the `NavbarComponent` file into your project's `modules` folder.

### Adding It to Your Project

In your Framer project, add the following:

```coffeescript
# If you manually installed
NavbarComponent = require "NavbarComponent"
# else
NavbarComponent = require "@blackpixel/framer-navbarcomponent"
```

### API

#### `new NavbarComponent`

Instantiates a new instance of NavbarComponent.

#### Available options

```coffeescript
myNavbar = new NavbarComponent
		# General
		style: <string> ("light" || "dark")
		size: <string> ("large" || "small")
		title: <string>
		
		# Buttons
		buttonCount: <number>
		buttonSize: <number>
		buttonActions: <array of actions>
		imagePrefix: <string>
		imageSuffix: <string>
		backAction: <action>
		
		# Search bar
		searchLabel: <string>
		search: <boolean>
		dictation: <boolean>
		
		# Colors
		textColor: <string> (hex or rgba)
		backgroundColor: <string> (hex or rgba)
		searchBarColor: <string> (hex or rgba)
		searchIconColor: <string> (hex or rgba)
		accentColor: <string> (hex or rgba)
```

#### Activating scroll effects

NavbarComponent will need to know which layer's scroll position it ought to match. Do not attempt to set it as the header of a FlowComponent. Rather, use the `scrollWith()` feature and indicate your FlowComponent or ScrollComponent to the NavbarComponent.

```coffeescript
myNavbar.scrollWith(layer) # layer will be the name of your FlowComponent or ScrollComponent
```

#### Navigation effects

To mimic view-by-view navigation, use `showNext()` and `showPrevious(`). When using `showNext()`, provide a title for the next view. NavbarComponent will store these for purposes of returning to them with `showPrevious()`.

```coffeescript
myNavbar.showNext("Your title here")
myNavbar.showPrevious()
```

For debugging help, you can inspect NavbarComponent's stored list of titles.

```coffeescript
print myNavbar.history
```

#### Navbar size
Not all iOS navbars use the large title style. You may enforce a smaller title using `size: "small"`. 

#### The search bar

If you instantiate the NavbarComponent with `search: true`, your initial navbar view will display a search bar. Your users can type in this bar. If you wish to check the current value of the search bar, use the `search` variable.

```coffeescript
print myNavbar.search
```

#### Button images
All images are assumed to live in the `images` directory and to be numbered starting with zero. You may supply a prefix and suffix. If your button images are located in a `buttons` directory within `images` and named:

```coffeescript
item0.png
item1.png
item2.png
```

then your `imagePrefix` will be `"buttons/item"` and your `imageSuffix` will be `"png"`.

Do not include the `images` directory in `imagePrefix`.

#### Button size
Action button assets are assumed to be 24pt by 24pt. If yours are of another size, supply the correct dimension with `buttonSize: <number>`. This will prevent your assets from being scaled.

#### Button actions
The back button that appears on secondary views can be given an action, as can individual action buttons. Most likely, you will want the back button to activate the NavbarComponent's `showPrevious()` feature, along with any navigation relevant to your prototype (e.g., the `showPrevious()` FlowComponent feature). Action button actions should be arranged in a comma-separated array, one action per line.

```coffeescript
backAction: -> myNavbar.showPrevious()
buttonActions: [
	-> print "1",
	-> print "second",
	-> print "item the third"
]
```

### Example project
[Download](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/bpxl-labs/NavbarComponent/tree/master/example.framer) the example to try it for yourself.

---

Website: [blackpixel.com](https://blackpixel.com) &nbsp;&middot;&nbsp;
GitHub: [@bpxl-labs](https://github.com/bpxl-labs/) &nbsp;&middot;&nbsp;
Twitter: [@blackpixel](https://twitter.com/blackpixel) &nbsp;&middot;&nbsp;
Medium: [@bpxl-craft](https://medium.com/bpxl-craft)
