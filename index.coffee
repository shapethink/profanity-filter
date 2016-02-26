module.exports = class ProfanityFilter
	constructor: (config) ->
		defaults =
			matchers: []
			replace: "%"
		Object.assign @, defaults, config

	transform: (text) ->
		replacer = (match) => @replace.repeat match.length
		reduction = (current, matcher) =>
			current.replace matcher, replacer

		@matchers.reduce reduction, text
