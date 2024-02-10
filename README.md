# registers.xplr

Use multiple registers to store the selected paths.

## Usage example

- Select paths usinhg <kbd> space </kbd>.
- Type <kbd> " </kbd> <kbd> a </kbd> to put the selection into `a` register.
- Select some more paths.
- Type <kbd> " </kbd> <kbd> a </kbd> again to swap the selection with `a` register's content.
- Press <kbd> ctrl-u </kbd> to unselect all.
- Type <kbd> " </kbd> <kbd> a </kbd> to move the selection from `a` register to the selection list.

## Requirements

none

## Installation

### Install using xpm.xplr

```lua
require("xpm").setup({
  { name = 'sayanarijit/registers.xplr' },
})
```

### Install manually

- Add the following line in `~/.config/xplr/init.lua`

  ```lua
  local home = os.getenv("HOME")
  package.path = home
    .. "/.config/xplr/plugins/?/init.lua;"
    .. home
    .. "/.config/xplr/plugins/?.lua;"
    .. package.path
  ```

- Clone the plugin

  ```bash
  mkdir -p ~/.config/xplr/plugins

  git clone https://github.com/sayanarijit/registers.xplr ~/.config/xplr/plugins/registers
  ```

- Require the module in `~/.config/xplr/init.lua`

  ```lua
  require("registers").setup()

  -- Or

  require("registers").setup{
    mode = "default",
    key = '"',
  }

  -- Type `"` and then another character to swap the selection with a register.
  ```

## Features

- Swap the current selection with any register.
- See the active registers with selection count.

## Todo

- [ ] Global registers
- [ ] Clipboard support
