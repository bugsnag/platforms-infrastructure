if [[ ! -d /Users/administrator ]]; then
    echo /Users/administrator does not exist, exiting.  Consider adding a symlink to the admin user.
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
brew install --cask chromedriver
brew install --cask firefox
brew install geckodriver
xattr -d com.apple.quarantine /usr/local/bin/chromedriver
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
dockutil --add '/Applications/iTerm.app'

echo ======================
echo Installing build tools
echo ======================

brew tap aws/tap
brew install aws-sam-cli
brew install npm
brew install carthage
brew install rbenv
brew install ruby-build
brew install clang-format

echo Node 14
brew unlink node
brew install node@14
brew link --overwrite node@14

rbenv install 2.7.1
rbenv global 2.7.1
eval "$(rbenv init -)"

echo ======================
echo Installing required Gems
echo ======================

gem install xcode-install
gem install fastlane
gem install cocoapods

echo =========================================
echo Install tools for specific macOS versions
echo =========================================

VERSION=`sw_vers -productVersion`
echo $VERSION
if [[ $VERSION == "10.13"* ]];
then
  echo Install tools for macOS 10.13
  xcversion simulators --install='iOS 9.3'
  xcversion simulators --install='tvOS 9.2'
fi
if [[ $VERSION == "10.15"* ]];
then
  echo Install tools for macOS 10.15
  brew install --cask docker
  xcversion simulators --install='iOS 10.3.1'
  xcversion simulators --install='tvOS 10.2'
fi
if [[ $VERSION == "11."* ]];
then
  echo Install tools for macOS 11
  xcversion simulators --install='iOS 14.4'
  xcversion simulators --install='iOS 14.3'
  xcversion simulators --install='iOS 13.7'
  xcversion simulators --install='iOS 12.4'
  xcversion simulators --install='iOS 11.4'
  xcversion simulators --install='tvOS 14.4'
  xcversion simulators --install='tvOS 14.3'
  xcversion simulators --install='tvOS 13.4'
  xcversion simulators --install='tvOS 13.3'
  xcversion simulators --install='tvOS 12.4'
  xcversion simulators --install='tvOS 11.4'
fi

echo ==============================
echo Installing global NPM packages
echo ==============================
npm install -g turtle-cli@0.17.3 # Used to build Expo
npm install -g appium # Used to run macOS end-to-end tests
npm install -g cspell

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

# NPM authentication with Artifactory
cp .npmrc /Users/administrator

# Install and configure the Buildkite agent
echo Installing Buildkite agent
brew tap buildkite/buildkite
brew install buildkite-agent
PREFIX=`brew --prefix`
cp $PREFIX/etc/buildkite-agent/buildkite-agent.cfg $PREFIX/etc/buildkite-agent/buildkite-agent.cfg.orig
cp buildkite-agent.cfg $PREFIX/etc/buildkite-agent/buildkite-agent.cfg
ln -s $PREFIX/etc/buildkite-agent/buildkite-agent.cfg /Users/administrator/buildkite-agent.cfg
cp environment $PREFIX/etc/buildkite-agent/hooks
cp -r expo /Users/administrator

# Install launchd agent to clean up drive space on login
cp com.bugsnag.cleanup.agent.plist /Users/administrator/Library/LaunchAgents
mkdir -p /Users/administrator/scripts
cp cleanup.sh /Users/administrator/scripts
