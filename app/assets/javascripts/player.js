Player = {

  /* Initialize episode play buttons */
  initPlayButtons: function() {

    $(".play-button").click(function() {

      // Get episode properties from data-parameters
      var episode= $(this).data();

      // Add default duration, elapsed time and play state
      episode.duration = "00:00:00";
      episode.elapsed  = 0;
      episode.state    = "play";

      // Set episode properties to media player and save to local storage
      Player.setPlayerProperties(episode);
      Player.setLocalStorage(episode);

      // Set full size cover image to lightbox
      Lightbox.setImage(episode.imageFullUrl);

      // Load audio file to media player
      audio.load();

      // Fade in media player and start playback
      player.fadeIn("slow", function() {
        audio.play();
      });

      return false;

    });

  },

  /* Set episode properties to media player */
  setPlayerProperties: function(episode) {

    // Set episode title, cover image and source URLs
    $("#media-dj").html(episode.dj);
    $("#media-title").html(episode.title);
    $("#media-duration").html(episode.duration);
    $("#media-image-url").attr("data-image-url", episode.imageUrl);
    $("#media-image-full-url").attr("data-image-full-url", episode.imageFullUrl);
    $("#media-audio-url").attr("src", episode.audioUrl);
    $("#media-episode-url").attr("href", episode.episodeUrl);
    $("#media-download").attr("href", episode.audioUrl);

    // Social media sharing URLs
    episode.share_urls = {
      "twitter"    : "https://twitter.com/intent/tweet?text=" + encodeURI(episode.dj + " - " + episode.title) + "&url=" + encodeURI(episode.episodeUrl),
      "facebook"   : "https://www.facebook.com/sharer/sharer.php?u=" + encodeURI(episode.episodeUrl),
      "pinterest"  : "https://pinterest.com/pin/create/button/?url=" + encodeURI(episode.episodeUrl),
      "email"      : "mailto:?subject=" + encodeURI(episode.dj + " - " + episode.title) + "&body=" + encodeURI(episode.episodeUrl)
    }

    // Set values to share menu
    for (var key in episode.share_urls) {
      $("#media-" + key + "-url").attr("href", episode.share_urls[key]);
    }

  },

  /* Restore media player state */
  restorePlayerState: function() {

    if (localStorage.episode) {

      // Get episode data from local storage
      episode = Player.getLocalStorage();

      // Set player properties from local storage
      Player.setPlayerProperties(episode);

      // Load source file to media player's audio instance
      audio.load();

      // Set appropriate play state icon
      Player.togglePlayIcon();

      // Display media player instantly
      player.show();

    }

  },

  /* Attempt to resume audio playback if media player is in play state */
  resumePlayback: function() {

    if (Player.getLocalStorage("state") == "play") {
      audio.play().catch(function() {
        console.log("Browser prevented resuming audio playback.");
      });
    }

  },

  /* Play or pause media player */
  togglePlayState: function() {

    audio.paused ? audio.play() : audio.pause();
    audio.paused ? Player.updateLocalStorage("state", "pause") : Player.updateLocalStorage("state", "play");

  },

  /* Set play or pause title and icon */
  togglePlayIcon: function() {

    var link = $("#media-playpause");
    var icon = link.find("span");

    audio.paused ? link.attr("title", "Play") : link.attr("title", "Pause");
    audio.paused ? icon.attr("class", "fas fa-play") : icon.attr("class", "fas fa-pause");

  },

  /* Set media player cover image thumbnail */
  setThumbnail: function() {
    $("#media-image-url").attr("src", $("#media-image-url").attr("data-image-url"));
  },

  /* Update media player duration and elapsed time index */
  updateDuration: function() {

    // NaN = audio file not loaded yet
    if (isNaN(audio.duration) == false) {

      // Convert seconds to HH:MM:SS
      var total    = audio.duration;
      var current  = audio.currentTime;
      var duration = new Date((parseInt(total) - parseInt(current)) * 1000).toISOString().substr(11, 8);

      // Update duration and elapsed time only when playback is active
      if (!audio.paused) {

        // Update duration and elapsed time in local storage
        Player.updateLocalStorage("duration", duration);
        Player.updateLocalStorage("elapsed", current);

        // Update duration display in media player
        $("#media-duration").html(duration);

      }

    }

  },

  /* Get episode properties from local storage */
  getLocalStorage: function(key) {

    var episode = JSON.parse(localStorage.episode);
    return typeof(key) == "undefined" ? episode : episode[key];

  },

  /* Set episode properties to local storage */
  setLocalStorage: function(episode) {

    localStorage.removeItem("episode")

    // Strip Chartable redirection from audio URL to prevent unnecessary redirections when restoring state
    if (episode.audioUrl.includes("chtbl.com")) {
      audio_url = "https:/" + episode.audioUrl.replace("https://chtbl.com/track/", "").replace(/^[0-9A-Z]{5}?/, "");
      episode.audioUrl = audio_url;
    }

    localStorage.setItem("episode", JSON.stringify(episode));

  },

  /* Update episode properties in local storage */
  updateLocalStorage: function(key, value) {

    var episode = Player.getLocalStorage();
    episode[key] = value;
    Player.setLocalStorage(episode);

  },

  /* Define actions for media player events */
  bindPlayerEvents: function() {

    /* Audio loading started - display loading animation */
    audio.onloadstart = function() {
      $("#media-image-url").attr("src", "/images/layout/loading-dark.gif");
    }

    /* Restore current time index from local storage */
    audio.onprogress = function() {

      if (localStorage.episode && audio.currentTime == 0) {

        // Setting current time only once prevents jumps in audio playback
        audio.currentTime = Player.getLocalStorage("elapsed");

        // Attempt to resume audio playback
        Player.resumePlayback();

      }

    }

    /* Playback can start - replace loading animation with cover image */
    audio.oncanplay = function() {
      Player.setThumbnail();
    }

    /* Playback started */
    audio.onplay = function() {

      // Set cover image thumbnail
      Player.setThumbnail();

      // Set icon to pause state
      Player.togglePlayIcon();

      // Set duration interval (runs on the background until playback ends)
      if (typeof(duration) == "undefined") {
        duration = setInterval(function() {
          Player.updateDuration();
        }, 1000);
      }

    };

    /* Playback paused - display play icon */
    audio.onpause = function() {
      Player.togglePlayIcon();
    };

    /* Playback ended */
    audio.onended = function() {

      // Clear episode properties from local storage
      localStorage.removeItem("episode");

      // Hide media player
      player.fadeOut("slow");

      // Clear duration display interval
      clearInterval(duration);

    };

    /* Error - display notification */
    audio.onerror = function() {
      alert("Unable to load audio file.");
    };

  }

};

/* Document ready state */
$(document).ready(function() {

  // Media player UI
  player = $("#media-player");

  // Media player audio tag
  audio = document.getElementById("media-audio");

  // Bind media player events and restore media player state
  Player.bindPlayerEvents();
  Player.restorePlayerState();

  /* Media player play/pause button */
  $("#media-playpause").click(function() {
    Player.togglePlayState();
    return false;
  });

  /* Media player close button */
  $("#media-close").click(function() {

    // Clear episode properties from local storage
    localStorage.removeItem("episode");

    // Fade out media player
    player.fadeOut("slow");

    // Stop audio playback
    audio.pause();

    return false;

  });

});