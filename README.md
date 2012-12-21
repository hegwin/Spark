## Install Ruby Environment
  1. Install rvm via “curl” command (rvm is a convenient tool to install ruby )
    1. `curl -L https://get.rvm.io | bash -s stable`
    2. `source /home/hegwin/.rvm/scripts/rvm`
  2. Install ruby via RVM: just one command `rvm install ruby`
  3. Configure rvm and ruby: appoint ruby version `rvm use 1.9.3`

## Install the Project
  1. Get the codes
  2. Edit the config.yml in project directory:
    1. Replace path#ini (line #2) with the .ini configuration file path
    2. Repalce path#log_prefix (line#3) with the directory of log files
  3. install the necessary ruby gems: `bundle install`

## Run the project
  1. Run `ruby application.rb -p production` in project derectory
    * Here are some other options  `ruby application.rb [-h] [-x] [-e ENVIRONMENT] [-p PORT] [-o HOST] [-s HANDLER]`
    * More detailed description: `ruby application --help`
  2. visit `http://localhost:4567`

## System Configuration
If needed, do some configuration to run this project when the server start up.
