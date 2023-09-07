const Player = {

  player: $('#media-player'),
  audio: document.getElementById('media-audio'),
  duration: null,

  /* Initialize episode play buttons */
  initPlayButtons: function () {
    $('.play-button').click(function () {
      // Get episode properties from data-parameters
      const episode = $(this).data()

      // Add default duration, elapsed time and play state
      episode.duration = '00:00:00'
      episode.elapsed = 0
      episode.state = 'play'

      // Set episode properties to media player and save to localStorage
      Player.setPlayerProperties(episode)
      Player.setLocalStorage(episode)

      // Set full size cover image to lightbox
      Lightbox.setImage(episode.imageFullUrl)

      // Load audio file to media player
      Player.audio.load()

      // Fade in media player and start playback
      Player.player.fadeIn('slow', function () {
        Player.audio.play()
      })

      return false
    })
  },

  /* Set episode properties to media player */
  setPlayerProperties: function (episode) {
    // Set episode title, cover image and source URLs
    $('#media-dj').html(episode.dj)
    $('#media-title').html(episode.title)
    $('#media-duration').html(episode.duration)
    $('#media-image-url').attr('data-image-url', episode.imageUrl)
    $('#media-image-full-url').attr('data-image-full-url', episode.imageFullUrl)
    $('#media-audio-url').attr('src', episode.audioUrl)
    $('#media-episode-url').attr('href', episode.episodeUrl)
    $('#media-download').attr('href', episode.audioUrl)
  },

  /* Restore media player state */
  restorePlayerState: function () {
    if (localStorage.episode) {
      // Get episode data from localStorage
      const episode = Player.getLocalStorage()

      // Set player properties from localStorage
      Player.setPlayerProperties(episode)

      // Load source file to media player's audio instance
      Player.audio.load()

      // Set appropriate play state icon
      Player.togglePlayIcon()

      // Display media player instantly
      Player.player.show()
    }
  },

  /* Attempt to resume audio playback if media player is in play state */
  resumePlayback: function () {
    if (Player.getLocalStorage('state') === 'play') {
      Player.audio.play().catch(function () {
        console.log('Browser prevented resuming audio playback.')
      })
    }
  },

  /* Play or pause media player */
  togglePlayState: function () {
    Player.audio.paused ? Player.audio.play() : Player.audio.pause()
    Player.audio.paused ? Player.updateLocalStorage('state', 'pause') : Player.updateLocalStorage('state', 'play')
  },

  /* Set play or pause title and icon */
  togglePlayIcon: function () {
    const link = $('#media-playpause')
    const icon = link.find('span')

    Player.audio.paused ? link.attr('title', 'Play') : link.attr('title', 'Pause')
    Player.audio.paused ? icon.attr('class', 'fas fa-play') : icon.attr('class', 'fas fa-pause')
  },

  /* Set media player cover image thumbnail */
  setThumbnail: function () {
    $('#media-image-url').attr('src', $('#media-image-url').attr('data-image-url'))
  },

  /* Update media player duration and elapsed time index */
  updateDuration: function () {
    // NaN = audio file not loaded yet
    if (isNaN(Player.audio.duration) === false) {
      // Convert seconds to HH:MM:SS
      const total = Player.audio.duration
      const current = Player.audio.currentTime
      const duration = new Date((parseInt(total) - parseInt(current)) * 1000).toISOString().substr(11, 8)

      // Update duration and elapsed time only when playback is active
      if (!Player.audio.paused) {
        // Update duration and elapsed time in localStorage
        Player.updateLocalStorage('duration', duration)
        Player.updateLocalStorage('elapsed', current)

        // Update duration display in media player
        $('#media-duration').html(duration)
      }
    }
  },

  /* Get episode properties from localStorage */
  getLocalStorage: function (key) {
    const episode = JSON.parse(localStorage.episode)
    return typeof (key) === 'undefined' ? episode : episode[key]
  },

  /* Set episode properties to localStorage */
  setLocalStorage: function (episode) {
    localStorage.removeItem('episode')

    // Strip Chartable redirection from audio URL to prevent unnecessary redirections when restoring state
    if (episode.audioUrl.includes('chtbl.com')) {
      const audioUrl = 'https:/' + episode.audioUrl.replace('https://chtbl.com/track/', '').replace(/^[0-9A-Z]{5}?/, '')
      episode.audioUrl = audioUrl
    }

    localStorage.setItem('episode', JSON.stringify(episode))
  },

  /* Update episode properties in localStorage */
  updateLocalStorage: function (key, value) {
    const episode = Player.getLocalStorage()
    episode[key] = value
    Player.setLocalStorage(episode)
  },

  /* Define actions for media player events */
  bindPlayerEvents: function () {
    /* Audio loading started - display loading animation */
    Player.audio.onloadstart = function () {
      $('#media-image-url').attr('src', '/images/layout/loading-dark.gif')
    }

    /* Restore current time index from localStorage */
    Player.audio.onprogress = function () {
      if (localStorage.episode && Player.audio.currentTime === 0) {
        // Setting current time only once prevents jumps in audio playback
        Player.audio.currentTime = Player.getLocalStorage('elapsed')

        // Attempt to resume audio playback
        Player.resumePlayback()
      }
    }

    /* Playback can start - replace loading animation with cover image */
    Player.audio.oncanplay = function () {
      Player.setThumbnail()
    }

    /* Playback started */
    Player.audio.onplay = function () {
      // Set cover image thumbnail
      Player.setThumbnail()

      // Set icon to pause state
      Player.togglePlayIcon()

      // Set duration interval (runs on the background until playback ends)
      if (typeof (duration) === 'undefined') {
        Player.duration = setInterval(function () {
          Player.updateDuration()
        }, 1000)
      }
    }

    /* Playback paused - display play icon */
    Player.audio.onpause = function () {
      Player.togglePlayIcon()
    }

    /* Playback ended */
    Player.audio.onended = function () {
      // Clear episode properties from localStorage
      localStorage.removeItem('episode')

      // Hide media player
      Player.player.fadeOut('slow')

      // Clear duration display interval
      clearInterval(Player.duration)
    }

    /* Error - display notification */
    Player.audio.onerror = function () {
      alert('Unable to load audio file.')
    }
  }

}

/* Document ready state */
$(document).ready(function () {
  // Bind media player events and restore media player state
  Player.bindPlayerEvents()
  Player.restorePlayerState()

  /* Media player play/pause button */
  $('#media-playpause').click(function () {
    Player.togglePlayState()
    return false
  })

  /* Media player close button */
  $('#media-close').click(function () {
    // Clear episode properties from localStorage
    localStorage.removeItem('episode')

    // Fade out media player
    Player.player.fadeOut('slow')

    // Stop audio playback
    Player.audio.pause()

    return false
  })
})
