.PHONY: clean install-stow stow

.DEFAULT_GOAL := stow

###############################################################################
# Detect OS
UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
	OS := macos
else
	OS := $(shell cat /etc/os-release | grep ^ID= | cut -d= -f2 | tr -d '"')
endif

###############################################################################
# Cleanup
clean:
	stow -v -t ${HOME} -D .

###############################################################################
# Install GNU stow with OS specific install manager
install-stow:
ifeq ($(OS), macos)
	brew install stow
else ifeq ($(OS), fedora)
	sudo dnf install -y stow
else ifeq ($(OS), rhel)
	sudo yum install -y epel-release
	sudo yum install -y stow
else ifeq ($(OS), sles)
	sudo zypper install -y stow
else ifeq ($(OS), ubuntu)
	sudo apt update
	sudo apt install -y stow
else
	@echo "Unsupported operating system"
	@exit 1
endif

###############################################################################
# Run stow for the current directory, ignoring Makefile and stow-related files
stow:
	stow -v -t ${HOME} -R . --ignore=Makefile

