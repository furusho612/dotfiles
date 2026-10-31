# dotfiles

[![Ansible lint](https://github.com/sfuruya0612/dotfiles/actions/workflows/lint.yml/badge.svg)](https://github.com/sfuruya0612/dotfiles/actions/workflows/lint.yml)

## Description

Setting macOS with Ansible.

## Settings

### Prepare

Install homebrew and run `/opt/homebrew/bin/brew install git`.

```bash
make init
```

Create `~/.gitconfig.local` with your git identity (not managed by this repository):

```ini
[user]
	name = <your name>
	email = <your email>
```

### Install

```bash
make
```

Install a single role:

```bash
ROLE=shell make install.role
```

### Upgrade homebrew packages

Package upgrades are separated from the install tasks because they are not idempotent.

```bash
make upgrade
```

## Lint

```bash
make lint
```

## Notes

### Module interpreter

`inventory/group_vars/all.yml` pins the interpreter used to run modules to the interpreter
running `ansible-playbook` (`ansible_playbook_python`). This is required because a
version-agnostic path such as `/opt/homebrew/bin/python3` follows Homebrew's Python upgrades:
when it pointed at Python 3.15, every module died on import with
`AttributeError: module 'dataclasses' has no attribute '_is_type'` (ansible-core 2.21 patches
`dataclasses._is_type`, which Python 3.15 removed).

Do not set `interpreter_python` to a version-agnostic path in `ansible.cfg`; it falls back to
interpreter discovery (`auto_silent`) when `group_vars` does not apply, for example with an
ad-hoc command against another inventory.
