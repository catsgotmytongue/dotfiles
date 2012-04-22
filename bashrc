#!/bin/bash
##### .bash_monolith ### monolithic settings file
############################ SECTION:MAIN SETTINGS ########################################################################

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

shopt -s checkwinsize 

# check for and enable color support
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
	export TERM='xterm-256color'
else 
	export TERM='xterm-color'
fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    [ -e "$HOME/.dircolors" ] && DIR_COLORS="$HOME/.dircolors"
    [ -e "$DIR_COLORS" ] || DIR_COLORS=""
    eval "`dircolors -b $DIR_COLORS`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi

# Needed for RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# include custom color variables
if [ -f ~/.bash_colors ]; then
	. ~/.bash_colors
fi
############################ SECTION:MAIN SETTINGS ########################################################################

################## SECTION:SHELL VARIABLES  ######################################################
dropbox=/home/curt/Dropbox/Public


###### PUBLIC VARS
export HTTP_PROXY='http://proxy.uswestgw.xerox.com:8000'
export http_proxy='http://proxy.uswestgw.xerox.com:8000'

export FTP_PROXY='ftp://proxy.uswestgw.xerox.com:8000'
export ftp_proxy='ftp://proxy.uswestgw.xerox.com:8000'

export WEB_PROJECTS='/var/www/sv/projects'

################## SECTION:SHELL VARIABLES  ######################################################

######################### SECTION:FUNCTIONS #######################################################
##func tn (last octet of IP)
tn() {
	telnet 13.253.25.$1;
}
##func mklab ( IP address to use mklab on)
mklab() {
	asprint -P$1 /mustang/projects/engbook/software/tools/makeLabMachine-on.dlm;
}

##func cmfu (commandlinefu search)
cmfu(){ curl "http://www.commandlinefu.com/commands/matching/$@/$(echo -n $@ | openssl base64)/plaintext"; }

##func shmnt (last 3 chars of IP)
shmnt() {

	if [ -z "$1" ]
	then 
		return
	fi
	if [ ! -d "/mfp/qacave$1" ] 
	then
		echo -e "\n/mfp/qacave$1 doesn't exist so attempting to create"	
		sudo mkdir "/mfp/qacave$1"
		sudo chown curt:curt "/mfp/qacave$1"
		sudo chmod 755 "/mfp/qacave$1"
	fi

	sshfs "root@13.253.25.$1:/" "/mfp/qacave$1"
}
##func shumnt (folder to unmount sshfs from under /mfp/qacave)
shumnt() {
	fusermount -u "/mfp/qacave$1"
}
##func info (file to look in, info to search, grep options)
info() {
	if [ -z $1 ]; then
		return
	fi
	if [ ! -z $3 ]; then 
		grep -i $3 $2 ~/info/$1
	elif [ ! -z $2 ]; then
		grep -i $2 ~/info/$1
	else 
		cat ~/info/$1
	fi
}
##func addinfo(file to add to, info to add)
addinfo(){
	if [ -z $1 ]; then 
		return
	fi
	echo "$2" >> ~/info/$1 # append to the info file
}
##func findtest(regex to find test)
findtest(){
	if [ -z $1 ]; then
		return 
	fi
	
	find $TESTDIR $ACCUREV_MIRROR -iname "$1"

}
##func hold( item to hold )
hold(){
	if [ -z $1 ]; then
		return 
	fi
	mv $1 /mh/3_onhold
}
##func archive(item to archive)
archive(){
	if [ -z $1 ]; then
		return
	fi
	
	mv $1 /mh/4_archive
}
##func addtestfile( testfile to add)
addtestfile (){
	if [ -z $1 ]; then
		return 	
	fi
	mv $1 /mh/testfiles
}
##func addsnippet(snippet to add)
addsnippet(){
	if [ -z $1 ]; then
		return 	
	fi

	mv $1 /mh/snippets
}
##func func(grep regex)
func(){
	if [ -z $1 ]; then
		grep -i "^##func" ~/.bashrc | sed -e 's/##func//g'
		return
	else
		grep -i "^##func $1" ~/.bashrc | sed -e 's/##func//g'

	fi
}
##func sed1
sed1(){ 
	grep "#.*$1.*" ~/info/sed1 
}
##func searchTestResults(string to search for)
searchTestResults(){
	if [ -z $1 ]; then 
		return
	fi

	find -L $TEST_RESULTS -iname "$1"
}
##func drop ([file to copy to dropbox]) ### without params ls $dropbox
drop(){
	if [ -z $1 ]; then
		ls -l $dropbox 
	else 
      cp "$1" $dropbox                                                                                   
   fi                                                                                                     
}                                                                                                         
##func greplist(search string) ### list files containing search string                                    
greplist() {                                                                                              
   grep -il "$1"                                                                                          
}                                                                                                         
##func share(file to share) ### share the file on /share/tmp                                              
share() {                                                                                                 
   cp "$1" /share                                                                                         
}                                                                                                         
                                                                                                          
##func display_stack, aliased to ds ### Display the stack of directories and prompt                       
# the user for an entry.
#
# If the user enters 'p', pop the stack.
# If the user enters a number, move that
# directory to the top of the stack
# If the user enters 'q', don't do anything.
#
function display_stack
{
    dirs -v
    echo -n "#: "
    read dir
    if [[ $dir = 'p' ]]; then
        pushd > /dev/null
    elif [[ $dir != 'q' ]]; then
        d=$(dirs -l +$dir);
        popd +$dir > /dev/null
        pushd "$d" > /dev/null
    fi
}
alias ds=display_stack

##func push_dir_to_stack(dir) ### push dir to stack, then cd and show stack
function push_dir_to_stack(){
	
	pushd . > /dev/null
	if [ ! -z $1 ];then 
		\cd "$1" > /dev/null
	else
		\cd ~ > /dev/null
	fi
  dirs -v
}
alias cds=push_dir_to_stack
##func copy_test_results (file, path_relative_test_results) ### copy test results to test results folder
function copy_test_results() {
	# copy results to test results
	cp $1 "/mustang/projects/solqa/tests/Mamba/Test Results"/$2
}
alias cpres=copy_test_results
##func droplink(dropbox resource from public folder, path_of_link) ### make a link to something from the dropbox public folder for syncing settings, like bash or vim settings
function droplink(){
	rm -rf "$2"
	ln -s $dropbox/"$1" "$2"
}
##func save_dir
function save_dir(){
	if [ -z $1 ]; then 
		cat ~/saved_dirs
	else 
		echo "$1" >> ~/saved_dirs
	fi
}
alias sdir=save_dir

##func randfu
function randfu(){
	wget -qO - http://www.commandlinefu.com/commands/random/plaintext | sed -n '1d; /./p'
}

##func proj(DIR) ### switch to DIR in projects directory
function pj() {
		cd $WEB_PROJECTS/"$1"
}


################################# BASH_PROMPT ################################3
function host_prompt(){
	printf "[ $bldgrn%s$txtrst ]" "\h"
}

function git_prompt() {
   branch=$( git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/' )
	if [ ! -z $branch ]; then
		printf "$txtrst[ $bldgrn%s$txtrst ]" "$branch"
   fi
}

function user_prompt(){
	printf "$txtrst[ $bldred%s$txtrst ]" "$USER"
}

function pwd_prompt(){
	printf "$txtrst[ $bldblu%s$txtrst ]" "$PWD"
}
function links_prompt(){
	num_links=$(ls -l | grep ^l | wc -l)                                                                        # number of links
	if [ "$num_links" != "0" ]; then
		printf "$txtrst[L:$bldcyn%s$txtrst]" "$num_links"
	fi
}
function dir_prompt(){
	num_dirs=$( ls -l | grep ^d | wc -l )                                                                       # number of directories only
	if [ "$num_dirs" != "0" ]; then
		printf "$txtrst[D: $bldylw%s$txtrst]" "$num_dirs"
	fi
}
function files_prompt(){
	num_files=$( ls -l | grep '^-'| wc -l )                                                          # number of files excluding links and directories
	if [ "$num_files" != "0" ]; then	
		printf "$txtrst[F: $bldblu%s$txtrst]" "$num_files"
	fi
}
function hidden_prompt(){
	num_hidden=$( ls -1A | grep '^\.' | wc -l )                                                                    # number of hidden files
	if [ "$num_hidden" != "0" ]; then	
		printf "$txtrst[H: $bldgrn%s$txtrst]" "$num_hidden"
	fi
}
function final_prompt(){
	printf "$bldylw > $txtrst"	
}
function before_prompt() {
	export PS1=$( 
			host_prompt
			user_prompt 
			pwd_prompt  
			git_prompt  
			dir_prompt 
			files_prompt 
			hidden_prompt 
			links_prompt   
			final_prompt
		)
}

######################### SECTION:FUNCTIONS #######################################################

PROMPT_COMMAND=before_prompt
alias a2host='ssh seewebde@a2s69.a2hosting.com -p 7822'
