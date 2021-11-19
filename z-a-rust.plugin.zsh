# Copyright (c) 2019 Sebastian Gniazdowski
# License MIT


# According to the Zsh Plugin Standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html

0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

autoload .za-rust-bin-or-src-function-body \
    za-rust-atload-handler za-rust-atclone-handler \
    za-rust-atpull-handler za-rust-help-handler \
    za-rust-atdelete-handler

# An empty stub to fill the help handler fields
za-rust-help-null-handler() { :; }

@zinit-register-annex "zinit-annex-rust" \
    hook:atload-40 \
    za-rust-atload-handler \
    za-rust-help-handler \
    "rustup|cargo''" # also register new ices

@zinit-register-annex "zinit-annex-rust" \
    hook:atclone-40 \
    za-rust-atclone-handler \
    za-rust-help-null-handler

@zinit-register-annex "zinit-annex-rust" \
    hook:\%atpull-40 \
    za-rust-atclone-handler \
    za-rust-help-null-handler

@zinit-register-annex "zinit-annex-rust" \
    hook:atdelete-40 \
    za-rust-atdelete-handler \
    za-rust-help-null-handler

