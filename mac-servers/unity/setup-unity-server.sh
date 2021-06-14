if [[ ! -d /Users/administrator ]]; then
    echo /Users/administrator does not exist, exiting.
    return
fi

echo ===================
echo Installing Homebrew
echo ===================

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew update

echo ==================================
echo Installing admin environment tools
echo ==================================

brew install --cask google-chrome
brew install --cask textmate
brew install --cask iterm2

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

echo ======================
echo Installing build tools
echo ======================

brew install rbenv
brew install ruby-build

rbenv install 2.7.1
rbenv global 2.7.1
eval "$(rbenv init -)"

brew tap homebrew/cask
brew tap AdoptOpenJDK/openjdk
brew install --cask adoptopenjdk8

brew install ninja
brew install --cask mono-mdk
brew install --cask android-sdk

export ANDROID_HOME=/usr/local/share/android-sdk
export ANDROID_NDK_HOME=/usr/local/share/android-ndk
export PATH="$PATH:/Library/Frameworks/Mono.framework/Versions/Current/Commands"
sdkmanager --list
yes | sdkmanager "platforms;android-27"
yes | sdkmanager --licenses
curl --silent -o ndk.zip https://dl.google.com/android/repository/android-ndk-r16b-darwin-x86_64.zip
unzip -qq ndk.zip
mv android-ndk-r16b $ANDROID_NDK_HOME
rm ndk.zip

echo ======================
echo Installing required Gems
echo ======================

gem install xcode-install
gem install fastlane
gem install cocoapods

echo =================
echo Configuring tools
echo =================

# Install and configure the Buildkite agent
echo Installing Buildkite agent
brew tap buildkite/buildkite
brew install buildkite-agent
cp /usr/local/etc/buildkite-agent/buildkite-agent.cfg /usr/local/etc/buildkite-agent/buildkite-agent.cfg.orig
cp buildkite-agent.cfg /usr/local/etc/buildkite-agent/buildkite-agent.cfg
cp environment /usr/local/etc/buildkite-agent/hooks

brew services start buildkite/buildkite/buildkite-agent


