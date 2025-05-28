
# =============================================================================
# Install Packages			
# =============================================================================

foreach($line in Get-Content .\choco_packages.list) {
	choco install $line
}

# =============================================================================
# Set Symlinks				
# =============================================================================

$files = (
	@{
		Source = ".zshrc"
		Target = "$HOME\.zshrc"
	},
	@{
		Source = ".config\nvim"
		Target = "$env:LOCALAPPDATA\nvim"
	}
)

foreach($file in $files) {
	$link=$file.Target
	if (Test-Path -Path $link) {
		echo "$link exists"
	} else {
		echo "Creating symlink to $link"
		New-Item -ItemType SymbolicLink -Force -Path $link -Target $file.Source
	}
}

