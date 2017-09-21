# Ruby on Rails Tutorial sample application
Last deploy: [Heroku: Sample App](https://gentle-coast-14233.herokuapp.com/)

This is the sample application for
[*Ruby on Rails Tutorial:
Learn Web Development with Rails*](http://www.railstutorial.org/)
by [Michael Hartl](http://www.michaelhartl.com/).

## License

All source code in the [Ruby on Rails Tutorial](http://railstutorial.org/)
is available jointly under the MIT License and the Beerware License. See
[LICENSE.md](LICENSE.md) for details.

## Getting started

### Cloud 9 Prep
Some extra steps to get setup in a fresh Cloud 9 workspace

Install necessary packages

```
rvm install 2.3.0
gem install rails -v 5.1.2
```

### Heroku

Log in to Heroku

```
$ heroku login
Enter your Heroku credentials:
Email: matt@hoover.ml
Password: ************
Logged in as matt@hoover.ml
```

Add existing Heroku remote to git config

**.git/config**

```
.
.
[remote "heroku"]
        url = https://git.heroku.com/<heroku_name>.git
        fetch = +refs/heads/*:refs/remotes/heroku/*
.
.
```

## Remaining config

To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```

For more information, see the
[*Ruby on Rails Tutorial* book](http://www.railstutorial.org/book).