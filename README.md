# query.nvim

Run SQL queries from nvim. Query.nvim is a work in progress, expect things to change.

### Supported Databases

- [x] MySQL
- [ ] PostgreSQL
- [ ] Redis

## Installation

```viml
Plug 'nvim-lua/plenary.nvim'
Plug 'chris-burgin/query.nvim'

```

## Setup

```lua
require('query_nvim').setup({
  db = {
    {
      name = "demo",
      type = "mysql",
      host = "127.0.0.1",
      database = "demo"
    },
    {
      name = "demo2",
      type = "mysql",
      host = "127.0.0.1",
      database = "demo2"
    }
  },
})
```

## Usage

Type `:Query` and hit `tab` to see a list of commands.

| Command  | Description                                                                                                        |
| -------- | ------------------------------------------------------------------------------------------------------------------ |
| query    | Runs the provided query. `:Query query [db.name] [query]`                                                          |
| visual   | Runs the current Visual Selection as a query. `:Query visual [db.name]`                                            |
| visual_r | Same as `selection` plus it accepts a list of replacements (`?`) as a CSV. Note strings must be wrapped in quotes. |

### Examples

**Screenshots are out of date and do not show the required `db.name` param.**

#### query

![query](https://user-images.githubusercontent.com/1278846/109590272-b0584980-7ad9-11eb-8a57-06d1be54f560.gif)

#### visual

![simple](https://user-images.githubusercontent.com/1278846/109590287-b77f5780-7ad9-11eb-840b-ee2a86e198e5.gif)

#### visual_r

![replacement](https://user-images.githubusercontent.com/1278846/109590293-b9491b00-7ad9-11eb-8f1e-2aea4c9c9437.gif)
