#!/usr/bin/env bash
set -ue

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1

echo -e '\n. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
echo -e '\n. "$HOME/.asdf/completions/asdf.bash"' >> ~/.bashrc

source ~/.bashrc
