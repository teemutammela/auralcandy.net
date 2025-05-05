# AuralCandy.Net - Premium House Music Podcast

This repository contains the source code of [AuralCandy.Net](https://www.auralcandy.net/). Please note that this application is __tailored to our needs__ - it's __not a generic, turn-key podcast platform__. This source code is released for __educational purposes__ for anyone who wishes to learn more about developing [Contentful](https://www.contentful.com/) applications using [Ruby](https://www.ruby-lang.org/en/) and [Sinatra](http://sinatrarb.com/).

This source code is distributed under [Unlicense](https://unlicense.org/) and can be used for __non-commericial purposes only__. Any commercial use of this source code requires __explicit permission__ from the author. This application comes with __absolutely no warranty__. The author assumes no responsibility of data loss or any other unintended side-effects.

## Author

__Teemu Tammela__

* [teemu.tammela@auralcandy.net](mailto:teemu.tammela@auralcandy.net)
* [www.auralcandy.net](https://www.auralcandy.net/)
* [github.com/teemutammela](https://github.com/teemutammela)
* [www.linkedin.com/in/teemutammela](https://www.linkedin.com/in/teemutammela/)
* [t.me/teemutammela](http://t.me/teemutammela)

## About Us

[AuralCandy.Net](https://www.auralcandy.net/) is a House Music podcast hosted by the Finnish DJ duo __MK-Ultra & Mesmic__, with more than three decades of combined experience under their belt. Ever since its establishment in 2008, AuralCandy.Net podcasts have reached tens of thousands of listeners from over 150 countries. AuralCandy.Net collaborates with several prominent record labels, such as [Piston Recordings](http://www.pistonrecordings.com/) and [Bosh Recordings](https://www.facebook.com/Boshrecords/).

## Table of Contents

* [Features](#features)
* [Requirements](#requirements)
* [Installation](#installation)
* [Deployment](#deployment)
	* [Development (Local)](#development-local)
	* [Production (Heroku)](#production-heroku)
* [Asset Pipeline](#asset-pipeline)
* [Application Structure](#application-structure)
	* [Modules](#modules)
	* [Content Models & Classes](#content-models-classes)
* [Statistic](#statistics)

## Features

* __Technology Stack__
	* Built upon the [Sinatra](http://www.sinatrarb.com/) framework
	* Utilizes [Padrino](http://padrinorb.com/guides/advanced-usage/standalone-usage-in-sinatra/) stand-alone helpers
	* Content management and delivery by [Contentful](https://www.contentful.com/)
	* Ready to be deployed on [Heroku](https://www.heroku.com/) (tested with `heroku-24` stack)

* __Mobile Friendly Responsive Layout__
	* Built with [Bootstrap 4](http://getbootstrap.com/)
	* Vector icons by [Fontawesome 5](https://fontawesome.com/)
	* [WebP](https://developers.google.com/speed/webp/) image support on [Chromium](https://www.chromium.org/) based browsers (JPEG fallback for Firefox, Safari etc.)

* __Episode Search__
	* Search by brand and genre
	* Pagination and variable items per page
	* Sort by date, title or popularity

* __Embedded Media Player__
	* Saves player state in [localStorage](https://www.w3schools.com/html/html5_webstorage.asp)
	* Continuous playback between page loads __1)__

* __Episode Landing Pages__
	* Episode description
	* Genre tags (as defined in [MusicRecording](http://schema.org/MusicRecording) schema)
	* Track listing
	* Related recording labels
	* Related episodes

* __RSS/XML Feed__
	* Compatible with [Apple Podcasts](https://itunes.apple.com/us/app/podcasts/id525463029), [Amazon Music](https://play.google.com/store/apps/details?id=com.amazon.mp3&pli=1), [Castbox](https://castbox.fm/download), [VLC Media Player](https://www.videolan.org/vlc/) etc.
	* Episode descriptions
	* Episode images (as defined in iTunes Podcast DTD)
	* Genre keywords (as defined in iTunes Podcast DTD)
	* Track listing
	* Related recording labels

* __Search Engine Optimization__
	* Machine-readable [microdata schemas](https://schema.org/)
	* [Sitemap XML](https://en.wikipedia.org/wiki/Sitemaps)
	* [Web Application Manifest](https://developer.mozilla.org/en-US/docs/Web/Manifest)
	* Support for [Twitter Card](https://developer.twitter.com/en/docs/tweets/optimize-with-cards/overview/summary.html) and [Open Graph](http://ogp.me/) embedding

* __Performance Optimization__
	* Efficient use of caching, content compression and headers on the application level
	* Low amount of HTTP requests and memory footprint
	* JavaScript and SASS asset pipeline via [Grunt](https://gruntjs.com/)
	* Full [Cloudflare](https://www.cloudflare.com/) compatibility

* __Certification__
	* [Valid HTML5](https://validator.w3.org/nu/?doc=https%3A%2F%2Fwww.auralcandy.net%2F)
	* [Valid CSS3](http://jigsaw.w3.org/css-validator/validator?uri=https%3A%2F%2Fwww.auralcandy.net%2F&profile=css3svg&usermedium=all&warning=no&vextwarning=&lang=en)
	* [Valid RSS 2.0](https://validator.w3.org/feed/check.cgi?url=https%3A%2F%2Fwww.auralcandy.net%2Fpodcast)

__1)__ Unless prevented by browser autoplay policy. See [Media Engagement Index](https://developers.google.com/web/updates/2017/09/autoplay-policy-changes) documentation for further details. Some browsers like [Brave](https://brave.com/) will require explicit permission from user to allow autoplay.

## Requirements

* [Git](http://git-scm.com/)
* [Ruby](https://www.ruby-lang.org/en/)
* [Bundler](http://bundler.io/)
* [npm](http://www.npmjs.com/)
* [Grunt](https://gruntjs.com/)
* [Contentful account](https://www.contentful.com/) & [Contentful CLI](https://github.com/contentful/contentful-cli)
* [Heroku account](https://www.heroku.com/) & [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)

## Installation

__1)__ Clone or fork the repository and install the required Ruby gems listed in `Gemfile` via Bundler.

```shell
$ git clone https://github.com/teemutammela/auralcandy.net.git
$ cd auralcandy.net
$ bundle install
```

__2)__ Login to [Contentful CLI](https://github.com/contentful/contentful-cli) and select the target space.

```shell
$ contentful login
$ contentful space use
```

__3)__ Import content models to target space.

```shell
$ contentful space import --content-file import/content-models.json
```

__4)__ Import example content to target space.

```shell
$ contentful space import --content-file import/example-content.json
```

## Deployment

Contentful API keys, space ID and environment must be set as environment variables. Create a new `.env` file by copying the example file.

```shell
$ cp .env.example .env
$ nano .env
```

On Heroku environment variables, also known as _Config Vars_, can be set either via the [Dashboard](https://dashboard.heroku.com/apps/) or via [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli).

```shell
$ heroku config:set VARIABLE_NAME=variable_value
```

| Variable Name               | Description                                                   |
|-----------------------------|---------------------------------------------------------------|
| `APPLE_PODCAST_ID`          | Apple Podcasts ID (optional). __1)__                          |
| `CONTENTFUL_SPACE_ID`       | Contentful Space ID (source of content).                      |
| `CONTENTFUL_DELIVERY_KEY`   | Contentful Delivery API key.                                  |
| `CONTENTFUL_MANAGEMENT_KEY` | Contentful Management API key.                                |
| `CONTENTFUL_ENVIRONMENT`    | Contentful environment name (e.g. `master`).                  |
| `OP3_SHOW_UUID`             | Open Podcast Prefix Project show UUID. __2)__                 |
| `OP3_API_TOKEN`             | Open Podcast Prefix Project API token. __2)__                 |

__1)__ If `ENV["APPLE_PODCAST_ID"]` is set, a `apple-itunes-app` meta tag will be inserted into the `<head>` section of the page. Read Apple's [Smart App Banners](https://developer.apple.com/documentation/webkit/promoting_apps_with_smart_app_banners) documentation for further information.

__2)__ Required by the Rake task for updating episode download count via the [OP3](https://op3.dev/) REST API. See section [Statistic](#statistics) for further details.

### Development (Local)

__1)__ Start the application via the `heroku local` command. Application is now running at [http://localhost:9292](http://localhost:9292).

```shell
$ heroku local -p 9292
```

__2)__ Default environment is `development`. Set production environment via the `APP_ENV` variable.

```shell
$ export APP_ENV=production
```

__NOTE!__ Global variable `$base_url` (set in `app/modules/podcast/defaults.rb`) forces HTTPS in production mode. This may break some links while running the application in production mode on a local workstation. You may disable this feature by commenting the following line in `app/modules/podcast/defaults.rb`.

```ruby
$base_url = $base_url.sub("http://", "https://") unless settings.development?
```

### Production (Heroku)

__1)__ Create a new Heroku application via the [dashboard](https://dashboard.heroku.com/apps).

__2)__ Login to Heroku and associate the repository with the Heroku application.

```shell
$ heroku login
$ heroku git:remote -a <APP_NAME>
```

__3)__ Deploy commits to production by pushing to Heroku master repository.

```shell
$ git push heroku master
```

The default URL of the application is `https://appname.herokuapp.com`. More domains can be attached to the application via the _Settings_ tab in the [dashboard](https://dashboard.heroku.com/apps).

__NOTE!__ Before deploying your site to public production environment, change the line `Sitemap: https://www.auralcandy.net/sitemap.xml` in `public/robots.txt` to match the domain of your production site.

#### Webhooks

* [Purge Cloudflare cache on Heroku build](https://github.com/jamesmartin/cloudflare-cache-purge-buildpack)
* [Purge Cloudflare cache on Contentful update](https://github.com/teemutammela/contentful-cloudflare-webhook-purge)

## Asset Pipeline

__1)__ Install the required _npm_ packages listed in `package.json`.

```shell
$ npm install
$ npm install -g grunt-cli
```

__2)__ Launch the task runner while working with JavaScripts and stylesheets. Upon file save, `*.js` and `*.scss` files in directories `/assets/javascripts/` and `/assets/sass/` will be combined and compressed into target directories `/public/javascripts/` and `/public/stylesheets/` as configured in `Gruntfile.js`.

```shell
$ grunt watch
```

## Application Structure

Configuration for `development` and `production` environments is set in `app/app.rb`. See [Sinatra documentation](http://sinatrarb.com/configuration.html) for further details about configuration settings.

| Directory			| Description																																						|
|---------------|---------------------------------------------------------------------------------------|
| `app/assets`	| JavaScripts and SASS stylesheets.																											|
| `app/classes`	| Classes for wrapping content objects.																									|
| `app/modules`	| Contentful clients and application modules.	 	              |
| `app/public`	| Static files (images, compiled JavaScripts and CSS stylesheets etc.).									|
| `app/views`		| ERB view templates and partials.																											|

### Modules

Modules are included and registered in `app/app.rb`. Modules follow Sinatra's standard [modular extensions](http://sinatrarb.com/extensions.html) pattern.

| Directory									| Module					 | Description																																		|
|---------------------------|------------------|--------------------------------------------------------------------------------|
| `app/modules/contentful`	| `delivery.rb`    | Contentful Delivery API client.																								|
| `app/modules/contentful`	| `management.rb`  | Contentful Management API client.																							|
| `app/modules/podcast`			| `defaults.rb`    | Shared defaults (brands, genres, search form parameters and footer).					  |
| `app/modules/podcast`			| `helpers.rb`     | Generic helpers, mostly for parsing strings for various purposes.							|
| `app/modules/podcast`			| `queries.rb`     | Query content from Contentful and wrap it to objects (registered as helpers).	|
| `app/modules/podcast`			| `routes.rb`      | Route and URL parameter handling.																							|

### Content Models & Classes

Classes are included in `app/app.rb`. Classes are wrappers for corresponding Contentful content models. Classes are used for formatting field values, handling related content by wrapping them with appropriate classes, adding helper methods as object properties and defining the accessible properties of said class.

| Content Model				| Contentful ID				| Class											| Description                                           |
|---------------------|---------------------|---------------------------|-------------------------------------------------------|
| `Brand`							| `brand`							| `brand.rb`								| Podcast brand __1)__.																	|
| `DJ`								| `author`						| `dj.rb`										| Author DJ of a podcast episode.											  |
| `Episode`						| `episode`						| `episode.rb`							| Podcast episode.																		 	|
| `Label`							| `label`							| `label.rb`								| Recording label related to an episode.		           	|
| `Navigation Anchor`	| `navigationAnchor`	| `navigation_anchor.rb`		| Navigation menu in-page anchor.												|
| `Navigation Link`		| `navigationLink`		| `navigation_link.rb`			| Navigation menu internal or external URL.							|

__1)__ `Brand` content model is also used to manage site's default settings and navigation menu links and anchors. Each `Brand` instance can have its unique navigation menu.

#### Audio File Hosting

Contentful's free [Community](https://www.contentful.com/pricing/) tier service package enforces a maximum asset size of 50MB, which is insufficient for podcast usage. Therefor the `Episode` content type is designed with external audio file hosting such as [Amazon S3](https://aws.amazon.com/s3/) in mind. Please note, that Dropbox and Google Drive are _not_ suitable for audio file hosting, as they introduce too many redirects and latency issues.

However, if you have Team or Enterprise service package and wish to host audio files in Contentful and use the asset reference field type, simply apply the following modifications.

**1)** Add a file attachment field called `Audio` to the `Episode` content type.

**2)** Modify the `@audio_url` and `@file_size` property definitions in `app/classes/episode.rb` as follows.

```ruby
@audio_url = entry.fields[:audio].url
@file_size = entry.fields[:audio].file.details['size']
```

**3)** Remove fields `File URL` and `File Size` from the `Episode` content type.

## Statistics

Query episode downloads from [OP3](https://op3.dev/) and update the `downloads` properties in Contentful episode entries. Define start date as task parameter.

```shell
$ rake statistics:update_episode_downloads[YYYY-MM-DD]
```