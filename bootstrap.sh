#!/bin/bash 

# Set the language. This is required for some Python tools.
# Fix 'perl: warning: Setting locale failed.'
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

ASDF_VERSION="v0.10.2"

function _setup_darwin() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "~> homebrew"
  brew tap Homebrew/bundle
}

function _setup_linux() {
  echo "~> rpm packages"
  sudo dnf install \
      https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
      https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  sudo dnf check-update
  sudo dnf install $(cat rpm) -y
  if [ ! -d $HOME/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  fi

  mkdir -p ~/franz
  wget -O ~/franz/Franz.AppImage https://github.com/meetfranz/franz/releases/download/v5.7.0/Franz-5.7.0.AppImage
  chmod +x ~/franz/Franz.AppImage

  # golang dir
  mkdir -p $HOME/go

  if test "$(which docker)"; then
    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo systemctl enable docker
    sudo systemctl start docker
  fi

  if test ! "$(which snap)"; then
    sudo dnf install snapd
    # To enable classic snap support
    sudo ln -s /var/lib/snapd/snap /snap
  fi

  sudo snap refresh
  for a in "$(cat snap)"; do
    echo "~> snap app: $a\n"
    sudo snap install $a &
    pid=$!
    echo "~> wait for $a\n"
    wait $pid && echo "$a OK" || echo "$a NOT OK"
  done

  _create_shortcuts
}

function _create_shortcuts() {
  echo "~> create shortcuts"
  cp -R desktop/*.desktop ~/.local/share/applications
  cp -R desktop/*.png ~/.local/share/icons
  chmod 755 ~/.local/share/applications/*.desktop ~/.local/share/icons/*.png
}

function _setup_asdf() {
  asd_path="$HOME/.asdf/asdf.sh"

  # shellcheck disable=SC1090
  source "$asd_path" || {
    echo "~~> Installing asdf"
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch "${ASDF_VERSION}"
    echo -e "\n source $asd_path" >>"$HOME"/.bashrc
    test -f "$HOME"/.zshrc &&
      echo -e "\n source $asd_path" >>"$HOME"/.zshrc
    source "$asd_path"
  }
}

function _setup_zsh() {
  echo -e "~> zsh\n"
  mkdir -p $HOME/.zsh
  cp -R zsh/{*.zsh,plugins} $HOME/.zsh/
  cp -R zsh/zshrc $HOME/.zshrc

  echo "~> git"
  mkdir -p $HOME/.git
  cp -R git/* $HOME/.git
  cp -R git/.gitconfig $HOME/.gitconfig
  cp -R git/.gitconfig.lib $HOME/.gitconfig.lib

  echo "~> antibody plugin"
  if test "$(uname)" = "Darwin"; then
    brew install antibody
  else 
    sudo dnf install https://github.com/getantibody/antibody/releases/download/v6.1.1/antibody_6.1.1_linux_amd64.rpm
  fi
}

if test "$(uname)" = "Darwin"; then
  _setup_darwin
  
  elif test "$(uname)" = "Linux"; then
  _setup_linux
fi

_setup_zsh
_setup_asdf

exit 0
