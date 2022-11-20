# Copyright (c) 2019 Sebastian Gniazdowski
# License MIT


# According to the Zsh Plugin Standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html

0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

autoload -Uz \
  -za-rust::bin-or-src-function-body \
  :za-rust::clone-handler \
  :za-rust::delete-handler \
  :za-rust::load-handler \
  :za-rust::pull-handler \
  :za-rust::help-handler

# An empty stub to fill the help handler fields
:za-rust::help-null-handler() { :; }

@zinit-register-annex "zinit-annex-rust" \
  hook:load-40 \
  :za-rust::load-handler \
  :za-rust::help-handler \
  "rustup|cargo''" # also register new ices

@zinit-register-annex "zinit-annex-rust" \
  hook:clone-40 \
  :za-rust::clone-handler \
  :za-rust::help-null-handler

@zinit-register-annex "zinit-annex-rust" \
  hook:\%pull-40 \
  :za-rust::clone-handler \
  :za-rust::help-null-handler

@zinit-register-annex "zinit-annex-rust" \
  hook:delete-40 \
  :za-rust::delete-handler \
  :za-rust::help-null-handler
