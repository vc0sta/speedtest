# Automation script for instatlling telegraf agent

#
#Set Colors
#

bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

purple=$(tput setaf 171)
red=$(tput setaf 1)
green=$(tput setaf 76)
tan=$(tput setaf 3)
blue=$(tput setaf 38)

#
# Headers and  Logging
#

e_header() { printf "\n${bold}==========  %s  ==========${reset}\n" "$@" 
}
e_arrow() { printf "➜ $@\n"
}
e_success() { printf "${green}✔ %s${reset}\n" "$@"
}
e_error() { printf "${red}✖ %s${reset}\n" "$@"
}
e_warning() { printf "${tan}➜ %s${reset}\n" "$@"
}
e_underline() { printf "${underline}${bold}%s${reset}\n" "$@"
}
e_bold() { printf "${bold}➜ %s${reset}\n" "$@"
}
e_note() { printf "${bold}${blue}➜ %s${reset}  ${blue}%s${reset}\n" "$@"
}

# The script
e_header "Installing Telegraf agent (metrics collector)"
e_warning "Warning! Script works for Raspbian Buster"

e_bold "Identify version of Raspbian"
cat /etc/os-release
e_success "Finish identification of release"


e_bold "Add the repository GPG key and add the repo itself"
curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
e_success "Finish GPG key add"

e_bold "Add the repository"
echo "deb https://repos.influxdata.com/debian buster stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
e_success "Finish adding the repository"

e_bold "Installing telegraf agent"
sudo apt-get update
sudo apt-get install telegraf
e_success "Finish install of the agent"

e_bold "Systemctl initialization"
sudo systemctl start telegraf
sudo systemctl status telegraf
e_success "Finish with systemctl"

e_bold "Replace the configuration file with the new one"
sudo cp telegraf.conf /etc/telegraf/telegraf.conf
e_success "Finish change of the configuration file"

e_bold "Add permissions for the agent"
sudo usermod -G video pi
sudo usermod -G docker pi
sudo usermod -aG docker pi

sudo usermod -G video telegraf
sudo usermod -G docker telegraf
sudo usermod -aG docker telegraf
sudo usermod -aG video telegraf
sudo usermod -G video www-data
e_success "Finish giving permissions"

e_bold "Restart the agent service"
sudo systemctl restart telegraf
sudo systemctl status telegraf
e_success "Finish restart of the agent"

e_header "Installation complated"
