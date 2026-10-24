-- Silver Installer Lua command template
-- Compatible with standard Lua 5.1+.
-- Replace the command body at the bottom with your own Lua logic.

local banner = [=[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣤⣤⣤⣤⣤⠴⠶⠶⠶⠤⣤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⡿⣉⣰⣿⣿⣟⡁⠀⠀⢀⠙⠳⠾⢧⣭⣛⣶⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣺⣿⣿⣶⡿⠟⠛⠛⠛⠿⣦⣤⣌⡻⣅⠀⠀⠈⢙⢿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⡿⣻⡿⣿⠋⠀⠀⠀⠀⠀⠀⢻⣷⡜⢷⡈⢷⡜⠓⢘⣦⡙⢿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣞⣿⣵⣿⣾⠁⠀⠀⠀⠀⠀⠀⠀⠀⠹⣯⠉⣿⣌⢻⣄⡄⠛⣿⣺⡹⢟⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣾⣿⣿⣿⣟⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣷⡿⣟⣟⣿⣿⡙⡸⣿⡋⣟⡟⣿⡄⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⢠⣿⣿⣼⣿⣿⠿⣼⣿⣶⡄⠀⠀⠀⠀⣠⣤⣤⠿⣿⣿⣯⣽⣷⡿⣬⣻⣷⡞⣿⡸⡹⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢀⡿⡀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣤⣤⣬⠉⠁⠀⠀⠀⠰⠿⠛⠛⠒⠹⣿⣟⣷⣹⣷⡝⢿⣿⣿⣿⣿⣷⣧⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠈⠓⣦⠋⠀⠀⠀⣿⢿⣿⣿⢿⣿⠻⢏⡙⢷⣄⠀⠀⠀⠀⠀⣾⡷⠶⢮⣝⣿⣿⣿⣿⣿⣦⠙⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀
⠀⠀⠀⢀⡀⠀⠀⠉⠀⠀⠀⣰⣯⣿⣿⣿⣿⠛⡶⣦⡁⣀⡿⡀⠀⠀⠀⡿⢙⣓⡆⠈⢻⣿⣿⣿⣿⣿⣿⣷⣝⢻⣿⣿⣿⣷⡀⠀⠀⠀⢠⡆⠀⠀⠀⠀⠀
⠀⠀⢠⣼⢧⠀⠀⠀⠀⠀⢠⣿⣿⢿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠇⠀⠀⠀⠈⠺⠧⠤⢴⠻⠀⠀⣿⣿⣿⣿⣿⣿⣷⣽⣿⣿⣝⢷⡄⠀⢀⠜⠹⢄⡀⠀⠀⠀⠀
⠀⠀⠀⠸⠃⠀⠀⠀⠀⢠⣿⣿⢇⣿⣿⣿⣿⡇⠀⠀⠀⢠⡚⢢⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢛⣩⠿⣿⣿⣾⣿⣿⣿⣿⣿⡎⣷⠀⠈⠹⣸⠉⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢠⢿⣿⡟⣸⣿⣿⢻⣿⣿⡄⠀⠀⣠⠬⠥⣉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢋⣴⣿⣿⣿⣿⣿⣿⣿⣿⣧⣿⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢸⡼⣿⠁⣿⣿⣿⣬⣿⣿⣿⣄⠀⢳⣾⣒⠪⠷⣤⠀⠀⠀⠀⠀⠀⢀⣴⣶⣿⣯⣿⣿⣿⣿⣿⣿⣿⣿⣿⢹⠀⠀⠀⠀⠀⠀⣤⠀⠀
⠀⠀⠀⠀⠀⠀⠙⠀⢸⣹⣿⡐⣿⣿⢘⣷⠘⣿⢿⣿⣆⠀⠛⠮⠴⠊⠀⠀⠀⠀⠀⣀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣿⡤⢻⡿⣆⠀⠀⠀⠀⠶⡟⡶⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠈⡟⣿⣷⣿⣿⡄⣿⡀⢸⣞⣿⣿⣷⣄⠀⠀⠀⢀⡠⠄⠒⠉⣀⣿⣿⣿⣿⣿⣿⣿⣿⠟⢻⡝⣦⣿⣷⢸⣷⢻⣧⡀⠀⠀⠀⠉⠁⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢳⠹⣿⣿⣿⣷⢸⡇⢸⠿⣿⢹⣿⣿⣿⣿⣿⣧⣀⣀⣐⣋⣁⣿⣿⣿⡏⢷⠀⢻⡀⢲⡾⣷⢻⡜⣿⡄⢿⡄⠹⣷⣄⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⣿⣿⣿⣿⣿⣳⣿⣰⣿⡜⠀⠈⡄⠀⠀⠘⠿⠃⠀⠀⢇⢻⣿⠀⣿⢸⣿⣟⢾⡇⢸⣿⠹⣿⣿⣿⣌⢻⣮⣻⣿⡞⡆⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣇⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⣼⢆⠀⠀⠀⠀⠀⠀⢈⡾⣿⢠⣿⣾⣿⠏⣸⣇⢸⣿⡆⢹⣿⣿⣿⣿⣗⠸⣿⣇⢸⠀⠀⠀⠉
⠀⠀⠀⠀⠀⠀⡀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⡿⣻⠁⠀⠀⠀⠀⢿⣄⠉⠒⠢⠤⠒⠂⠉⢃⢹⣿⣿⣿⡟⢀⣿⠁⣾⣾⠻⣄⢹⣿⣿⣿⣿⣣⣽⡟⢸⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠘⠚⠀⢀⣮⣿⢫⣿⣿⣿⣿⣿⢰⢿⢰⠀⠀⠀⠀⠀⠙⠃⠀⠀⠀⠀⠀⠀⠘⣿⣿⡿⢋⣴⠿⠁⣸⣿⢻⠀⠘⣆⢿⣿⣿⣿⣥⣿⢇⡞⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣸⠘⣼⠀⠀⠀⠀⠲⣶⡆⠀⠀⠀⠀⠀⠀⣼⡿⣫⣶⠟⠁⣠⣿⣿⣿⠏⠀⠀⢽⣾⣿⣿⣿⣿⣩⠞⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣾⣿⣼⢿⣿⣿⢻⠸⣿⣿⣿⣆⠹⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣫⡾⢋⣂⣴⣿⣿⣿⡿⠊⠀⠀⠀⢸⣿⣿⣿⣿⣷⠋⠀⠀⠀⠀⠀⠀
]=]

io.write(banner, "\n\n")
print("Silver Installer")
print("----------------------------------------")

local function run_command()
    local separator = package.config:sub(1, 1)
    if separator ~= "\\" then
        print("This installer command requires Windows.")
        return
    end

    local source = debug.getinfo(1, "S").source
    local script_path = source:sub(1, 1) == "@" and source:sub(2) or source
    local script_dir = script_path:match("^(.*)[/\\][^/\\]+$") or "."
    local powershell = (os.getenv("SystemRoot") or "C:\\Windows") .. "\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"
    local installer_script = script_dir .. "\\install_silverspoon.ps1"

    local function quote_argument(value)
        return '"' .. value .. '"'
    end

    local command = quote_argument(powershell)
        .. " -NoLogo -NoProfile -ExecutionPolicy Bypass -File "
        .. quote_argument(installer_script)

    io.write("Starting the SilverSpoon recovery installer.\n")
    local ok, reason, code = os.execute(command)
    if ok == true or ok == 0 or code == 0 then
        print("Installer sequence completed.")
    else
        print("Installer stopped: " .. tostring(reason or "process error") .. " " .. tostring(code or ""))
    end
end

run_command()

