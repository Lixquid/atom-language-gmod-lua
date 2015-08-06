-- Functions --

function name( parameters, more_parameters ) end

function scoped.name( parameters ) end

function colon:scoped( parameters, ... ) end

-- Values --

true
false
nil
_G
_VERSION
...

-- Numeric --

1
2e2
3e-3
4.4
5.5e5
6.6E-6
.7
.8e8
0x9a
0xa.1
0xb.f
0xC
0xD.1
0xE.F

-- Strings --

'Single quotes'
"Double quotes"

"Escaped newline: \n"
"Escaped backslash: \\"
"Escaped decimal literal: \100 \0019 \50a"
"Escaped hex literal: \xff \x00f \xFF"

"Invalid escape: \i \e"
"Invalid hex literal: \x0"

[[ Multiline
String ]]

[=[
Nested [[ Multiline ]] String
]=]

-- Comments --

-- Single line
--[[ multiline
comment ]]

-- Keywords --

break do else elseif
end for goto
if in local repeat
return then until while

+ - * / ^
.. == ~= < > <= >=
and or not

self scoped.self

-- Variables --

lowercase
UPPERCASE
_beginning_underscore
l3tt3rs_w1th_numb3r5
3invalidName

goto tag
::tag::
::tag_with_numb3rs::

func( input )
func 'input'
func "input"
func [[input]]
func{ input }
nonFunc input

-- Library Functions --

table.concat()
math.random()

-- Garry's Mod Specific --

// Comment
/* Block
Comment */

continue

&& || !variable

file:SetSize()
file:SetSizeNotInStandardLib()
PrintTable()
RandomFunctionNotInStandardLib()

TOP BOTTOM FILL

-- Haha, seriously what?
ACT_READINESS_PISTOL_RELAXED_TO_STIMULATED_WALK
