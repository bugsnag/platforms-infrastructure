if [[ ! -d /Users/administrator ]]; then
    echo /Users/administrator does not exist, exiting.
    return
fi

echo ===================
echo Installing Homebrew
echo ===================

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew update
export PATH=/opt/homebrew/bin:$PATH
export BREW_PREFIX=`brew --prefix`

echo ==================================
echo Installing admin environment tools
echo ==================================

brew install --cask google-chrome
brew install --cask textmate
brew install --cask iterm2
brew install coreutils

# Clean up the dock
brew install dockutil
dockutil --remove 'Calendar'
dockutil --remove 'Contacts'
dockutil --remove 'Messages'
dockutil --remove 'FaceTime'
dockutil --remove 'Mail'
dockutil --remove 'Maps'
dockutil --remove 'Music'
dockutil --remove 'News'
dockutil --remove 'Photos'
dockutil --remove 'Podcasts'
dockutil --remove 'Reminders'
dockutil --remove 'TV'

# Add items to the dock
dockutil --add '/Applications/Google Chrome.app'
dockutil --add '/Applications/iTerm.app'

echo ======================
echo Installing build tools
echo ======================

if [[ `uname -m` == "arm64" ]];
then
  echo A | softwareupdate --install-rosetta
fi

brew install rbenv
brew install ruby-build
brew install npm

rbenv install 2.7.4
rbenv global 2.7.4
eval "$(rbenv init -)"

brew tap homebrew/cask

brew install ninja
brew install --cask mono-mdk
brew install --cask android-commandlinetools

brew install openjdk@11
export PATH="$BREW_PREFIX/opt/openjdk@11/bin:$PATH"

export ANDROID_HOME=$BREW_PREFIX/share/android-sdk
export ANDROID_NDK_HOME=$BREW_PREFIX/share/android-ndk
export PATH="$PATH:/Library/Frameworks/Mono.framework/Versions/Current/Commands"
yes | $BREW_PREFIX/share/android-commandlinetools/cmdline-tools/homebrew/bin/sdkmanager "platforms;android-27"
yes | $BREW_PREFIX/share/android-commandlinetools/cmdline-tools/homebrew/bin/sdkmanager --licenses

curl --silent -o ndk.zip https://dl.google.com/android/repository/android-ndk-r16b-darwin-x86_64.zip
unzip -qq ndk.zip
mv android-ndk-r16b $ANDROID_NDK_HOME
rm ndk.zip

echo ==============================
echo Installing global NPM packages
echo ==============================
npm install -g appium # Used to run macOS end-to-end tests

echo ======================
echo Installing required Gems
echo ======================

gem install xcode-install
gem install fastlane
gem install cocoapods
gem install bundler

echo =========================
echo Installing appium-for-mac
echo =========================
curl -L --output AppiumForMac.zip https://github.com/appium/appium-for-mac/releases/download/v0.4.1/AppiumForMac.zip
unzip AppiumForMac.zip
rm AppiumForMac.zip
mv AppiumForMac.app /Applications/AppiumForMac.app

echo =================
echo Configuring tools
echo =================

# Install and configure the Buildkite agent
echo Installing Buildkite agent
brew tap buildkite/buildkite
brew install buildkite-agent
cp $BREW_PREFIX/etc/buildkite-agent/buildkite-agent.cfg $BREW_PREFIX/etc/buildkite-agent/buildkite-agent.cfg.orig
cp buildkite-agent.cfg $BREW_PREFIX/etc/buildkite-agent/buildkite-agent.cfg
cp environment $BREW_PREFIX/etc/buildkite-agent/hooks
