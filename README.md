## Notes To Self (readme I guess...)

Two methods, run one command, or install a few things manually then run another script.

### Single Script
Not much benefit doing this step on Linux if using a standard debian distro, all the minimal stuff is pre-installed.

Run the bootstrap script which will automatically install homebrew (if on Mac, assume debian based distro has apt installed already, I ain't running anything cool) and the required packages before cloning this repo and running the install script.
Installs python and git via package manager to run the git user config script.
```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/jamieb133/dotfiles/refs/heads/main/bootstrap.sh)"
```

### Manual-ish
Set up the minimum required (i.e. git & package manager) to run the install script then clone this repo and run it.
```
git submodule update --init
bash install.sh
```

### Misc
Add new packages added to relevant package file (apt_packages.list, Brewfile).
Installing xcode via mas seems to take FOREVER so just install this manually if needed.

