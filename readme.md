Pulp
====

Pulp is a little shell script and accompanying package of assets to generate a base Sinatra application and front-end boilerplate.

###Usage

Using Pulp is really simple.

    cd pulp
    ./pulp MyApp

Pulp has now generated your base application inside of the folder `MyApp`, which you can now move anywhere.

###What does a Pulp application look like?

You get a basic MVC structured application, a couple of config files, some nice defaults, and a simple HTML/CSS boilerplate. A fresly-squeezed Pulp app looks like this:

    MyApp/
      Gemfile
      MyApp.rb
      Rakefile
      app-config.json
      config.ru
      controllers/
      db/
        config.json
      helpers/
      lang/
        en-us.rb
      models/
      public/
        img/
          icon-114.png
          icon-16.png
          icon-57.png
          icon-72.png
          index.html
        js/
          app.js
          index.html
          jquery.min.js
        styles/
          css/
          font/
            fontawesome-webfont.eot
            fontawesome-webfont.svg
            fontawesome-webfont.ttf
            fontawesome-webfont.woff
            index.html
          index.html
          less/
            app.less
            base.less
            font_awesome.less
            index.html
            media_queries.less
            prefixer.less
      readme.md
      tests/
        app.rb
      vendor/
        code_statistics.rb
      views/
        error.erb
        index.erb
        layout.erb
        not_found.erb

Pulp includes the following gems by default:

  * sinatra
  * thin
  * activerecord
  * sinatra-activerecord
  * bcrypt-ruby
  * json
  * mysql
  * sqlite3
  * pony

Your application's config file is `app-config.json` and the database configuration file can be found at `db/config.json`. A rackup config file is also included.

Once the app is generated, you'll need to CD into the folder and run Bundler to install the gems.

    bundle install

After you've configured your database, you can create migrations using the `db:create_migration` rake task. You must pass a `NAME` argument, like so:

    rake db:create_migration NAME=my_sample_migration

Once you're done editing your migration files, rune `rake db:migrate` just like you would in Rails. 

To see a list of all available Rake tasks, run `rake -T`.

If you'd like to simply use the front end boilerplate, it's packaged separately inside of the `frontend.zip` file. It's important that you leave the original `frontend.zip` file in the same directory as the `pulp.sh` file - Pulp extracts the front end boilerplate from this zip to place inside of your application.

###Credits

Pulp includes [Font Awesome](http://fortawesome.github.com/Font-Awesome) for awesome font icons.

Pulp also includes a copy of [jQuery](http://jquery.com)

The `stats` rake task uses a slightly modified version of the Rails code_statistics.rb file.

###License

Pulp is licensed under the [CC BY 3.0](http://creativecommons.org/licenses/by/3.0/) license.


