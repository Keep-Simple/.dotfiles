#!/bin/bash

mkdir -p $LVIM_DEBUGGERS

python -m venv "$LVIM_DEBUGGERS/debugpy"
"$LVIM_DEBUGGERS/debugpy/bin/python" -m pip install debugpy

git clone https://github.com/microsoft/vscode-node-debug2.git "$LVIM_DEBUGGERS/node"
pushd "$LVIM_DEBUGGERS/node"
npm install
NODE_OPTIONS=--no-experimental-fetch npm run build
popd

# TARGET_NAME="codelldb-aarch64-darwin.vsix"
# wget -nc $(curl -s https://api.github.com/repos/vadimcn/vscode-lldb/releases/latest | grep $TARGET_NAME | cut -d\" -f4) -P "$LVIM_DEBUGGERS/codelldb"
# pushd "$LVIM_DEBUGGERS/codelldb"
# unzip $TARGET_NAME
# popd
