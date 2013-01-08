## Install Ruby Environment
  1. Install required libs
    1. On ubuntu `sudo apt-get install -y build-essential openssl curl libcurl3-dev libreadline6 libreadline6-dev git zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf automake libtool imagemagick libmagickwand-dev libpcre3-dev libsqlite3-dev`
  2. Install RVM via “curl” command (rvm is a convenient tool to install ruby )
    1. Install RVM: `curl -L https://get.rvm.io | bash -s stable`
    2. After install RVM, the system will give some tips. One of them is `To start using RVM you need to run "source /home/someone/.rvm/scripts/rvm"`, so just run `source /home/someone/.rvm/scripts/rvm` in your open shell.
  3. Install ruby via RVM
    1. Run `rvm install ruby`
    2. If you see some notice that you are lack of some libs. You will get a list of what your sysmtem need. Please install them and retry.
    3. Ensure Ruby is installed or not. Run `ruby -v` in your command shell. You should see "ruby 1.9.3p327" or something like this.
  4. Configure for RVM and ruby gems
    1. Appoint ruby version `rvm use 1.9.3`
    2. Create a new gem set for ruby, for example here we give it a name "sinatra": `rvm gemset create sinatra`. To ensure whether the gemset is created, please run `rvm gemset list`. You should see the "default" and what you just typed.
    3. Appoint the gemset created in previous step as default, after this you will not need to select the gemset anymore. `rvm use 1.9.3@sinatra --default`


## Install the Project
  1. Get the codes. The structure of the project is under below.

```
  |--aplication.rb
  |--config.ru
  |--config.yml
  |--Gemfile
  |--README.md
  |--config
  |  |--config.yml
  |  |--user.yml
  |--lib
  |  |--x_log.rb
  |--public
  |  |--CSS and JS here
  |--views
  |  |--layout.erb
  |  |--logs.erb
  |  |--new.erb
  |  |--sections.erb
```

  2. Edit the basic settings
    1. Copy the example file to your own file
      * Run `cp config/config.example.yml config/config.yml`
      * And `cp config/user.example.yml config/user.yml`
    2. Edit the lines #2~4 in config/config.yml to set where are your files
    3. Edit config/user/yml to set HTTP authentication name and password of your own
  3. Install the necessary ruby gems. In the project directory, run `bundle install`

## Test the project
  1. Run `ruby application.rb -e production` in project derectory. This will start the program on your localhost with port `4567` as default
    * Here are some other options for this command `ruby application.rb [-h] [-x] [-e ENVIRONMENT] [-p PORT] [-o HOST] [-s HANDLER]`
    * More detailed description for the options: `ruby application --help`
  2. Visit `http://localhost:4567` in your browser

## Run the project in production model
  1. Make sure you have a port that is not in use. I suggest you shut down the process what we test in previous step.
  2. Launch: run `thin -e production -p 4567 -d start` in the root directory of this project.
  3. Restart and stop: run `thin restart` or `thin stop` in the root directory of this project.

## Further System Configuration
If needed, do some configuration to run this project automatically when the server start up.
