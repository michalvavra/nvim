# nvim

## Usage

### Keymaps

#### TODO
- `k` show diagnostic > `k` go inside > `q` quit

#### Base
- Default `<leader>` is `<space>`

| Key                                | Description                              | Mode | Plugin                           |
| ---------------------------------- | ---------------------------------------- | ---- | -------------------------------- |
| `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` | Go to left, bottom, top, or right window | `n`  | `christoomey/vim-tmux-navigator` |
| `<leader>e`                        | File Explorer                            | `n`  | `echasnovski/mini.files`         |
| `<leader>oh`                       | Find Help                                | `n`  | `echasnovski/mini.files`         |

### Basics

- `echasnovski/mini.basics`
- `:h MiniBasics.config.mappings`

 |Keys   |     Modes       |                  Description                  |
 |-------|-----------------|-----------------------------------------------|
 | j     | Normal, Visual  | Move down by visible lines with no [count]    |
 | k     | Normal, Visual  | Move up by visible lines with no [count]      |
 | go    | Normal          | Add [count] empty lines after cursor          |
 | gO    | Normal          | Add [count] empty lines before cursor         |
 | gy    | Normal, Visual  | Copy to system clipboard                      |
 | gp    | Normal, Visual  | Paste from system clipboard                   |
 | gV    | Normal          | Visually select latest changed or yanked text |
 | g/    | Visual          | Search inside current visual selection        |
 | *     | Visual          | Search forward for current visual selection   |
 | #     | Visual          | Search backward for current visual selection  |
 | <C-s> | Normal, Visual, | Save and go to Normal mode                    |
 |       |     Insert      |                                               |

#### File Explorer

- `echasnovski/mini.files`
- When open, can edit as with insert mode (`o`, `O`, `r`, `dd`)
- `:h MiniFiles-navigation` 
- `<leader>e` and `g?`

#### AI

- `echasnovski/mini.ai`
- Enahnces `a` (outer) and `i` (inner) textobjects
- `:h MiniAi-textobject-builtin`

```html
<button class="primary">Submit</button>
            <!-- 1 ^ CURSOR in Normal mode
                 2 Press: vi"
                 3 Selection: primary
                 4 Press: <esc>
                 5 Press: va"
                 6 Selection: "primary" -->
```

#### LSP
 
| Key | Description                           | Mode |
| --- | ------------------------------------- | ---- |
| `v` | Node incremental (`node_incremental`) | `v`  |
| `V` | Node decremental (`node_decremental`) | `v`  |

```html
<main>
    <section>
        <h2>Title</h2>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
            <!-- 1 ^ CURSOR in Normal mode
                 2 Press: vv
                 3 Seleciton: Lorem ... elit.
                 4 Press: v
                 5 Selection: <p>Lorem ... elit.</p>
                 6 Prees: v
                 7 Selection: <section> ... </section>
                 8 Press: V
                 9 Selection: <p>Lorem ... elit.</p> -->
    <section> 
</main>
```
