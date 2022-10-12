#!/bin/sh

cd $(dirname "${BASH_SOURCE[0]}")
rm Brewfile
brew bundle dump
