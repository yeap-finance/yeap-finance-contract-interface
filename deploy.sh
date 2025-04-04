#!/usr/bin/env bash

PACKAGE_PATHS=(
        yeap-utils
        yeap-irm
        yeap-vault
        yeap-oracle
        yeap-borrow
        yeap-earn-api
        yeap-borrow-api
      )

      # Get profile from command line arguments, default to "default" if not provided
      PROFILE="${1:-default}"

      # Determine whether to skip fetching latest git dependencies
      SKIP_FETCH_LATEST_GIT_DEPS=""
      if [ "$2" = "skip-git-deps" ]; then
        SKIP_FETCH_LATEST_GIT_DEPS="--skip-fetch-latest-git-deps"
      fi

      echo "Using profile: $PROFILE"
      echo "Skip fetch latest git deps: $SKIP_FETCH_LATEST_GIT_DEPS"

      for package_path in "${PACKAGE_PATHS[@]}"; do
        echo "Processing package: $package_path"
        # Add your deployment logic here for each package
        aptos move publish $SKIP_FETCH_LATEST_GIT_DEPS --profile "$PROFILE" --included-artifacts none --package-dir $package_path --assume-yes
      done