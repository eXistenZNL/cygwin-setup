#!/bin/bash

USERNAME=$(whoami | awk '{print tolower($0)}')

echo "Starting Cygwin environment config..."
echo "---------------------"
echo

# The readme requires installing wget, without the wget package we can't start-up
hash wget 2>/dev/null || { echo >&2 "wget is not found..."; exit 1; }

# Install apt-cyg, the apt-get like package manager for cygwin
echo "Step 1, installing apt-cyg... "
if [ -f /usr/local/bin/apt-cyg ]; then
    echo 'Already installed.'
else
    wget -qO /usr/local/bin/apt-cyg https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg
    chmod +x /usr/local/bin/apt-cyg
    echo 'Done.'
fi
echo

# Install some base packages
echo "Step 2, installing some base packages available in apt-cyg..."
apt-cyg install git vim zsh curl unzip mingw64-i686-iso-codes > /dev/null
echo 'Done.'
echo

# Install keychain, apt-cyg gives an old version which is no longer working so we grab a newer one from GitHub.
echo "Step 3, installing keychain... "
if [ -f /usr/local/bin/keychain ]; then
    echo 'Already installed.'
else
    KEYCHAIN_VERSION=2.8.3
    wget -qO /usr/local/bin/keychain https://raw.githubusercontent.com/funtoo/keychain/$KEYCHAIN_VERSION/keychain.sh
    sed -i "s/##VERSION##/$KEYCHAIN_VERSION/g" /usr/local/bin/keychain
    chmod +x /usr/local/bin/keychain
    echo 'Done.'
fi
echo

# Installing pip
echo 'Step 4, installing pip & pla...'

apt-cyg install python > /dev/null
if [ -f /usr/bin/pip ]; then
    echo 'Pip already installed.'
else
  wget -qO /tmp/pip_installer.py https://bootstrap.pypa.io/get-pip.py
  python /tmp/pip_installer.py
fi
echo

if [ -f /usr/bin/pla ]; then
    echo 'Pla already installed.'
else
  if uname -a | grep "i686"; then
      echo 'Skiping pla installation due to unsuported 32-bits cygwin'
  else
      pip install pla
  fi
fi
echo

# Installing Composer
echo 'Step 5, installing Composer and requirements...'
apt-cyg install php php-json php-phar php-ctype php-curl php-iconv php-mbstring > /dev/null
if [ -f /usr/local/bin/composer ]; then
    echo 'Already installed.'
else
  wget https://raw.githubusercontent.com/composer/getcomposer.org/1b137f8bf6db3e79a38a5bc45324414a6b1f9df2/web/installer -O - -q | php --
  mv composer.phar /usr/local/bin/composer
  chmod +x /usr/local/bin/composer
fi
echo

# Install fixlinks
echo 'Step 6, installing fixlinks script...'
if [ -f /usr/local/bin/fixlinks ]; then
    echo 'Already installed.'
else
  cp ./fixlinks /usr/local/bin/fixlinks
  chmod +x /usr/local/bin/fixlinks
fi
echo

# Installing Oh-My-ZSH
echo 'Step 7, installing Oh-My-zsh...'
if [ -d ~/.oh-my-zsh ]; then
    echo 'Already installed.'
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
echo

# Grabbing a sane Mintty configuration
echo Step 8, configuring Mintty...
wget -qO ~/.minttyrc https://raw.githubusercontent.com/eXistenZNL/cygwin-setup/master/.minttyrc
echo 'Done.'
echo

# Configure Oh-My-ZSH
echo 'Step 9, configuring Oh-My-zsh and GIT...'
sed -i 's/ZSH_THEME=.*/ZSH_THEME=bira/' ~/.zshrc
git config --global color.diff auto
git config --global color.ui auto
git config --global core.symlinks false
echo "Done."
echo

# Creating pubkey
echo 'Step 10, optionally creating a pubkey...'
if [ -f ~/.ssh/$USERNAME ]; then
    echo "A pubkey with the filename /.ssh/$USERNAME already exists, skipping creation..."
else
    read -p "Do you want to create a SSH public keypair? The filename will be ~/.ssh/$USERNAME y/n " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ssh-keygen -t rsa -b 4096 -C "$USERNAME" -f ~/.ssh/$USERNAME
        grep -q 'keychain' ~/.zshrc || echo "eval \`keychain --eval ~/.ssh/$USERNAME\`" >> ~/.zshrc
    else
        echo 'Assuming you already have a keypair at hand.'
        echo 'Manually put your SSH keys in ~/.ssh, and add the following to ~/.zshrc:'
        echo 'eval \`keychain --eval ~/.ssh/yourkey\`'
        echo "This will start keychain when starting the Cygwin asks for your key's password only once."
    fi
fi
echo

echo "---------------------"
echo 'All done. Please modify the Cygwin Terminal symlink you use to start Cygwin (e.g. in the start menu) so it reads like this:'
echo
echo '  ...\mintty.exe -i /Cygwin-Terminal.ico -d /bin/zsh --login'
echo
echo 'This will autostart ZSH when starting a Cygwin terminal.'
