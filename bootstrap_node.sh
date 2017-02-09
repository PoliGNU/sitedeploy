#! /bin/bash
sudo apt update
sudo apt install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 2.3.3
rbenv global 2.3.3
gem install bundler
gem install berkshelf
berks install
curl -LO https://omnitruck.chef.io/install.sh && sudo bash ./install.sh -v 12.17 && rm install.sh
