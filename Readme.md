# Skeleton
![img](Sources/App/Supporting%20Files/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png)

This is a working empty app that can be used as a starting point for a new project.

## Documentation

Full architecture is available [here](Documentation/doc.md)

## "External" tools needed

To properly set up the project, you'll need:

- XCode, properly setup with current toolchain
- [Bundler](https://bundler.io/), to handle gems for current project without having to install them system-wide
- [Murray](https://github.com/synesthesia-it/Murray), to handle internal *Bones*

*Bundler* will install Cocoapods and Fastlane in cloned project.
All cocoapods and fastlane commands **MUST** be handled through Bundler by prepending `bundle exec` to normal command

Example: 
`bundle exec pod install`

*This is required in order to synchronize the same pod version across each developer, therefore avoiding the annoying `Podfile.lock not in sync` message*

## New project

This Skeleton provides a `Skeletonspec.json` file to be used with [Murray](https://github.com/synesthesia-it/Murray).
To create a new Project, after installing Murray, simply run

`murray skeleton new MyProject git@gitlab.com:synesthesia_team/mobile/ios/internal/skeleton.git@develop`

This will create a project named "MyProject" in a folder with the same name under current directory and automatically install bundle (cocoapods + fastlane) in proper directory.

A starting .gitignore file is already provided within the Skeleton project.

*Please, make sure that a folder with the same name doesn't exists before running that command*

## Existing project

Simply run `. install.sh` from root directory to completely configure an already existing project.

## Update pods

Please use `bundle exec pod update`



