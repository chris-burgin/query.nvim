# query.nvim

Run SQL queries from nvim

## Installation

```viml
Plug 'nvim-lua/plenary.nvim'
Plug 'chris-burgin/query.nvim'

```

## Setup

```lua
require('query_nvim').setup({
  db = {
    host = "127.0.0.1",
    database = "demo"
  },
})
```

## Usage

Type `:Query` to see a list of commands.

| Command     | Description                                                                                                   |
| ----------- | ------------------------------------------------------------------------------------------------------------- |
| query       | Runs the provided query. `:Query query select * from users`                                                   |
| selection   | Runs the current Visual Selection as a query.                                                                 |
| selection_r | Same as `selection` plus it accepts a list of replacements (`?`) as a CSV. Note strings must be wrapped in "" |

## TODO

- [ ] Support multiple databases
- [ ] Support postgresql
- [ ] Support redis
