--[[----------------------------------------------------------------------------
	Grammar Fragment Generation Script

	This script will generate grammar fragment files that can be used during
	the main grammar compilation to include some Garry's Mod specific functions
	and constants in the generated grammar.

	This script will capture loaded libraries, global functions, and constants
	at run time.

	Usage:
	1. Load all libraries you want to capture, clientside and/or serverside.
	2. Run `generate_grammar_cl`
	3. Run `generate_grammar_sv`
	4. Run `generate_grammar_merge`
	5. Copy the `grammar_frag_*.txt` files to the `language-gmod-lua` directory.

	The next time compilation is executed, the fragment files will be detected
	and included.
--]]----------------------------------------------------------------------------

-- Variables -------------------------------------------------------------------

--- Current "Class" functions. Class functions should be marked as part of a
-- library if they *are* scoped.
local c_cla = {}

--- Current "Library" functions. Library functions should be marked as part of a
-- library if they are *not* scoped.
local c_lib = {}

--- Current Constants. Constants should be marked as a constant if they are
-- *not* scoped.
local c_con = {}



-- Util Functions --------------------------------------------------------------

--- Inserts all "Constant" values to `c_con`.
local function iterateConstants()

	for name, val in pairs( _G ) do

		-- We only want to add Constants
		-- Constants should be all UPPERCASE
		if type( name ) ~= "string" or name ~= name:upper() then continue end

		c_con[ name ] = true

	end

end

--- Inserts all Global Functions into `c_lib`.
local function iterateGlobalFunctions()

	for name, val in pairs( _G ) do

		-- We only want to add functions
		if type( val ) ~= "function" then continue end

		c_lib[ name ] = true

	end

end

--- Inserts all Libraries into `c_lib`
local function iterateLibraries()

	for name, tab in pairs( _G ) do

		-- We only want libraries
		if type( tab ) ~= "table" then continue end

		-- Don't include `_G`, that's covered by `iterateGlobalFunctions`
		if tab == _g then continue end

		-- Don't include `GAMEMODE`, that's covered by
		-- `iterateGamemodeHooks`
		if name == "GAMEMODE" then continue end

		-- Don't include VGUI Metatables, that's covered by
		-- `iterateVGUIMetaMethods`
		if CLIENT and vgui.GetControlTable( name ) then continue end

		-- SpawniconGenFunctions contains models as functions for whatever
		-- reason..
		if name == "SpawniconGenFunctions" then continue end


		for name2, val in pairs( tab ) do

			if type( val ) ~= "function" then continue end

			c_lib[ name .. "\\." .. name2 ] = true

		end

	end

end

--- Inserts all gamemode hooks into `c_lib`
-- Note that this inserts all callable variants; GAMEMODE and GM, as well as
-- dot (`.`) and colon (`:`) calling styles.
local function iterateGamemodeHooks()

	for name, val in pairs( GAMEMODE ) do

		if type( val ) ~= "function" then continue end

		c_lib[ "GAMEMODE\\." .. name ] = true
		c_lib[ "GM\\." .. name ] = true
		c_lib[ "GAMEMODE:" .. name ] = true
		c_lib[ "GM:" .. name ] = true

	end

end

--- Inserts all VGUI metatables into `c_cla`
local function iterateVGUIMetaMethods()

	-- VGUI is only available clientside
	if SERVER then return end

	for name, tab in pairs( _G ) do

		-- We only want tables that are VGUI Metatables
		if not vgui.GetControlTable( name ) then continue end

		for name2, val in pairs( tab ) do

			if type( val ) ~= "function" then continue end

			c_cla[ name2 ] = true

		end

	end

end

--- Inserts all metatables into `c_cla`
local function iterateMetatables()

	for name, tab in pairs( debug.getregistry() ) do

		-- We only want the metatables of valid "classes"
		if type( name ) ~= "string" or type( tab ) ~= "table" then continue end

		for name2, val in pairs( tab ) do

			if type( val ) ~= "function" then continue end

			c_cla[ name2 ] = true

		end

	end

end

--- Saves the contents of `c_lib`, `c_cla`, and `c_con` to grammar fragment
-- JSON files. These will be later merged and converted to the final grammar
-- fragment file.
local function saveToJSON()

	local prefix = SERVER and "sv" or "cl"

	file.Write( "grammar_" .. prefix .. "_cla.txt", util.TableToJSON( c_cla ) )
	file.Write( "grammar_" .. prefix .. "_con.txt", util.TableToJSON( c_con ) )
	file.Write( "grammar_" .. prefix .. "_lib.txt", util.TableToJSON( c_lib ) )

end



-- ConCommands -----------------------------------------------------------------

local function generate_fragments()
	iterateConstants()
	iterateGamemodeHooks()
	iterateGlobalFunctions()
	iterateLibraries()
	iterateVGUIMetaMethods()
	iterateMetatables()
	saveToJSON()
end
if SERVER then
	concommand.Add( "generate_grammar_sv", generate_fragments )
else
	concommand.Add( "generate_grammar_cl", generate_fragments )
end

concommand.Add( "generate_grammar_merge", function()

	-- Get the key-based grammar fragments into memory
	local claKey = util.JSONToTable( file.Read( "grammar_sv_cla.txt" ) )
	local claKey2 = util.JSONToTable( file.Read( "grammar_cl_cla.txt" ) )
	local conKey = util.JSONToTable( file.Read( "grammar_sv_con.txt" ) )
	local conKey2 = util.JSONToTable( file.Read( "grammar_cl_con.txt" ) )
	local libKey = util.JSONToTable( file.Read( "grammar_sv_lib.txt" ) )
	local libKey2 = util.JSONToTable( file.Read( "grammar_cl_lib.txt" ) )

	-- Merge Clientside and Serverside
	for name in pairs( claKey2 ) do claKey[ name ] = true end
	for name in pairs( conKey2 ) do conKey[ name ] = true end
	for name in pairs( libKey2 ) do libKey[ name ] = true end

	-- Generate value-based arrays from the key-based sets for sorting
	local claVal, conVal, libVal = {}, {}, {}
	for name in pairs( claKey ) do table.insert( claVal, name ) end
	for name in pairs( conKey ) do table.insert( conVal, name ) end
	for name in pairs( libKey ) do table.insert( libVal, name ) end

	-- Sort the arrays with longer first
	-- This is force to regex engine to match more specific strings before
	-- shorter, more generic strings.
	local function sort( a, b ) return #a > #b end
	table.sort( claVal, sort )
	table.sort( conVal, sort )
	table.sort( libVal, sort )

	-- Convert the arrays to regex fragments and output them
	file.Write( "grammar_frag_cla.txt", table.concat( claVal, "|" ) )
	file.Write( "grammar_frag_con.txt", table.concat( conVal, "|" ) )
	file.Write( "grammar_frag_lib.txt", table.concat( libVal, "|" ) )

end )
