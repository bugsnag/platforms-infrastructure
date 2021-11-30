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
brew install --cask firefox
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

# Install and configure the Buildkite agent
echo Installing Buildkite agent
brew tap buildkite/buildkite
brew install buildkite-agent
PREFIX=`brew --prefix`
cp $PREFIX/etc/buildkite-agent/buildkite-agent.cfg $PREFIX/etc/buildkite-agent/buildkite-agent.cfg.orig
cp buildkite-agent.cfg $PREFIX/etc/buildkite-agent/buildkite-agent.cfg
ln -s $PREFIX/etc/buildkite-agent/buildkite-agent.cfg /Users/administrator/buildkite-agent.cfg
cp environment $PREFIX/etc/buildkite-agent/hooks

# Install launchd agent to clean up drive space on login
cp com.bugsnag.cleanup.agent.plist /Users/administrator/Library/LaunchAgents
mkdir -p /Users/administrator/scripts
cp cleanup.sh /Users/administrator/scripts
