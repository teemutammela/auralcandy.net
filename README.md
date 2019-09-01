# AuralCandy.Net - Premium House Music Podcast

This repository contains the source code of [AuralCandy.Net](https://www.auralcandy.net/). Please note that this application is TAILORED TO OUR NEEDS - it's NOT A GENERIC, TURN-KEY PODCAST PLATFORM. This source code is released for EDUCATIONAL PURPOSES for anyone wishing to learn more about developing Contentful applications using Ruby and Sinatra.

This source code can be used for NON-COMMERICIAL PURPOSES ONLY. Any commercial use of this source code requires EXPLICIT PERMISSION from the author. This application comes with ABSOLUTELY NO WARRANTY. The author assumes no responsibility of data loss or any other unintended side-effect.

## Author

**Teemu Tammela**

* [teemu.tammela@auralcandy.net](mailto:teemu.tammela@auralcandy.net)
* [www.auralcandy.net](https://www.auralcandy.net/)
* [github.com/teemutammela](https://github.com/teemutammela)
* [www.linkedin.com/in/teemutammela](https://www.linkedin.com/in/teemutammela/)
* [t.me/teemutammela](http://t.me/teemutammela)

## About Us

[AuralCandy.Net](https://www.auralcandy.net/) is a House Music podcast hosted by MK-Ultra & Mesmic - a Finnish DJ duo with a quarter century of combined experience under their belt. Over a decade running, AuralCandy.Net podcasts have reached thousands of listeners all over the world. AuralCandy.Net collaborates with over 50 record labels such as [Bonzai Progressive](http://www.bonzaiprogressive.com/), [Piston Recordings](http://www.pistonrecordings.com/), [Tall House Digital](http://www.tallhousedigital.com/) and [Vision Collective Recordings](http://www.visioncollectiverecordings.com/).

## Table of Contents

* [Features](#markdown-features)
* [Requirements](#markdown-header-requirements)
* [Installation](#markdown-header-installation)
* [Deployment](#markdown-header-deployment)
	* [Development (Local)](#markdown-header-development-local)
	* [Production (Heroku)](#markdown-header-production-heroku)
* [Asset Pipeline](#markdown-header-asset-pipeline)
* [Application Structure](#markdown-header-application-structure)
	* [Modules](#markdown-header-modules)
	* [Content Models & Classes](#markdown-header-content-models-classes)
* [Testing](#markdown-header-testing)

## Features

* Architecture
	* Built upon the [Sinatra](http://www.sinatrarb.com/) framework
	* Utilizes [Padrino](http://padrinorb.com/guides/advanced-usage/standalone-usage-in-sinatra/) stand-alone helpers
	* Content management and delivery by [Contentful](https://www.contentful.com/)
	* Ready to be deployed on [Heroku](https://www.heroku.com/)
	* Includes sample data and [Rack::Test](https://github.com/rack-test/rack-test) unit tests

* Mobile-friendly responsive layout
	* Built with [Bootstrap](http://getbootstrap.com/)
	* Vector icons by [Fontawesome](https://fontawesome.com/)

* Episode search
	* Search by brand and genre
	* Pagination and variable items per page
	* Sort by title and date

* Embedded media player
	* Saves player state in [localStorage](https://www.w3schools.com/html/html5_webstorage.asp)
	* Continuous playback between page loads __1)__

* Episode landing pages
	* Episode description
	* Genre tags (as defined in [MusicRecording](http://schema.org/MusicRecording) schema)
	* Track listing
	* Related recording labels
	* Related episodes

* RSS/XML feed
	* Compatible with [Apple Podcasts](https://itunes.apple.com/us/app/podcasts/id525463029), [Google Podcasts](https://play.google.com/store/apps/details?id=com.google.android.apps.podcasts), [Spotify](https://www.spotify.com/download), [iTunes](https://www.apple.com/itunes/), [VLC Media Player](https://www.videolan.org/vlc/) etc.
	* Episode descriptions
	* Episode images (as defined in iTunes Podcast DTD)
	* Genre keywords (as defined in iTunes Podcast DTD)
	* Track listing
	* Related recording labels

* Statistics
  * Download tracking via [Chartable](http://chartable.com) (optional)

* Search Engine Optimization
	* Machine-readable [microdata schemas](https://schema.org/)
	* [Sitemap XML](https://en.wikipedia.org/wiki/Sitemaps)
	* [Web Application Manifest](https://developer.mozilla.org/en-US/docs/Web/Manifest)
	* Support for [Twitter Card](https://developer.twitter.com/en/docs/tweets/optimize-with-cards/overview/summary.html) and [Open Graph](http://ogp.me/) embedding

* Performance Optimization
	* Efficient use of caching, content compression and headers on the application level
	* Low amount of HTTP requests (29) and memory usage (~5MB)
	* JavaScript and SASS asset pipeline via [Grunt](https://gruntjs.com/)
	* Full [Cloudflare](https://www.cloudflare.com/) compatibility

* Certification
	* [Valid HTML5](https://validator.w3.org/nu/?doc=https%3A%2F%2Fwww.auralcandy.net%2F)
	* [Valid CSS3](http://jigsaw.w3.org/css-validator/validator?uri=https%3A%2F%2Fwww.auralcandy.net%2F&profile=css3svg&usermedium=all&warning=no&vextwarning=&lang=en)
	* [Valid RSS 2.0](https://validator.w3.org/feed/check.cgi?url=https%3A%2F%2Fwww.auralcandy.net%2Fpodcast)

__1)__ Unless prevented by browser autoplay policy. See [Media Engagement Index](https://developers.google.com/web/updates/2017/09/autoplay-policy-changes) documentation for further details.

## Requirements

* [Git](http://git-scm.com/)
* [Ruby](https://www.ruby-lang.org/en/)
* [Bundler](http://bundler.io/)
* [npm](http://www.npmjs.com/)
* [Grunt](https://gruntjs.com/)
* [Contentful account](https://www.contentful.com/)
* [Contentful CLI](https://github.com/contentful/contentful-cli)
* [Heroku account](https://www.heroku.com/)
* [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)
* [Chartable account](http://chartable.com) (optional)

## Installation

**1)** Clone or fork the repository and install the required Ruby gems listed in ``Gemfile`` via Bundler.

```shell
$ git clone https://github.com/teemutammela/auralcandy.net.git
$ cd auralcandy.net
$ bundle install
```

**2)** Login to [Contentful CLI](https://github.com/contentful/contentful-cli) and select the target space.

```shell
$ contentful login
$ contentful space use
```

**3)** Import content models to target space.

```shell
$ contentful space import --content-file app/import/content-models.json
```

**4)** Import example content to target space.

```shell
$ contentful space import --content-file app/import/example-content.json
```

**NOTE!** Unit tests (`app/tests.rb`) are designed to match the contents of `example-content.json`. Altering the example content in Contentful is likely to cause the unit tests to fail. It is recommended to set up two spaces (e.g. `Production` and `Testing`) and keep unmodified test content in the latter.

## Deployment

Contentful Delivery API key and Space ID must be set using environment variables. In production environment variables are set via application settings in the [Heroku dashboard](https://dashboard.heroku.com/apps/). Contentful API keys are managed in _Space settings → API keys_.

**NOTE!** [Chartable](https://chartable.com/) ID is optional; It can be set for neither or both environments. If `ENV["CHARTABLE_ID"]` is not set, `@audio_url_chartable` property found in class `Episode` simply returns the original Contentful asset URL. Chartable ID can be found at _Dashboard → Integrations_.

### Development (Local)

```shell
$ export CONTENTFUL_DELIVERY_KEY=xyz123
$ export CONTENTFUL_SPACE_ID=xyz123
$ export CHARTABLE_ID=xyz123
$ source ~/.bashrc
$ rackup -p 9292
```

Application is now running at [http://localhost:9292](http://localhost:9292).

Alternatively, use the [rerun](https://github.com/alexch/rerun/) gem to automatically restart the application upon file save. `rerun` is included in the `Gemfile` and is installed as part of `bundle install`. By default `rerun` is set to monitor changes in the `*.rb` files in the `app/` directory. Settings are found in the `.rerun` configuration file.

```shell
$ rerun rackup
```

Default environment is `development`. Set production environment via the `APP_ENV` variable.

```shell
$ export APP_ENV=production
```

**NOTE!** Global variable `$base_url` (set in `app/modules/module.defaults.rb`) forces HTTPS in production mode. This may break some links while running the application in production mode on a local workstation. You may disable this feature by commenting the following line in `app/modules/module.defaults.rb`.

```ruby
$base_url.sub!("http://", "https://") unless settings.development?
```

### Production (Heroku)

**1)** Create a new Heroku application via the [dashboard](https://dashboard.heroku.com/apps).

**2)** Login to Heroku and associate the repository with the Heroku application.

```shell
$ heroku login
$ heroku git:remote -a <APP_NAME>
```

**3)** Deploy commits to production by pushing to Heroku master repository.

```shell
$ git push heroku master
```

The default URL of the application is `https://appname.herokuapp.com`. More domains can be attached to the application via the _Settings_ tab in the [dashboard](https://dashboard.heroku.com/apps).

**NOTE!** Before deploying your site to public production environment, change the line `Sitemap: https://www.auralcandy.net/sitemap.xml` in `public/robots.txt` to match the domain of your production site.

#### Webhooks

* [Purge Cloudflare cache on Heroku build](https://github.com/jamesmartin/cloudflare-cache-purge-buildpack)
* [Purge Cloudflare cache on Contentful update](https://github.com/teemutammela/contentful-cloudflare-webhook-purge)

## Asset Pipeline

Install the required _npm_ packages listed in `package.json`.

```shell
$ npm install
```

Launch the task runner while working with JavaScripts and stylesheets. Upon file save, `*.js` and `*.scss` files in directories `/assets/JavaScripts/` and `/assets/sass/` will be combined and compressed into target directories `/public/JavaScripts/` and `/public/stylesheets/` as configured in `Gruntfile.js`.

```shell
$ grunt watch
```

## Application Structure

Configuration for _development_ and _production_ environments is set in `app.rb`. See [Sinatra documentation](http://sinatrarb.com/configuration.html) for further details about configuration settings.

|Directory			|Description																																					|
|---------------|-------------------------------------------------------------------------------------|
|`app/assets`		|JavaScript as SASS files.																														|
|`app/classes`	|Classes for wrapping content objects.																								|
|`app/modules`	|Modules for handling routes, shared defaults, content queries and generic helpers.	 	|
|`app/public`		|Static files (images, compiled JavaScript and CSS files etc.).												|
|`app/views`		|ERB view templates and partials.																											|

### Modules

Modules are included and registered in `app.rb`. Modules follow Sinatra's standard [modular extensions](http://sinatrarb.com/extensions.html) pattern.

|Module								|Description																																		|
|---------------------|-------------------------------------------------------------------------------|
|`module.defaults.rb` |Contentful client and shared defaults.																					|
|`module.helpers.rb`	|Generic helpers, mostly for parsing strings for various purposes.							|
|`module.legacy.rb`		|Legacy redirections __1)__.																											|
|`module.queries.rb`	|Query content from Contentful and wrap it to objects (registered as helpers).	|
|`module.routing.rb`	|Route and URL parameter handling.																							|

__1)__ Legacy module handles URL redirections from old AuralCandy.Net versions. You may disable this feature by remove the following lines from `app.rb` and delete and `app/modules/module.legacy.rb` and `app/legacy` directory.

```ruby
require_relative("modules/module.legacy.rb")

register Sinatra::Podcast::Legacy
```

### Content Models & Classes

Classes are included in `app.rb`. Classes are wrappers for corresponding Contentful content models. Classes are used for formatting field values, handling related content by wrapping them with appropriate classes, adding helper methods as object properties and defining the accessible properties of said class.

|Content Model	|Contentful ID	|Class							|Description																				 |
|---------------|---------------|-------------------|----------------------------------------------------|
|Brand					|brand					|`class.brand.rb`		|Podcast brand (used also for site default settings) |
|DJ							|author					|`class.dj.rb`			|Author of a podcast episode												 |
|Episode				|episode				|`class.episode.rb` |Podcast episode																		 |
|Label					|label					|`class.label.rb`		|Recording recording label related to an episode		 |

## Testing

Perform unit tests for all routes defined in `module.routing.rb` using the [Rack::Test](https://github.com/rack-test/rack-test) library.

### Parameters

|Long							|Short	|Description																				 |
|-----------------|-------|----------------------------------------------------|
|`--key`					|`-k`		|Contentful Delivery API key								 	 			 |
|`--space`				|`-s`		|Contentful space ID																 |
|`--environment`	|`-e`		|Sinatra environment (`development` or `production`) |

```shell
$ ruby app/tests.rb -k <API_KEY> -s <SPACE_ID> -e <ENVIRONMENT>
```
