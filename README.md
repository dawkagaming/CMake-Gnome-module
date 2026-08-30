# CMake Gnome module
CMake package to replicate Meson's GNOME module

## Functions

### gnome_compile_resources()
```cmake
gnome_compile_resources(FILE <file>
    OUTPUT_VAR <var>
    [GRESOURCE_BUNDLE]
    [C_NAME <c_name>]
    [EXTRA_ARGS <arg>...]
    [DEPENDENCIES <dependency>...]
    [SOURCE_DIRS <source_dir>...]
    )
```

`FILE <file>`

&emsp;Sets the input `.xml` file to process.

&emsp;If the path is realtive, it will be automatically changed to absolute path.

`OUTPUT_VAR <var>`

&emsp;Sets the variable to which the output files paths will be written, then to be added to your target's sources or plainly installed.

`GRESOURCE_BUNDLE`

&emsp;Produce binary `.gresource` file instead of source file.

`C_NAME <c_name>`

&emsp;Sets the prefix used for the C identifiers

`EXTRA_ARGS <arg>...`

&emsp;Sets additional arguments passed directly to `glib-compile-resources`, must include command-line `--` or `-` prefix.

`DEPENDENCY <dependency>`

&emsp;Adds additional dependency files for generating the resource file, however files listed in `.xml` resource file will be automatically added.

`SOURCE_DIRS <source_dir>`

&emsp;Adds source dirs for `glib-compile-resources` to search files in.

&emsp;If not defined, will default to the directory which contains the `FILE`