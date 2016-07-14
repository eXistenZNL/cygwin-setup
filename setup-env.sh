USERNAME=$(whoami | awk '{print tolower($0)}')

echo "Starting Cygwin environment config..."
echo "---------------------"
echo ""

# Install apt-cyg, the apt-get like package manager for cygwin
echo "Step 1, installing apt-cyg... "
if [ -f /usr/local/bin/apt-cyg ]; then
    echo 'Already installed.'
else
    wget -O /usr/local/bin/apt-cyg https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg
    chmod +x /usr/local/bin/apt-cyg
    echo 'Done.'
fi
echo ""

# Install keychain, apt-cyg gives an old version which is no longer working so we grab a newer one from GitHub.
echo "Step 2, installing keychain... "
if [ -f /usr/local/bin/keychain ]; then
    echo 'Already installed.'
else
    KEYCHAIN_VERSION=2.8.3
    wget -qO /usr/local/bin/keychain https://raw.githubusercontent.com/funtoo/keychain/$KEYCHAIN_VERSION/keychain.sh
    sed -i "s/##VERSION##/$KEYCHAIN_VERSION/g" /usr/local/bin/keychain
    chmod +x /usr/local/bin/keychain
    echo 'Done.'
fi
echo ""

# Install some base packages
echo "Step 3, installing some base packages..."
apt-cyg install git vim zsh curl
echo ""

# Installing Oh-My-ZSH
echo 'Step 4, installing Oh-My-zsh...'
if [ -d ~/.oh-my-zsh ]; then
    echo 'Already installed.'
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
echo ""

# Configure Oh-My-ZSH
echo 'Step 5, configuring Oh-My-zsh...'
sed -i 's/ZSH_THEME=.*/ZSH_THEME=bira/' ~/.zshrc
grep -q 'keychain' ~/.zshrc || echo "eval \`keychain ~/.ssh/$USERNAME\`" >> ~/.zshrc
echo "Done."
echo ""

# Creating pubkey
echo 'Step 6, creating a pubkey...'
if [ -f ~/.ssh/$USERNAME ]; then
    echo "A pubkey with the filename $USERNAME already exists, not touching that."
else
    ssh-keygen -t rsa -b 4096 -C "$USERNAME" -f ~/.ssh/$USERNAME
fi
echo ""

echo "---------------------"
echo 'All done. Please modify the Cygwin Terminal symlink you use to start Cygwin (e.g. in the start menu) so it reads like this:'
echo ""
echo '  ...\mintty.exe -i /Cygwin-Terminal.ico -d /bin/zsh --login'
echo ""
echo 'This will autostart ZSH when starting a Cygwin terminal.'
