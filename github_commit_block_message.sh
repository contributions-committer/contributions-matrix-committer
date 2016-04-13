#!/bin/bash

# setup
printf "This involves changing the local time on your computer. This could have\n"
printf "terrible side effects on applications. Please use at your own risk. At \n"
printf "the end of this script, it will attempt to set the date back to \n"
printf "syncronized time.\n"
printf "\e[1;41m YOU HAVE BEEN WARNED \e[0;39m\n"
printf ""
printf "You will need to create a GitHub repository and feed the script the remote URL.\n"
printf "If this script was cloned, DO NOT attempt to run it from the cloned repository,\n"
printf "instead, pull the bash script and txt file out to a new empty directory and run\n"
printf "from there."
printf ""
printf "There must be a file called \e[1mdates_to_draw.txt\e[0m that I will use\n"
printf "to draw out your message"

TEMP_DIR=`pwd`
if [ ! -f dates_to_draw.txt ]; then
  echo "Could not find 'dates_to_draw.txt'"
  echo "Exiting..."
  exit 1
fi
DATES_TO_DRAW_FILE="$TEMP_DIR/dates_to_draw.txt"
gem install faker
git init hire_me
cd hire_me

# collect info from user
printf "\e[1mPlease enter the GitHub repository url: \e[0m"
read REPOSITORY_URL
git remote add origin $REPOSITORY_URL

printf "\e[1mPlease enter your GitHub Name (eg. John Doe): \e[0m"
read GITHUB_USER_NAME
git config user.name $GITHUB_USER_NAME

printf "\e[1mPlease enter your GitHub Email (eg. john@doe.com): \e[0m"
read GITHUB_EMAIL_ADDRESS
git config user.email $GITHUB_EMAIL_ADDRESS

printf "\e[1mPlease enter your commit messages (all of them will be this.): \e[0m"
read COMMIT_MESSAGE

printf "You will be prompted several times to enter your sudo password. This is\n"
printf "for changing the system time. Sorry for the annoyance.\n"

echo "Hire Me" >> hire_me.txt
git add hire_me.txt
git commit -m "Hire Me"
git push -u origin master

# loop over days to add history for.
while read -r change_to_date; do
  if [[ ${change_to_date:0:1} == "#" ]]; then printf "$change_to_date\n"; continue; fi
  if [[ ${change_to_date:0:1} == " " ]]; then continue; fi
  printf "\n\n== Changing time to $change_to_date\n"
  sudo date $change_to_date
  for i in {1..25}; do
    buzz_word=`ruby -e "require 'faker'; puts Faker::Company.buzzword"`
    printf "Putting in \"$buzz_word\" and committing number $i\n"
    echo $buzz_word >> hire_me.txt
    git add hire_me.txt
    git commit -m "$COMMIT_MESSAGE"
  done
done < "$DATES_TO_DRAW_FILE"

sudo ntpdate -u time.apple.com
git push -u origin master
echo "AND WE'RE DONE. Go check out your repository!"

unset REPOSITORY_URL
unset GITHUB_USER_NAME
unset GITHUB_EMAIL_ADDRESS
unset SUDO_PASSWORD
