#!/bin/bash
#
# Usage: ./sinatra_setup.rb my_app
#
# kelli@kellishaver.com

APP=$1

function make_app_file {
cat <<- _EOF_
require 'rubygems'
require 'sinatra'
require 'bcrypt'
require 'data_mapper'
require 'json'

configure do
  @@config = YAML.load_file("./app.yml") rescue nil || {}
end

require "./lang/" + @@config["default_language"] + ".rb"

Dir["./helpers/*.rb"].each {|file| require file}

DataMapper.setup(:default, ENV['DATABASE_URL'] || @@config["db_connection_string"])
DataMapper::Property::String.length(255)

Dir["./models/*.rb"].each {|file| require file}

DataMapper.finalize

if @@config["db_run_migrations"] == true
    DataMapper.auto_migrate!
end

if @@config["db_run_upgrades"] == true
    DataMapper.auto_upgrade!
end

not_found do
    erb :not_found
end

error do
    erb :error
end

get '/' do
    erb :index
end

Dir["./routes/*.rb"].each {|file| require file}
_EOF_
}

function make_lang_file {
cat <<- _EOF_
@@lang = {
    :invalid_login => "Invalid login or password.",
    :login_required => "You must be logged in to perform this action.",
    :not_found => "Resource not found.",
    :unknown_error => "An unknown error has occurred."
}
_EOF_
}

function make_gem_file {
cat <<- _EOF_
source :gemcutter
gem 'sinatra'
gem 'thin'
gem 'data_mapper'
gem 'dm-sqlite-adapter'
gem 'bcrypt-ruby'
gem 'json'
_EOF_
}

function make_config_file {
cat <<- _EOF_
default_language: en-us
db_connection_string: sqlite3://$(pwd)/test.db
db_run_migrations: true
db_run_upgrades: true
_EOF_
}

function make_rackup_file {
cat <<- _EOF_
require 'rubygems'
require 'sinatra'
require './$APP'
run Sinatra::Application
_EOF_
}

function make_layout_file {
cat <<- _EOF_
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>$APP</title>
  <link rel="icon" type="image/png" href="/img/icon-16.png" />
  <link rel="apple-touch-icon-precomposed" sizes="57x57" href=".img/icon-57.png" />
  <link rel="apple-touch-icon-precomposed" sizes="72x72" href="/img/icon-72.png" />
  <link rel="apple-touch-icon-precomposed" sizes="114x114" href="/img/icon-114.png" />
  <link rel="stylesheet" href="/styles/css/app.css">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script type="text/javascript" src="/js/jquery.min.js"></script>
  <script type="text/javascript" src="/js/app.js"></script>
  <!--[if lt IE 9]>
  <script src="//html5shiv.googlecode.com/svn/trunk/html5.js"></script>
  <![endif]-->
  <!--[if IE]>
  <style type="text/css">
  </style>
  <![endif]-->
</head>
<body>
<div id="container">
<%=yield %>
</div>
</body>
</html>
_EOF_
}

function make_index_erb {
cat <<- _EOF_
<h1>Welcome</h1>
<p>Find me in ./views/index.erb</p>
_EOF_
}

function make_error_erb {
cat <<- _EOF_
<!DOCTYPE html>
<head>
    <meta charset="utf-8">
    <title>Internal Server Error</title>
</head>
<body>
    <h1>500 - Internal Server Error</h1>
    <p>The server encountered an error while processing your request.</p>
</body>
</html>
_EOF_
}

function make_not_found_erb {
cat <<- _EOF_
<!DOCTYPE html>
<head>
    <meta charset="utf-8">
    <title>Not Found</title>
</head>
<body>
    <h1>404 - Not Found</h1>
    <p>The page or resource you requested could not be found.</p>
</body>
</html>
_EOF_
}

function make_gitignore {
cat <<- _EOF_
.DS_Store
__MACOSX/
_EOF_
}

function make_readme {
cat <<- _EOF_
README for $APP
====
_EOF_
}

function make_test {
cat <<- _EOF_
require 'rubygems'
require './$APP'
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class $(echo $APP | awk '{print toupper(substr($0,1,1))substr($0,2);}')Test < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

end
_EOF_
}


if [ ! -d $APP ]
then

    /bin/mkdir -p $APP

    if [ -d $APP ]
    then
        cd $APP

        /bin/mkdir 'views'
        /bin/mkdir -p 'public'
        /bin/mkdir 'routes'
        /bin/mkdir 'models'
        /bin/mkdir 'lang'
        /bin/mkdir 'helpers'

        cp ../frontend.zip ./public/frontend.zip
        cd public
        unzip frontend.zip
        rm frontend.zip
        rm index.html
        rm -rf __MACOSX
        cd ..

        make_app_file >> $APP'.rb'
        make_config_file >> 'app.yml'
        make_gem_file >> 'Gemfile'
        make_rackup_file >> 'config.ru'
        make_lang_file >> 'lang/en-us.rb'
        make_layout_file >> 'views/layout.erb'
        make_index_erb >> 'views/index.erb'
        make_error_erb >> 'views/error.erb'
        make_not_found_erb >> 'views/not_found.erb'
        make_test >> $APP'-test.rb'
        make_readme >> 'readme.mdown'
        make_gitignore >> '.gitignore'

        git init
        git add .
        git commit -a -m "initial import"

        echo "-----------------------------------------------------"
        echo "Project '$APP' created successfully."
        echo "-----------------------------------------------------"

    else
        echo "-----------------------------------------------------"
        echo "Error: Could not create directory '$APP'"
        echo "-----------------------------------------------------"
    fi

else
    echo "-----------------------------------------------------"
    echo "Error: Directory '$APP' already exists."
    echo "-----------------------------------------------------"
fi
