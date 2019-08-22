#!/bin/bash
bundle install --path vendor/bundle
bundle exec pod install --repo-update
murray bone setup
open *space
