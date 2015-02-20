$exports = {
	".source.lua" => {
		editor: {
			commentStart: "-- ",
			increaseIndentPattern: %r{

				\b (
					# Match any block starting keywords
					then | else | elseif | do | repeat | function
					| local \s+ function

					# That doesn't end on the same line
				) \b ( (?! end ) . )* $
			|
				# Also match any table beginning definitions
				\{ \s* $
			}x,
			decreaseIndentPattern: %r{

				^ \s*
				# Match any block terminating keywords
				( elseif | else | end | \} )

			}x

			# TODO: Add Completions
		}
	}
}
