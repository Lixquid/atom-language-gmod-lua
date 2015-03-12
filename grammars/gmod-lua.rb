################################################################################
    # Garry's Mod Lua grammar
    # Copyright (C) 2015 Lixquid
    #
    # This program is free software: you can redistribute it and/or modify
    # it under the terms of the GNU General Public License as published by
    # the Free Software Foundation, either version 3 of the License, or
    # (at your option) any later version.
    #
    # This program is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.
################################################################################

## Utils ##

variableName = "[a-zA-Z_]\\w*"
notScoped = "(?<![^.]\\.|:)"

## Rules ##

$exports = {
	name: "Garry's Mod Lua",
	comment: "Garry's Mod Lua: version 0.2.2",
	scopeName: "source.lua",

	fileTypes: [ "lua" ],
	firstLineMatch: %r{
		# Change syntax to Lua if we find a bash directive
		\A \#! .*? \b lua \b
	}x,

	patterns: [

		## Garry's Mod Specifics ###############################################

		{	# C-style single-line comments
			name: "comment.line.double-slash.lua",

			begin: "//",
			end: "\\n"
		},

		{	# C-style block comments
			name: "comment.block.lua",

			begin: "/\\*",
			end: "\\*/"
		},

		{	# continue keyword
			name: "keyword.control.lua",

			match: "\\bcontinue\\b"
		},

		{	# C-style logical operators
			name: "keyword.operator.lua",

			match: "&&|\\|{2}|!"
		},

		## Meta ################################################################

		{	# Function definition
			name: "meta.function.lua",
			begin: %r{
				# Get the function keyword
				\b ( function )

				# Optional: Named Function
				(?:
					# Scope
					\s+ ( (?: #{variableName} [.:] )* )
					# Function Name
					( #{variableName} ) \s*
				)?

				\(
			}x,
			beginCaptures: [
				{},
				{ name: "keyword.control.lua" },
				{ name: "entity.name.function.scope.lua" },
				{ name: "entity.name.function.lua" }
			],

			end: "\\)",

			# Match all parameters inside the function definition,
			# comma delimited
			patterns: [{
				name: "variable.parameter.function.lua",
				match: "([^,])"
			}]
		},



		## Constants ###########################################################

		{	# Numbers
			name: "constant.numeric.lua",

			match: %r{

				\b (	# Hex Numbers
					0x [\d a-f]+
				|	# Integers (with optional exponent)
					\d+
					( [eE] -? \d+ )?
				|	# Decimal Numbers (with optional exponent)
					\d* \. \d+
					( [eE] -? \d+ )?
				)
			}x
		},

		{	# Values
			name: "constant.language.lua",

			match: %r{
				\b (
					nil | true | false | _G | _VERSION | math \. ( pi | huge )
				) \b
			|
				\.{3}
			}x
		},



		## Strings #############################################################

		{	# Single-quoted Strings
			name: "string.quoted.single.lua",

			begin: "'",
			end: "'",

			patterns: [
				{ include: "#escaped_chars" }
			]
		},

		{	# Double-quoted Strings
			name: "string.quoted.double.lua",

			begin: "\"",
			end: "\"",

			patterns: [
				{ include: "#escaped_chars" }
			]
		},

		{	# Multi-line Strings
			name: "string.quotes.other.multiline.lua",

			begin: %r{
				# Don't match if this is a multiline comment..
				(?<! -- )
				# Match the starting double brace
				\[ ( =* ) \[
			}x,
			end: "\\]\\1\\]"
		},



		## Comments ############################################################

		{	# Multi-line Comments
			name: "comment.block.lua",

			begin: "--\\[(=*)\\[",
			end: "\\]\\1\\]"
		},

		{	# Single-line Comments
			name: "comment.line.double-dash.lua",

			begin: "--",
			end: "\\n"
		},



		## Keywords ############################################################

		{	# Explicit Keywords
			name: "keyword.control.lua",

			match: %r{
				\b (
					break | do | else | for | if | elseif | return | then
					| repeat | while | until | end | function | local | in
					| goto
				) \b
			}x
		},

		{	# Operators
			name: "keyword.operator.lua",

			match: %r{
				# Mathematical Operators
				\+ | - | \* | \/ | \^ | %
				# Auxiliary Operators
				| \#
				# Logical Operators
				| ==? | ~= | <=? | >=?
				# Boolean Operators
				| \b ( and | or | not ) \b
				# Concatenation Operator
				| (?<! \. ) \.{2} (?! \. )
			}x
		},

		{	# Self Keyword
			name: "variable.language.self.lua",

			match: %r{
				# Check we're not scoped..
				#{notScoped}
				# Match the word "self"
				\b ( self ) \b
			}x
		},



		## Library Functions ###################################################

		{
			name: "support.function.library.lua",

			match: %r{

				# Check we're not scoped..
				#{notScoped}

				# Check for any built-in function
				\b (
					assert | collectgarbage | dofile | error | getfenv
					| getmetatable | ipairs | loadfile | loadstring | module
					| next | pairs | pcall | print | rawequal | rawget | rawset
					| require | select | setfenv | setmetatable | tonumber
					| tostring | type | unpack | xpcall
				) \b

			}x
		},

		{
			name: "support.function.library.lua",

			match: %r{

				# Check we're not scoped..
				#{notScoped}

				# Look for any library name
				\b (
					coroutine \. (
						create | resume | running | status | wrap | yield )
					| debug \. (
						debug | [gs]etfenv | [gs]ethook | getinfo | [gs]etlocal
						| [gs]etmetatable | getregistry | [gs]etupvalue
						| traceback )
					| io \. (
						close | flush | input | lines | open | output | popen
						| read | tmpfile | type | white )
					| math \. (
						abs | acos | asin | atan2? | ceil | cosh? | deg | exp
						| floor | fmod | frexp | ldexp | log | log10 | max | min
						| modf | pow | rad | random | randomseed | sinh? | sqrt
						| tanh? )
					| os \. (
						clock | date | difftime | execute | exit | getenv
						| remove | rename | setlocale | time | tmpname )
					| package \. (
						cpath | loaded | loadlib | path | preload | seeall )
					| string \. (
						byte | char | dump | find | format | gmatch | gsub | len
						| lower | match | rep | reverse | sub | upper )
					| table \. (
						concat | insert | maxn | remove | sort )
				) \b

			}x
		},



		## Variable ############################################################

		{	# Goto Targets
			name: "keyword.control.tag.lua",

			match: %r{
				:: #{variableName} ::
			}x
		},

		{	# Table Variables
			name: "variable.other.lua",

			match: %r{

				# Check that we ARE scoped..
				(?<= [^.] \. | : )

				# Look for a valid variable name
				\b ( #{variableName } )

			}x
		},

		{	# Function calls
			name: "support.function.any-method.lua",

			match: %r-

				# Check for a valid variable name..
				\b ( #{variableName} )

				# Check that it's called like a function
				\b (?= \s* (?: [({"'] | \[ =* \[ ) )
			-x
		}

	],

	repository: {
		escaped_chars: {
			patterns: [
				{
					name: "constant.character.escape.lua",

					match: %r{
						# Match any valid escape character
						\\ ( \d{1,3} | [abfnrtv\\"'\[\]] )
					}x
				},
				{
					name: "invalid.illegal.lua",

					# Everything else isn't a valid escape code
					match: "\\\\."
				}
			]
		}
	}
}
