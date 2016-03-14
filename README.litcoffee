# profanity-filter
a simple transform to replace profanity in a text

### Getting Started

This section describes a number of external concepts and some syntax sugar to make later sections more readable.

	# look in package.json for package info
	PKG = require "./package"

	# how to pull a repo name from a *.git URL
	repo_name = (origin_url) ->
		path.basename origin_url, ".git"

	# change working directory
	cd = process.chdir

	# shell commands
	exec = (msg) ->
		throw new Error "exec: #{msg} -- DIY :-)"

	git = clone: (repo_url) ->
		exec "git clone #{repo_url}"

	npm = link: () -> exec "npm link"

	# test asserter
	should = require("chai").should()

	# unit under test
	ProfanityFilter = require "."

Now that those ideas are nicely nailed down, we can proceed with...

#### Installation

This package is experimental, so you probably shouldn't use it unless you can make sense of this snippet.

	install = (paths) ->
		cd paths.packages.experimental
		git.clone PKG.repository.url
		cd repo_name PKG.repository.url
		npm.link()
		cd paths.project.root
		npm.link PKG.name

###### im in ur `README` cheking ur exampls

This `README` is also a module written in [Literate CoffeeScript]. Among other nice things, that means `require()`-ing this `README` yields the following example as a test. You might find it useful to add [coffee-script/register] to your list of `require()`'s or other configurations, depending on your needs.

### Example

	module.exports =
		defaults: ->
			new ProfanityFilter()
				.transform "a bad BAD word"
				.should.equal "a bad BAD word"

		"changing profanity list": ->
			filter = new ProfanityFilter
			filter.matchers.push /BAD/ig
			filter.transform "a bad BAD word"
				.should.equal "a %%% %%% word"

			filter.matchers.push /word/
			filter.transform "a bad BAD word"
				.should.equal "a %%% %%% %%%%"

			filter.replace = "*"
			filter.transform "a bad BAD word"
				.should.equal "a *** *** ****"

			filter.matchers.shift()
				.toString().should.equal "/BAD/gi"

			filter.transform "a bad BAD word"
				.should.equal "a bad BAD ****"

			filter.matchers.pop()
				.toString().should.equal "/word/"
			filter.matchers.should.be.empty
			filter.transform "a bad BAD word"
				.should.equal "a bad BAD word"

Don't forget the regex flags you need! For example:

		"with regex flags":
			gi: ->
				new ProfanityFilter matchers: [/BAD/gi]
					.transform "a bad bad BAD BAD word"
					.should.equal "a %%% %%% %%% %%% word"

So, you probably want both flags -- but otherwise:

			i: ->
				new ProfanityFilter matchers: [/BAD/i]
					.transform "a bad bad BAD BAD word"
					.should.equal "a %%% bad BAD BAD word"

			g: ->
				new ProfanityFilter matchers: [/BAD/g]
					.transform "a bad bad BAD BAD word"
					.should.equal "a bad bad %%% %%% word"

			"(none)": ->
				new ProfanityFilter matchers: [/BAD/]
					.transform "a bad bad BAD BAD word"
					.should.equal "a bad bad %%% BAD word"

## Gratitude

Thanks go to a number of technologies, and very many other developers. Try to add a link to any useful things learned while contributing.

###### Links and References
* [Literate CoffeeScript]
* [regex flags]
* [coffee-script/register]

[Literate CoffeeScript]: http://coffeescript.org/#literate (CoffeeScript docs: "literate mode")
[regex flags]: http://devdocs.io/javascript/global_objects/regexp/flags (JavaScript regex docs: flags)
[coffee-script/register]: http://coffeescript.org/#1.7.0 (requiring coffeescript modules directly)
