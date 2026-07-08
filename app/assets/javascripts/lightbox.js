const Lightbox = {

  /* Set cover image to lightbox */
  setImage: function (imageUrl) {
    AppDom.query('#lightbox-image').style.backgroundImage = `url("${imageUrl}")`
  },

  /* Show cover image in lightbox */
  showImage: function () {
    document.body.style.overflow = 'hidden'
    AppDom.fadeIn(AppDom.query('#lightbox'), 'slow')
  },

  /* Hide cover image and lightbox */
  hideImage: function () {
    document.body.style.overflow = 'auto'
    AppDom.fadeOut(AppDom.query('#lightbox'), 'slow')
  }

}

/* Document ready state */
AppDom.ready(function () {
  // Full size cover image instance
  const imageFullUrl = AppDom.data(AppDom.query('#media-image-full-url')).imageFullUrl

  // Set cover image to lightbox if URL is present
  if (imageFullUrl) {
    Lightbox.setImage(imageFullUrl)
  }

  // Show cover image in lightbox
  AppDom.query('#media-image-full-url').addEventListener('click', function (event) {
    event.preventDefault()
    Lightbox.showImage()
  })

  // Hide cover image and lightbox
  AppDom.query('#lightbox-close').addEventListener('click', function (event) {
    event.preventDefault()
    Lightbox.hideImage()
  })
})
