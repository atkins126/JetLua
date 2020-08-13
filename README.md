![](/images/logo256.png)
# Welcome to JetLua&trade;
An SDK to allow easy integration of [Lua](https://www.lua.org/) scripting inside your [Delphi](https://www.embarcadero.com/products/delphi) applications
## Features
* Made with/supports latest Delphi version
* Only two minimal interfaces to access feature set (IJetLua & IJetLuaContext)
* You can auto register class/object JetLua routines
* If you have created an AutoSetup class function, it's automatically called during registration where you can do global setup operations
* You can declare tables in "table.table.table" format
* You can declare global/table variables and access them
* You can check the exists of global/table variables and routines
* You can call global/table functions with a variable number of parameters
* You can pull and push data from and to the Lua stack via the IJetLuaContext interface
* You can load source code from a file, string and buffer
* You can import Lua modules
* Source is [JIT](https://en.wikipedia.org/wiki/Just-in-time_compilation) compiled using [moonjit](https://github.com/moonjit/moonjit)
* You can compile Lua sources (including imported modules) and bind to an EXE for stand-alone distribution
* You can add version information, an icon, enable runtime-themes and high DPI aware support to EXEs
* See this [blog post](https://tinybiggames.com/projects/project/4-jetlua/) for more details
