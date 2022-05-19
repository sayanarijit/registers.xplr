---@diagnostic disable
local xplr = xplr
---@diagnostic enable

local registers = {}

local function format(reg)
  return "\x1b[1;7m " .. reg .. " \x1b[0m"
end

local function get(reg)
  return registers[reg] or {}
end

local function set(reg, paths)
  if paths and #paths ~= 0 then
    registers[reg] = paths
  else
    registers[reg] = nil
  end
end

local function all()
  return registers
end

local function setup(args)
  args = args or {}
  args.mode = args.mode or "default"
  args.key = args.key or '"'

  xplr.config.modes.builtin[args.mode].key_bindings.on_key[args.key] = {
    help = "registers",
    messages = {
      "PopMode",
      { SwitchModeCustom = "registers" },
    },
  }

  xplr.config.modes.custom.registers = {
    name = "registers",
    layout = {
      Horizontal = {
        config = {
          constraints = {
            { Percentage = 50 },
            { Percentage = 50 },
          },
        },
        splits = {
          {
            CustomContent = {
              title = "registers",
              body = {
                DynamicTable = {
                  widths = {
                    { Length = 5 },
                    { MinLessThanLayoutWidth = 5 },
                  },
                  render = "custom.registers.render",
                },
              },
            },
          },
          "Selection",
        },
      },
    },
    key_bindings = {
      on_key = {
        esc = {
          help = "cancel",
          messages = {
            "PopMode",
          },
        },
        ["ctrl-c"] = {
          messages = {
            "Terminate",
          },
        },
      },
      on_character = {
        help = "swap with register",
        messages = {
          "UpdateInputBufferFromKey",
          { CallLuaSilently = "custom.registers.swap" },
          "PopMode",
        },
      },
    },
  }

  xplr.fn.custom.registers = {}

  xplr.fn.custom.registers.swap = function(app)
    local reg = app.input_buffer

    local msgs = {
      "ClearSelection",
      "ResetInputBuffer",
      { LogInfo = string.format("Selection swapped with register %q", reg) },
    }

    local selection = get(reg)

    for _, path in ipairs(selection) do
      table.insert(msgs, { SelectPath = path })
    end

    selection = {}

    for _, node in ipairs(app.selection) do
      table.insert(selection, node.absolute_path)
    end

    set(reg, selection)

    return msgs
  end

  xplr.fn.custom.registers.render = function(_)
    local view = {
      { "reg", "# selected" },
      { "───", "──────────" },
    }

    local _registers = all()
    table.sort(_registers)
    for reg, selection in pairs(_registers) do
      table.insert(view, { format(reg), tostring(#selection) })
    end

    return view
  end
end

return { setup = setup, get = get, set = set, all = all }
