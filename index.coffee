module.exports = class ProfanityFilter
	constructor: (config) ->
		defaults =
			matchers: [] # bring your own profanity
			replace: "%" # percent: not as cool as asterisk
		Object.assign @, defaults, config

	transform: (text) ->
		replacer = (match) => @replace.repeat match.length
		reduction = (current, matcher) =>
			current.replace matcher, replacer

		@matchers.reduce reduction, text
