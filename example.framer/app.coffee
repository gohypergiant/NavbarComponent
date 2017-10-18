NavbarComponent = require "NavbarComponent"

############################################
# Example usage.
# For all features, please check the README.
############################################

myNavbar = new NavbarComponent
	# General
	style: "light"
	title: "Title"

	# Search bar
	searchLabel: "Search"
	search: true
	dictation: true

placeholderComponent = null
myNavbar.scrollWith(placeholderComponent) # replace placeholderComponent with the name of your FlowComponent or ScrollComponent
