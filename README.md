# zinit-annex-rust<a name="zinit-annex-rust"></a>

A Zsh-Zinit annex that installs rust and cargo packages locally inside the plugin or snippet directories. The crate can
then have a so called *shim* created (name borrowed from `rbenv`) – a script that's located in the standard `$PATH`
entry "`$ZPFX/bin`" of following contents (example):

```zsh
#!/usr/bin/env zsh

function lsd {
  local bindir="/root/.zinit/plugins/zdharma-continuum---null/bin"
  local -x PATH="/root/.zinit/plugins/zdharma-continuum---null"/bin:"$PATH" # -x means export
  local -x RUSTUP_HOME="/root/.zinit/plugins/zdharma-continuum---null"/rustup CARGO_HOME="/root/.zinit/plugins/zdharma-continuum---null"

  "$bindir"/"lsd" "$@"
}

lsd "$@"
```

As it can be seen shim ultimately provides the binary to the command line.

![example zinit-annex-rust use](https://raw.githubusercontent.com/zdharma-continuum/zinit-annex-rust/master/images/z-a-rust.png)

<!-- mdformat-toc start --slug=github --maxlevel=6 --minlevel=2 -->

- [Installation](#installation)
- [Usage](#usage)
  - [Options](#options)
- [Examples](#examples)
  - [Install rust, the `lsd` crate, and a `lsd` shim exposing the binary](#install-rust-the-lsd-crate-and-a-lsd-shim-exposing-the-binary)
  - [Install rust, the `exa` crate, and a `ls` shim exposing the `exa` binary](#install-rust-the-exa-crate-and-a-ls-shim-exposing-the-exa-binary)
  - [Install rust and then the `exa` and `lsd` crates](#install-rust-and-then-the-exa-and-lsd-crates)
  - [Installs rust and then the `exa' and `lsd' crates and exposes their binaries by altering $PATH](#installs-rust-and-then-the-exa-and-lsd-crates-and-exposes-their-binaries-by-altering-path)
  - [Installs rust and then the `exa` crate and creates its shim with standard error redirected to /dev/null](#installs-rust-and-then-the-exa-crate-and-creates-its-shim-with-standard-error-redirected-to-devnull)
  - [Install Rust and make it available globally in the system](#install-rust-and-make-it-available-globally-in-the-system)
  - [Use Bin-Gem-Node annex to install the cargo completion provided with rustup](#use-bin-gem-node-annex-to-install-the-cargo-completion-provided-with-rustup)

<!-- mdformat-toc end -->

## Installation<a name="installation"></a>

Load like a regular plugin, i.e.,:

```zsh
zi light zdharma-continuum/zinit-annex-rust
```

This installs the annex and makes the `rustup` and `cargo''` ices available.

## Usage<a name="usage"></a>

The Zinit annex provides two new ices: `rustup` and `cargo''`. The first one installs rust inside the plugin's folder
using the official `rustup` installer. The second one has the following syntax:

`cargo"[name-of-the-binary-or-path <-] [[!][c|N|E|O]:]{crate-name} [-> {shim-script-name}]'`

### Options<a name="options"></a>

| Flag | description                                                                                       |
| ---- | ------------------------------------------------------------------------------------------------- |
| `N`  | redirect both standard output and error to `/dev/null`                                            |
| `E`  | redirect standard error to `/dev/null`                                                            |
| `O`  | redirect standard output to `/dev/null`                                                           |
| `c`  | change the current directory to the plugin's or snippet's directory before  executing the command |

As the examples showed, the name of the binary to run and the shim name are by default equal to the name of the crate.
Specifying `{binary-name} <- …` and/or `… -> {shim-name}` allows to override them.

## Examples<a name="examples"></a>

### Install rust, the `lsd` crate, and a `lsd` shim exposing the binary<a name="install-rust-the-lsd-crate-and-a-lsd-shim-exposing-the-binary"></a>

```zsh
zinit ice rustup cargo'!lsd'
zinit load zdharma-continuum/null
```

### Install rust, the `exa` crate, and a `ls` shim exposing the `exa` binary<a name="install-rust-the-exa-crate-and-a-ls-shim-exposing-the-exa-binary"></a>

```zsh
zi ice rustup cargo'!exa -> ls'
zi load zdharma-continuum/null
```

### Install rust and then the `exa` and `lsd` crates<a name="install-rust-and-then-the-exa-and-lsd-crates"></a>

```zsh
zinit ice rustup cargo'exa;lsd'
zinit load zdharma-continuum/null
```

### Installs rust and then the `exa' and `lsd' crates and exposes their binaries by altering $PATH<a name="installs-rust-and-then-the-exa-and-lsd-crates-and-exposes-their-binaries-by-altering-path"></a>

```zsh
zinit ice rustup cargo'exa;lsd' as"command" pick"bin/(exa|lsd)"
zinit load zdharma-continuum/null
```

### Installs rust and then the `exa` crate and creates its shim with standard error redirected to /dev/null<a name="installs-rust-and-then-the-exa-crate-and-creates-its-shim-with-standard-error-redirected-to-devnull"></a>

```zsh
zinit ice rustup cargo'!E:exa'
zinit load zdharma-continuum/null
```

### Install Rust and make it available globally in the system<a name="install-rust-and-make-it-available-globally-in-the-system"></a>

```zsh
zi ice \
    id-as"rust" \
    wait"0" \
    lucid \
    rustup \
    as"command" \
    pick"bin/rustc" \
    atload='export CARGO_HOME=$PWD RUSTUP_HOME=$PWD/rustup'
zi load zdharma-continuum/null
```

### Use Bin-Gem-Node annex to install the cargo completion provided with rustup<a name="use-bin-gem-node-annex-to-install-the-cargo-completion-provided-with-rustup"></a>

```zsh
zi for \
    atload='
      [[ ! -f ${ZINIT[COMPLETIONS_DIR]}/_cargo ]] && zi creinstall rust
      export CARGO_HOME=\$PWD RUSTUP_HOME=$PWD/rustup' \
    as=null \
    id-as=rust \
    lucid \
    rustup \
    sbin="bin/*" \
    wait=1 \
  zdharma-continuum/null
```

When using a global installation of rust in turbo mode, cargos need to omit the rustup ice, and wait on `$CARGO_HOME`
and `$RUSTUP_HOME` environment variables to be available

```zsh
zi for \
    wait='[[ -v CARGO_HOME && -v RUSTUP_HOME ]]' \
    id-as'rust-exa' \
    cargo'!exa' \
  zdharma-continuum/null
```

<!-- vim:set ft=markdown -->
