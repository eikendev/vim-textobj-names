Usage
-----

The textobj-names plugin provides a few new text-objects for working with names in source code.
You can use them when you have to deal with names that are separated by delimiters like `-`, `_`, `/`, `@` or `#`.

Here is an example for a situation this plugin might help you in.
In your source code, you have a variable name like `my-old-name`.
Let's suppose you have to change `old` to `new` and want to get rid of the dashes (\| for cursor position).
Using this plugin, you can do the following.
`my-o|ld-name` and type `ca-` to get `my|name` from where you can insert `new`.

Similarly, the name could have been `my/old/name` or `my_old_name`, in which case you would have to type `ca/` or `ca_` respectively.

The plugin is able to handle consecutive delimiters as well.
That means, transforming the variable name `my__variable__name` into `myname` can be done via one simple `da_`.

Installation
------------

The plugin depends on the awesome [vim-textobj-user](https://github.com/kana/vim-textobj-user) by [kana](https://github.com/kana).
You need to install it in order to use this plugin.

### Plug
```
Plug 'kana/vim-textobj-user'
Plug 'eikendev/vim-textobj-names'
```
### Vundle
```
Plugin 'kana/vim-textobj-user'
Plugin 'eikendev/vim-textobj-names'
```
### NeoBundle
```
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'eikendev/vim-textobj-names'
```
