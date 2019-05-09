Lightbox = {

  /* Set cover image to lightbox */
  setImage: function(image_url) {
    $("#lightbox-image").css("background-image", "url('" + image_url + "'");
  },

  /* Show cover image in lightbox */
  showImage: function() {
    $("body").css("overflow", "hidden");
    $("#lightbox").fadeIn("slow");
  },

  /* Hide cover image and lightbox */
  hideImage: function() {
    $("body").css("overflow", "auto");
    $("#lightbox").fadeOut("slow");
  }

};

/* Document ready state */
$(document).ready(function() {

  // Full size cover image instance
  var image_full_url = $("#media-image-full-url").data("imageFullUrl");

  // Set cover image to lightbox if URL is present
  if (image_full_url) {
    Lightbox.setImage(image_full_url);
  }

  // Show cover image in lightbox
  $("#media-image-full-url").click(function() {
    Lightbox.showImage();
    return false;
  });

  // Hide cover image and lightbox
  $("#lightbox-close").click(function() {
    Lightbox.hideImage();
    return false;
  });

});