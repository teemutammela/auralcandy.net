module.exports = function (grunt) {
  grunt.initConfig({
    uglify: {
      options: {
        mangle: false,
        compress: true
      },
      target: {
        files: {
          'app/public/javascripts/scripts.min.js': [
            'app/assets/javascripts/vendor/jquery-3.7.1.js',
            'app/assets/javascripts/vendor/popper-1.16.1.js',
            'app/assets/javascripts/vendor/bootstrap-4.6.2.js',
            'app/assets/javascripts/search.js',
            'app/assets/javascripts/player.js',
            'app/assets/javascripts/lightbox.js'
          ]
        }
      }
    },
    sass: {
      options: {
        sourcemap: 'none',
        style: 'compressed',
        noCache: true
      },
      dist: {
        files: {
          'app/public/stylesheets/styles.min.css': 'app/assets/sass/styles.scss'
        }
      }
    },
    watch: {
      js: {
        files: 'app/assets/javascripts/**/*.js',
        tasks: 'uglify',
        options: {
          spawn: false
        }
      },
      css: {
        files: 'app/assets/sass/**/*.scss',
        tasks: 'sass',
        options: {
          spawn: false
        }
      }
    }
  })

  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-sass')
  grunt.loadNpmTasks('grunt-contrib-watch')
}
