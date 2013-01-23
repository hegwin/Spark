## Install Ruby Environment
  1. Install required libs
    1. On ubuntu `sudo apt-get install -y build-essential openssl curl libcurl3-dev libreadline6 libreadline6-dev git zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf automake libtool imagemagick libmagickwand-dev libpcre3-dev libsqlite3-dev`.
  2. Dowload ruby source code
    1. Visit official website of [ruby](http://rubu-lang.org) and find the latest ruby version. The current version is 1.9.3-p362.
    2. Run `wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p362.tar.gz`
  3. Make and install ruby
    1. Uncompress. Run `tar xzf ruby-1.9.3-p362.tar.gz`
    2. Make and install
      1. `cd ruby-1.9.3-p362`
      2. Configure. Run `./configure --prefix=/opt/ruby/1.9.3-p362 --enable-pthread --enable-shared`. This will install ruby in `/opt/ruby/1.9.3-p362`
      3. Make. Just run `make` in the ruby source code directory
      4. Install ruby. Run `sudo make install`
    3. Add links to your bin directory

      ```
        sudo ln -s /opt/ruby/1.9.3-p362/ruby /usr/local/bin/ruby
        sudo ln -s /opt/ruby/1.9.3-p362/rake /usr/local/bin/rake
        sudo ln -s /opt/ruby/1.9.3-p362/irb /usr/local/bin/irb
        sudo ln -s /opt/ruby/1.9.3-p362/gem /usr/local/bin/gem
      ```

    4. Install "bundle" gem
      1. Run `sudo gem install bundle`
      2. Add "bundle" to bin directory, `sudo ln -s /opt/ruby/1.9.3-p362/bundle /usr/local/bin/bundle`


## Install the Project
  1. Get the codes, and put them into `/srv` directory, for example I put them into `/srv/sftp_monitor_spark/`. The structure of the project is under below.

    ```
      |--app
      |  |--controllers
      |  |--helpers
      |  |--views
      |--config
      |  |--boot.rb
      |  |--config.yml
      |  |--user.yml
      |--lib
      |  |--x_log.rb
      |--public
      |  |--CSS and JS here
      |--config.ru
      |--Gemfile
      |--README.md
    ```

  2. Edit the basic settings
    1. Copy the example file to your own file
      ```
        cp config/config.example.yml config/config.yml
        cp config/user.example.yml config/user.yml
      ```
    2. Edit the lines #2~5 in config/config.yml to set where are your files. Attention, the `ini`, `schedule` and `lock_file` should be put into the same diretory as scripts.
    3. Edit config/user.yml to set HTTP authentication name and password of your own.
  3. Install the necessary ruby gems. In the project directory, run `bundle install`

## Test the Project
  1. Run `ruby config/boot.rb -e production` in project directory. This will start the program on your localhost with port `4567` as default
    * Here are some other options for this command `ruby application.rb [-h] [-x] [-e ENVIRONMENT] [-p PORT] [-o HOST] [-s HANDLER]`
    * More detailed description for the options: `ruby config/boot.rb --help`
  2. Visit `http://localhost:4567` in your browser

## Deploy in Production Model with Nginx
  1. Make sure your port is available. For example, if you plan to use Port 3000, you can run `sudo netstat -ltnp | grep ':3000'` to see whether Port 3000 is being used by other process.
  2. Install Nigix with Passenger. During the installation, select the default configurations.

    ```
      sudo gem install passenger
      sudo /opt/ruby/1.9.3-p362/bin/passenger-install-nginx-module
    ```

  3. Add Nginx to service and start up auto run list

    ```
      wget https://raw.github.com/gist/1548664/53f6d7ccb9dfc82a50c95e9f6e2e60dc59e4c2fb/nginx
      sudo cp nginx /etc/init.d/
      sudo chmod +x /etc/init.d/nginx
      sudo update-rc.d nginx defaults
    ```

  4. Configure Nginx
    1. Edit the Nginx configuration file (/opt/nginx/conf/nginx.conf)

      ```
        server {
        listen       3000;
        server_name  localhost;

        location / {
        root /srv/sftp_monitor_spark/public;
        passenger_enabled on;
        }
      ```

    2. Restart Nginx

      Run `sudo service nginx restart`
