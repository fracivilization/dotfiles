# TODO: 環境に応じて出力する
# If on nixos
PWD=`pwd`
ln -s "${PWD}/nix/configuration.nix" /etc/nixos/configuration.nix
ln -s "${PWD}/home-manager" "${HOME}/.config/"
ln -s "${PWD}/doom" "${HOME}/.config/doom"
