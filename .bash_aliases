export PIP_REQUIRE_VIRTUALENV=true
gpip() {
	    PIP_REQUIRE_VIRTUALENV="" pip "$@"
    }
alias work="cd ~/Desktop/projects"
alias gurobi="cd /opt/gurobi605/linux64/; python setup.py install; cd -"
alias gurobi_dist="cd /opt/gurobi751/linux64/; python setup.py install; cd -"
alias envs="source ~/Desktop/variables.env"
# export PS1="\${debian_chroot:+(\$debian_chroot)}\u@\h:\w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "
alias int="export APIHOST='http://data-int.visibleworld.com'"
alias stag="export APIHOST='http://data-staging.visibleworld.com'"
alias prod="export APIHOST='https://data.visibleworld.com'"
alias integration="export ENVIRONMENT='integration'"
alias staging="export ENVIRONMENT='staging'"
alias production="export ENVIRONMENT='production'"
alias desk="cd ~/Desktop"
alias dumptruck="ssh admin@drop.dev.alg.visibleworld.com"
# alias lock="sudo iptables -A OUTPUT -p tcp --dport 25 -j REJECT"
# alias unlock="sudo iptables -F"
alias bunny="sudo rabbitmqctl list_queues name messages_ready messages_unacknowledged"
# all outgoing mail with port 25 as a destination gets remapped to localhost:25
alias lock='sudo iptables -t nat -A OUTPUT -p tcp --dport 25 -j DNAT --to-destination 127.0.0.1:2525; python /home/todd/Desktop/emails/smtp.py &'

# alias smtp_rule='sudo iptables -t nat -A OUTPUT -p tcp -d 10.124.5.40 -j DNAT --to-destination 127.0.0.1:2525'
# when this gets annoying, delete all the iptable rules you made.
alias unlock='sudo iptables -t nat -F; fuser -k 2525/tcp'
alias rabbit='fuser -k 8888/tcp'
alias api='fuser -k 2345/tcp'
alias gitnames='git diff --name-only'
alias dockerclean='docker kill $(docker ps -a -q); docker rm $(docker ps -a -q)'
alias safedc='docker rmi $(docker images -f dangling=true -q)'
alias localrabbit="export RABBITMQBROKER='amqp://guest:guest@localhost:5672/'"
alias mux='tmux source-file ~/.tmux.conf'
alias vpn='sudo openconnect nycsslvpn.freewheel.tv'
alias pinkie='setxkbmap -option caps:ctrl_modifier'
alias caps='setxkbmap -option'
alias hive_int='ssh toddg@hdpintdg01'
alias todd='ssh todd@172.16.208.176'
alias levelab='ssh toddg@level01.ab.data.visibleworld.com'
alias brandon='ssh -i brandon.key ubuntu@10.25.99.123'
