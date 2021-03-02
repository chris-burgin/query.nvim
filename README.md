# query.nvim

Run SQL queries from nvim

## Installation

```viml
Plug 'nvim-lua/plenary.nvim'
Plug 'chris-burgin/query.nvim'

```

## Usage

Type `:Query` to see a list of commands.

| Command     | Description                                                      |
| ----------- | ---------------------------------------------------------------- |
| query       | Runs the provided query. `:Query query select * from users`      |
| selection   | Runs the current Visual Selection as a query.                    |
| selection_r | Same as `selection` plus it accepts a list of replacements (`?`) |
