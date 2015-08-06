## Editing the Grammar

The Garry's Mod Lua Grammar is written in `.atom-grammar` files. These files are
identical to `cson` files with some key differences:

1. Block Regexes (`///`) will be converted to multiline strings with the
   case-insenstive regex modifier prepended.
2. Anywhere a fragment insert keyword exists (`$fragment`), the corresponding
   file will be inserted from the directory with the same name as the file.

`atom-grammar` files can be built by running the `build` task: `cake build`.

## Changing the standard library functions

The `generator` folder is an addon that can be copy and pasted into the
`addons` directory.

To re-create the standard library syntax highlighting:

1. Load whichever libraries / addons you want into the global namespace.
2. Run the concommand `generate_grammar_cl`
3. Run the concommand `generate_grammar_sv`
4. Run the concommand `generate_grammar_merge`
5. Copy the `std-*.txt` files to the
   `language-gmod-lua/grammars/gmod-lua` directory.
6. Run the `cake build` task.
