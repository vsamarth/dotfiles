#!/usr/bin/env bash

function cmdExists() {
	command -v "$1" >/dev/null 2>&1
}
function checkInternetConnection() {
	if [ ping -q -w1 -c1 google.com ] &>/dev/null; then
		error "Please check your internet connection"
		exit 0
	else
		info "Connected to internet"
	fi
}

function checkOperatingSystem() {
	if [[ "$OSTYPE" == "darwin"* ]]; then
		info "Running macOS v$(sw_vers -productVersion)"
	else
		error "MacOS is required to run this script"
		exit 1
	fi
}

function subheading() {
	echo
	tput bold
	tput setaf 4
	echo "   $(tput smul)$1"
	tput sgr0
	echo
}

function ensureInstalled() {
	local name=$1
	local pkg=$2

	if ! cmdExists "$pkg"; then
		info "Installing $name"
		brew install -q "$pkg"
	else
		info "$name found at $(which $pkg)"
	fi
}

function askSudo() {
	# Ask for the administrator password upfront
	sudo -v

	# Keep-alive: update existing `sudo` time stamp until script has finished
	while true; do
		sudo -n true
		sleep 60
		kill -0 "$$" || exit
	done 2>/dev/null &
}

function heading() {
	echo
	tput bold
	tput setaf 4
	echo "❯❯ $1"
	tput sgr0
}

function info() {
	tput bold
	echo " ❯ $1"
	tput sgr0
}
function error() {
	tput bold
	tput setaf 1
	echo " ❯ $1"
	tput sgr0
}

function warning() {
	tput bold
	tput setaf 3
	echo " ❯ $1"
	tput sgr0
}

function success() {
	tput bold
	tput setaf 2
	echo " ❯ $1"
	tput sgr0
}
