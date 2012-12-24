## Install Ruby Environment
  1. Install RVM via “curl” command (rvm is a convenient tool to install ruby )
    1. Install RVM: `curl -L https://get.rvm.io | bash -s stable`
    2. After install RVM, the system will give some tips. One of them is `To start using RVM you need to run "source /home/someone/.rvm/scripts/rvm"`, so just run `source /home/someone/.rvm/scripts/rvm` in your open shell.
  2. Install ruby via RVM
    1. Run `rvm install ruby`
    2. If you see some notice that you are lack of some libs. You will get a list of what your sysmtem need. Please install them and retry.
    3. Ensure Ruby is installed or not. Run `ruby -v` in your command shell. You should see "ruby 1.9.3p327" or something like this.
  3. Configure for RVM and ruby gems
    1. Appoint ruby version `rvm use 1.9.3`
    2. Create a new gem set for ruby, for example here we give it a name "sinatra": `rvm gemset create sinatra`. To ensure whether the gemset is created, please run `rvm gemset list`. You should see the "default" and what you just typed.
    3. Appoint the gemset created in previous step as default, after this you will not need to select the gemset anymore. `rvm use 1.9.3@sinatra --default`


## Install the Project
  1. Get the codes. The structure of the project is under below.

```
  |--aplication.rb
  |--config.yml
  |--Gemfile
  |--README.md
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

  2. Edit the config.yml in project directory
    1. Where is your SFTP monitior confugration file? Replace path#ini (line #2) with the .ini configuration file path
    2. Where do you put your log files? Repalce path#log_prefix (line#3) with the directory of log files
  3. Install the necessary ruby gems. In the project directory, run `bundle install`

## Run the project
  1. Run `ruby application.rb -e production` in project derectory. This will start the program on your localhost with port `4567` as default
    * Here are some other options for this command `ruby application.rb [-h] [-x] [-e ENVIRONMENT] [-p PORT] [-o HOST] [-s HANDLER]`
    * More detailed description for the options: `ruby application --help`
  2. Visit `http://localhost:4567` in your browser

## System Configuration
If needed, do some configuration to run this project automatically when the server start up.
