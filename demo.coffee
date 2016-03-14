ProfanityFilter = require "@threadmetal/profanity-filter"

filter = new ProfanityFilter

readline = require "readline"
rl = readline.createInterface
	input: process.stdin
	output: process.stdout

rl.on "line", (line) ->
	[good_or_bad, rest...] = line.split(" ")
	message = rest.join(" ")
	switch good_or_bad
		when "good:"
			console.log "Will stop censoring:"
			filter.matchers = filter.matchers.filter (matcher) ->
				drop = message.match matcher
				console.log "\t#{matcher}" if drop
				!drop
		when "bad:"
			matcher = new RegExp message, "gi"
			filter.matchers.push matcher
			console.log "Will start censoring #{matcher}"
		else
			clean_line = filter.transform line
			console.log clean_line
