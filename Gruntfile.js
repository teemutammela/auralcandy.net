module.exports = function(grunt) {

  grunt.initConfig({
    uglify: {
      options: {
        mangle: false,
        compress: true
      },
      target: {
        files: {
          "app/public/javascripts/scripts.min.js": [
            "app/assets/javascripts/jquery-3.3.1.js",
            "app/assets/javascripts/popper-1.14.3.js",
            "app/assets/javascripts/bootstrap-4.1.3.js",
            "app/assets/javascripts/search.js",
            "app/assets/javascripts/player.js",
            "app/assets/javascripts/lightbox.js"
          ]
        }
      }
    },
    sass: {
      options: {
        sourcemap: "none",
        style: "compressed",
        noCache: true
      },
      dist: {
        files: {
          "app/public/stylesheets/styles.css": "app/assets/sass/styles.scss"
        }
      }
    },
    watch: {
      js: {
        files: "app/assets/javascripts/**/*.js",
        tasks: "uglify",
        options: {
          spawn: false,
        }
      },
      css: {
        files: "app/assets/sass/**/*.scss",
        tasks: "sass",
        options: {
          spawn: false,
        }
      }
    }
  });

  grunt.loadNpmTasks("grunt-contrib-uglify");
  grunt.loadNpmTasks("grunt-contrib-sass");
  grunt.loadNpmTasks("grunt-contrib-watch");

};