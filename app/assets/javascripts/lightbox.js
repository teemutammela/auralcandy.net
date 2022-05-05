const Lightbox = {

  /* Set cover image to lightbox */
  setImage: function (imageUrl) {
    $('#lightbox-image').css('background-image', "url('" + imageUrl + "'")
  },

  /* Show cover image in lightbox */
  showImage: function () {
    $('body').css('overflow', 'hidden')
    $('#lightbox').fadeIn('slow')
  },

  /* Hide cover image and lightbox */
  hideImage: function () {
    $('body').css('overflow', 'auto')
    $('#lightbox').fadeOut('slow')
  }

}

/* Document ready state */
$(document).ready(function () {
  // Full size cover image instance
  const imageFullUrl = $('#media-image-full-url').data('imageFullUrl')

  // Set cover image to lightbox if URL is present
  if (imageFullUrl) {
    Lightbox.setImage(imageFullUrl)
  }

  // Show cover image in lightbox
  $('#media-image-full-url').click(function () {
    Lightbox.showImage()
    return false
  })

  // Hide cover image and lightbox
  $('#lightbox-close').click(function () {
    Lightbox.hideImage()
    return false
  })
})
