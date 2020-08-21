# Configuration variables:
.DEFAULT_GOAL := project

#include an env file if present
#otherwise use global vars from CI
-include .env

export APP_NAME = Binge
export BUNDLE_IDENTIFIER = it.synesthesia.binge
# Prepare Application workspace
project:
	#Using a tmp project.yml to avoid messing up with relative paths
	cat Configuration/project.yml > .tmp_project.yml
	xcodegen generate  --spec .tmp_project.yml
	rm .tmp_project.yml
	bundle exec pod install

resources:
	swiftgen config run --config Configuration/swiftgen.yml

dependencies: 
	bundle exec pod install --repo-update

update_dependencies:
	bundle exec pod update

# Reset the project for a clean build
clean:
	rm -rf *.xcodeproj
	rm -rf *.xcworkspace
	rm -rf Pods/

# Install dependencies, download build resources and add pre-commit hook
setup:
	make clean
	bundle update
	brew update && brew bundle
	eval "$$add_pre_commit_script"
	make resources
	bundle exec pod repo update
	make project

# Define pre commit script to auto lint and format the code
define _add_pre_commit
SWIFTLINT_PATH=`which swiftlint`
SWIFTFORMAT_PATH=`which swiftformat`

cat > .git/hooks/pre-commit << ENDOFFILE
#!/bin/sh

FILES=\$(git diff --cached --name-only --diff-filter=ACMR "*.swift" | sed 's| |\\ |g')
[ -z "\$FILES" ] && exit 0

# Format
${SWIFTFORMAT_PATH} \$FILES

# Lint
${SWIFTLINT_PATH} autocorrect \$FILES
${SWIFTLINT_PATH} lint \$FILES

# Add back the formatted/linted files to staging
echo "\$FILES" | xargs git add

exit 0
ENDOFFILE

chmod +x .git/hooks/pre-commit
endef
export add_pre_commit_script = $(value _add_pre_commit)
