-- This document provides a test environment for the Lua grammar.
-- It is not meant to be run!

-- Meta --------------------------------------------------------------------------------------------

function scope.name( parameters, more_parameters )

end

function extended:object:name( parameters, ... )

end

-- Values ------------------------------------------------------------------------------------------

false
nil
true
_G
_VERSION
...

-- Numbers -----------------------------------------------------------------------------------------

1
2e2
3e-3
4.4
5.5e5
6.6e-6
.7
.8e8
0xa

-- Strings -----------------------------------------------------------------------------------------

'Single quoted string'

"Double quoted string \with \esca\ped \chara\cter\s \\"

[=[ good old [[indented]] multiline string ]=]

-- Comments ----------------------------------------------------------------------------------------

-- Single line
--[[ multiline
neato! ]]

-- Keywords ----------------------------------------------------------------------------------------

if then end return

+ - * and or .. ==

self scoped.self
