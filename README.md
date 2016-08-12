# Cywin environment setup
A shell script that installs and configures your Cygwin environment.

## How to use
1. [Install Cygwin](https://cygwin.com/install.html), use 64 bits for optimal support
1. Clone this repository
1. Execute the `setup-env.sh` with Cygwin
1. After cygwin boots oh-my-zsh, please `exit` it to allow the script to configure oh-my-zsh
1. Please modify the Cygwin Terminal symlink you use to start Cygwin (e.g. in the start menu) so it reads like this: `...\mintty.exe -i /Cygwin-Terminal.ico -d /bin/zsh --login`

## What does it install
Below is a list of packages/components/settings that this script installs (if not available already).

- [apt-cyg](https://github.com/transcode-open/apt-cyg)
- [keychain](http://www.funtoo.org/Keychain)
- git
- vim
- zsh
- curl
- wget
- php
- [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
- pip
- [pla](https://github.com/rtuin/pla)
- fixlinks

## What does it configure
- Replaces your .minttyrc with a clear theme
- Configures oh-my-zsh bira theme
- Optionally generates a SSH keypair
- Configures the command line git client with sane defaults

## Troubleshooting

<dl>
  <dt>Unexpected ending on line X</dt>
  <dd>
  There is probably something wrong with your line endings. Ensure the setup-env is saved in Unix format. You can use `dos2unix` or saving the file in Unix format using a text editor.
  </dd>
</dl>
