###
	# USING NAVBARCOMPONENT

	# Require the module
	NavbarComponent = require "NavbarComponent"

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

	# Attach to a FlowComponent or ScrollComponent
	myNavbar.scrollWith(layer)

	# Navigate to next title
	myNavbar.showNext(<string>)

	# Navigate to previous title
	myNavbar.showPrevious()

	# Current search field value
	myNavbar.search

	# Inspect the stored titles
	myNavbar.history
###

defaults =
	buttonCount: 0
	title: "Large Title"
	searchLabel: "Search"
	style: "light"
	size: "large"
	search: false
	dictation: false
	textColor: ""
	backgroundColor: ""
	searchBarColor: ""
	searchIconColor: "#8E8E93"
	buttonSize: 24
	accentColor: "#007AFF"
	imagePrefix: ""
	imageSuffix: "png"
	buttonActions: []
	backAction: () ->

# NavbarComponent class
class NavbarComponent extends Layer
	constructor: (@options={}) ->
		@options = _.assign({}, defaults, @options)
		super @options

		noop = () ->
		@.history = [@options.title]
		@.navLevel = 0
		defaultAnimationDuration = 0.25

		sizeTextLayer = (layer) ->
			style = _.pick(layer.style, TextLayer._textProperties)
			textWidth = Math.ceil(Utils.textSize(layer.text, style).width)
			ratio = if _.includes(Framer.Device.deviceType, "plus") then 3 else 2
			layer.width = textWidth/ratio

		# heights by size
		heights =
			small: 64
			large: 116
			search: 54 # additive

		# scroll thresholds for triggering navbar changes
		scrollThresholds =
			titleScaleThreshold: 70

		margins =
			side: 14

		# SVG
		chevronSVG = "<svg xmlns='http://www.w3.org/2000/svg'><polygon points='0 10.5 10.5 0 12.5 2 4 10.5 12.5 19 10.5 21' fill='#{@options.accentColor}' /></svg>"

		searchSVG = "<svg xmlns='http://www.w3.org/2000/svg'><path d='m13.74309,12.57406l-3.833,-3.8345c0.68708,-0.9371 1.05514,-2.07003 1.05,-3.232c-0.01311,-3.03315 -2.46637,-5.48999 -5.4995,-5.5075c-1.45152,-0.00657 -2.84537,0.56765 -3.87106,1.59475c-1.02568,1.02709 -1.59799,2.42174 -1.58944,3.87325c0.01311,3.03342 2.46661,5.49048 5.5,5.508c1.16671,0.00505 2.30378,-0.3673 3.2415,-1.0615l0.004,-0.003l3.8295,3.8315c0.20705,0.21721 0.51557,0.30513 0.80602,0.2297c0.29045,-0.07544 0.51719,-0.30237 0.59238,-0.59289c0.07518,-0.29051 -0.013,-0.59895 -0.2304,-0.80581l0,0zm-8.247,-2.696c-2.42658,-0.01396 -4.38934,-1.9794 -4.4,-4.406c-0.00654,-1.16106 0.45134,-2.27655 1.27173,-3.09817c0.8204,-0.82161 1.93521,-1.28116 3.09627,-1.27633c2.42659,0.01395 4.38935,1.97939 4.4,4.406c0.00655,1.16105 -0.45133,2.27655 -1.27173,3.09816c-0.82039,0.82161 -1.9352,1.28116 -3.09627,1.27634z' fill='#{@options.searchIconColor}' /></svg>"

		dictationSVG = "<svg xmlns='http://www.w3.org/2000/svg'><path d='M6,0 L6,0 C7.65685425,0 9,1.34314575 9,3 L9,10 C9,11.6568542 7.65685425,13 6,13 L6,13 C4.34314575,13 3,11.6568542 3,10 L3,3 C3,1.34314575 4.34314575,0 6,0 Z M11.25,6.5 C10.8357864,6.5 10.5,6.83578644 10.5,7.25 L10.5,10 C10.5,12.4852814 8.48528137,14.5 6,14.5 C3.51471863,14.5 1.5,12.4852814 1.5,10 L1.5,7.25 C1.5,6.83578644 1.16421356,6.5 0.75,6.5 C0.335786438,6.5 0,6.83578644 0,7.25 L0,10 C0.00148134437,13.0225955 2.25111105,15.5721759 5.25,15.95 L5.25,17.5 L3.25,17.5 C2.83578644,17.5 2.5,17.8357864 2.5,18.25 C2.5,18.6642136 2.83578644,19 3.25,19 L8.75,19 C9.16421356,19 9.5,18.6642136 9.5,18.25 C9.5,17.8357864 9.16421356,17.5 8.75,17.5 L6.75,17.5 L6.75,15.95 C9.74888895,15.5721759 11.9985187,13.0225955 12,10 L12,7.25 C12,6.83578644 11.6642136,6.5 11.25,6.5 L11.25,6.5 Z' fill='#{@options.searchIconColor}' /></svg>"

		# set default colors per style
		if @options.textColor == ""
			@options.textColor = switch @options.style
				when "dark" then "white"
				else "black"

		if @options.backgroundColor == ""
			@options.backgroundColor = switch @options.style
				when "dark" then "hsla(0, 0%, 11%, 0.72)"
				else "hsla(0, 0%, 97%, 0.82)"

		if @options.searchBarColor == ""
			@options.searchBarColor = switch @options.style
				when "dark" then "hsla(240, 2%, 57%, 0.14)"
				else "hsla(240, 2%, 57%, 0.12)"

		inputCSS = """
		input[type='text'] {
		  appearance: none;
		  color: #{@options.textColor};
		  border: none;
		  outline: none;
		  background-color: transparent;
		  font-family: -apple-system, Helvetica, Arial, sans-serif;
		  font-weight: 500;
		  text-align: left;
		  font-size: 17px;
		  margin: 0;
		  padding: 0;
		  width: 100px;
		  height: 36px;
		  position: relative;
		  top: 0;
		}"""

		Utils.insertCSS(inputCSS)

		@layout = () =>
			for layer in @.children
				layer.destroy()

			@.width = Screen.width
			@.height = heights[@options.size] + @options.search * heights.search
			@.backgroundColor = "clear"

			bkgd = new Layer
				parent: @
				width: Screen.width
				height: @.height + Screen.height
				y: Align.bottom
				backgroundColor: @options.backgroundColor
				shadowY: 0.5
				shadowBlur: 0
				shadowColor: "rgba(0,0,0,0.28)"
				style:
					"-webkit-backdrop-filter": "blur(60px)"

			@.bkgd = bkgd

			clippingFrame = new Layer
				parent: @
				width: Screen.width
				height: @.height
				backgroundColor: "clear"
				clip: true

			@.clippingFrame = clippingFrame

			for i in [0...@options.buttonCount]

				iconFrame = new Layer
					parent: clippingFrame
					name: "iconFrame" + i
					width: 28
					height: 28
					x: Align.right(-11 - (39 * i))
					y: 29
					backgroundColor: "clear"

				do (i) =>
					reversedIndex = @options.buttonCount - 1 - i # reverse the order so user can supply actions left-to-right
					if @options.buttonActions[reversedIndex] != noop and @options.buttonActions[reversedIndex] != undefined
						iconFrame.onClick =>
							@options.buttonActions[reversedIndex]()

				icon = new Layer
					parent: iconFrame
					name: "icon" + i
					backgroundColor: "clear"
					width: @options.buttonSize
					height: @options.buttonSize
					x: Align.center
					y: Align.center
					image: "images/#{@options.imagePrefix}#{i}.#{@options.imageSuffix}"

			titleClip = new Layer
				parent: clippingFrame
				y: heights.small
				width: Screen.width
				height: heights[@options.size] - heights.small
				backgroundColor: "clear"
				clip: true

			@.titleClip = titleClip

			title = new TextLayer
				parent: titleClip
				x: margins.side
				y: 2
				fontSize: 34
				fontWeight: 700
				color: @options.textColor
				text: @options.title
				originX: 0

			@.title = title

			chevron = new Layer
				parent: clippingFrame
				x: 7.5
				y: 12.5 # will be added to y:20
				width: 13
				height: 22
				backgroundColor: "clear"
				html: chevronSVG

			backLabel = new TextLayer
				parent: clippingFrame
				x: 26
				y: 12 # will be added to y:20
				color: @options.accentColor
				fontSize: 17
				fontWeight: 500
				text: ""

			@.backLabel = backLabel

			smallTitle = new TextLayer
				parent: clippingFrame
				y: 32
				color: @options.textColor
				fontSize: 17
				fontWeight: 500
				text: @options.title
				opacity: if @options.size == "small" then 1 else 0

			sizeTextLayer(smallTitle)
			smallTitle.x = Align.center

			@.smallTitle = smallTitle

			backButton = new Layer
				parent: clippingFrame
				y: 20
				width: Screen.width/2
				height: heights.small - 20
				backgroundColor: "clear"

			backButton.placeBefore(bkgd)

			@.backButton = backButton

			chevron.parent = backButton
			backLabel.parent = backButton

			backButton.states =
				show:
					opacity: 1
					animationOptions: time: defaultAnimationDuration
				hide:
					opacity: 0
					animationOptions: time: defaultAnimationDuration

			backButton.animate("hide", instant: true)

			if @options.backAction != noop
				backButton.onClick =>
					@options.backAction()

			if @options.search == true
				searchBarClip = new Layer
					parent: clippingFrame
					y: Align.bottom
					width: Screen.width
					height: heights.search
					backgroundColor: "clear"
					clip: true

				searchBar = new Layer
					parent: searchBarClip
					x: 8
					y: Align.bottom(-16)
					width: @.width - 16
					height: 36
					borderRadius: 10
					backgroundColor: @options.searchBarColor

				@.searchBar = searchBar

				searchBar.onTap ->
					return

				searchIcon = new Layer
					parent: searchBar
					x: 10
					y: 11
					width: 14
					height: 14
					backgroundColor: "clear"
					html: searchSVG

				searchText = new Layer
					parent: searchBar
					x: searchIcon.maxX + 7
					width: searchBar.width - 58
					height: searchBar.height
					backgroundColor: "clear"
					html: "<input id='search' type='text' contenteditable='true' placeholder='#{@options.searchLabel}'>"

				@.searchText = searchText

				if @options.dictation == true
					dictationIcon = new Layer
						parent: searchBar
						x: Align.right(-10)
						y: 9
						width: 12
						height: 19
						backgroundColor: "clear"
						html: dictationSVG

		# end @layout()

		@layout()

		@scrollWith = (layer) => # scrolling effects
			scroll = null
			minNavBarHeight = heights[@options.size]
			smallNavBarHeight = heights.small
			searchBarHeight = heights.searchBar
			searchBarY = @.searchBar?.y or 0
			searchBarShift = @.searchBar?.y - 16 - @.searchBar?.height/2 or 0
			titleMoveStart = heights.small * @options.search
			titleHeight = heights[@options.size] - heights.small
			enforceScrollMatching = false
			if layer instanceof FlowComponent
				scroll = layer.scroll
			else if layer instanceof ScrollComponent
				scroll = layer
			if scroll != null and scroll != undefined
				scroll.onMove =>
# 					print scroll.scrollY
					maxNavBarHeight = 0
					if @.navLevel > 0
						maxNavBarHeight = heights.small
					else if @options.search == true
						maxNavBarHeight = heights[@options.size] + heights.search
					else
						maxNavBarHeight = heights[@options.size]
					@.title.scale = Utils.modulate(scroll.scrollY, [0, -scrollThresholds.titleScaleThreshold], [1, 1.1], true)
					# clipping
					@.clippingFrame.height = Utils.modulate(scroll.scrollY, [0, minNavBarHeight], [maxNavBarHeight, smallNavBarHeight], true)
					@.clippingFrame.y = Math.max(0,-scroll.scrollY)
					@.bkgd.y = Math.max(-Screen.height, -scroll.scrollY - Screen.height)
					@.title.y = Utils.modulate(scroll.scrollY, [titleMoveStart, minNavBarHeight], [2, -titleHeight], true)
					@.bkgd.height = Utils.modulate(scroll.scrollY, [0, minNavBarHeight], [maxNavBarHeight, smallNavBarHeight], true) + Screen.height
					@.searchBar?.opacity = Utils.modulate(scroll.scrollY, [0, smallNavBarHeight], [1,0], true)
					@.searchBar?.y = Utils.modulate(scroll.scrollY, [0, smallNavBarHeight], [searchBarY, searchBarShift], true)
					if @options.size == "large" and @.navLevel == 0
						@.smallTitle.opacity = Utils.modulate(@.title.y, [2 - titleHeight/2, -titleHeight], [0, 1], true)

		# end @scrollWith()

		resetTitle = () =>
			if @.navLevel == 1
				@.bkgd.height = @.height + Screen.height
				@.bkgd.y = Align.bottom
				@.title.scale = 1
				@.title.y = 2
				@.searchBar.y = Align.bottom(-16)
				@.searchBar.opacity = 1
				@.clippingFrame.height = @.height
				@.clippingFrame.y = 0

		# end resetTitle()

		animateToNextTitle = (newTitle = "", oldTitle = "", titleLayer = @.title) =>
			@.smallTitle.opacity = 0
			@.title.opacity = 0
			@.backLabel.opacity = 0
			titleLayer.opacity = 0
			tempLabel = titleLayer.copy()
			tempLabel.opacity = 1
			tempLabel.screenFrame = titleLayer.screenFrame
			tempLabel.parent = @.clippingFrame
			tempLabel.x = titleLayer.screenFrame.x
			tempLabel.y = titleLayer.screenFrame.y
			tempLabel.text = oldTitle
			tempLabel.animate
				x: @.backLabel.screenFrame.x
				y: @.backLabel.screenFrame.y
				color: @options.accentColor
				fontSize: 17
				fontWeight: 500
				options: time: defaultAnimationDuration
			@.backLabel.animate
				opacity: 0
				options: time: defaultAnimationDuration - 0.05 # otherwise will still be animating in next step
			@.smallTitle.text = newTitle
			@.smallTitle.animate
				opacity: 1
				options: time: defaultAnimationDuration
			tempLabel.onAnimationEnd =>
				@.backLabel.text = oldTitle
				@.backLabel.width = Screen.width - margins.side * 2
				@.backLabel.opacity = 1
				Utils.delay defaultAnimationDuration, =>
					tempLabel.destroy()

		# end animateToNextTitle()

		animateToPreviousTitle = (prevBackLabel = "", currentBackLabel = "", titleLayer = @.title) =>
			resetTitle()
			@.title.opacity = 0
			@.smallTitle.opacity = 0
			@.backLabel.opacity = 0
			tempTitle = @.backLabel.copy()
			tempTitle.opacity = 1
			tempTitle.screenFrame = @.backLabel.screenFrame
			tempTitle.parent = @.clippingFrame
			tempTitle.animate
				x: titleLayer.screenFrame.x
				y: titleLayer.screenFrame.y
				color: @options.textColor
				fontSize: titleLayer.fontSize
				fontWeight: titleLayer.fontWeight
				opacity: 1
				options: time: defaultAnimationDuration
			@.backLabel.text = prevBackLabel
			@.backLabel.animate
				opacity: 1
				options: time: defaultAnimationDuration
			tempTitle.onAnimationEnd =>
				@.title.text = currentBackLabel
				@.smallTitle.text = currentBackLabel
				titleLayer.opacity = 1
				Utils.delay defaultAnimationDuration, =>
					tempTitle.destroy()

		# end animateToPreviousTitle()

		@showNext = Utils.throttle 0.5, (newTitle = "New Title") =>
			@.history.splice(@.navLevel + 1, 1, newTitle)
			if @.navLevel == 0 and @options.size == "large"
				animateToNextTitle(newTitle, @.history[@.navLevel], @.title)
			else
				animateToNextTitle(newTitle, @.history[@.navLevel], @.smallTitle)
			@.clippingFrame.animate
				height: heights.small
				options: time: defaultAnimationDuration
			@.bkgd.animate
				height: heights.small + Screen.height
				options: time: defaultAnimationDuration
			++@.navLevel
			displayBackButton()

		# end @showNext()

		@showPrevious = Utils.throttle 0.5, () =>
			if @.navLevel > 0
				if @.navLevel == 1 and @options.size == "large"
					animateToPreviousTitle(@.history[@.navLevel - 2], @.history[@.navLevel - 1], @.title)
					@.clippingFrame.animate
						height: heights[@options.size] + @options.search * heights.search
						options: time: defaultAnimationDuration
					@.bkgd.animate
						height: heights[@options.size] + Screen.height + @options.search * heights.search
						options: time: defaultAnimationDuration
				else
					animateToPreviousTitle(@.history[@.navLevel - 2], @.history[@.navLevel - 1], @.smallTitle)
				@.navLevel = Math.max(0, @.navLevel - 1)
				displayBackButton()

		# end @showPrevious()

		displayBackButton = () =>
			if @.navLevel == 0
				@.backButton.animate("hide")
			else
				@.backButton.animate("show")

		# end displayBackButton()

		# Handle orientation switch
		# Check whether the device is mobile or not (versus Framer)
		if Utils.isMobile()
			# Add event listener on orientation change
			window.addEventListener "orientationchange", =>
				@layout()
		else
			# Listen for orientation changes on the device view
			Framer.Device.on "change:orientation", =>
				@layout()

	@define 'search', get: () -> document.getElementById('search').value
module.exports = NavbarComponent
