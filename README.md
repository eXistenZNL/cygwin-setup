# Cywin environment setup
A shell script that installs and configures your cygwin environment.

## How to use
1. [Install Cygwin](https://cygwin.com/install.html), use 64 bits for optimal support
1. Make sure you've checked/installed WGET when installing Cygwin
1. Clone this repository
1. Execute the `setup-env.sh` with cygwin
1. After cygwin boots oh-my-zsh. please `exit` it to allow the script to configure oh-my-zsh.

## What does it install
Below is a list of packages/components/settings cygwin installs (if not available already).

- apt-cyg
- keychain
- git
- vim
- zsh
- curl
- php
- oh-my-zsh
- pip
- pla
- fixlinks

## What does it configure
- Replaces your .minttyrc with a clear theme
- Configures oh-my-zsh bira theme
- Optionally generates a SSH keypair
