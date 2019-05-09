Search = {

  /* Get current search data-parameters from episode list element */
  getSearchParameters: function() {

    // Get values from element's data-parameters
    var data = $("#episode-list").data();
    var url  = "/search/" + data.brand + "/" + data.genre + "/" + data.limit + "/" + data.order + "/" + data.id + "/" + data.page

    // Load and insert episode list
    Search.loadEpisodeList(url);

  },

  /* Load episode list and insert into target element */
  loadEpisodeList: function(url) {

    var list = $("#episode-list");

    // Clear search results and show loading animation
    list.empty();
    list.css("background-image", "url('/images/layout/loading-light.gif')");

    /* Insert response into element */
    list.load(url, function() {

      // Hide loading animation
      list.css("background-image", "none");

      /* Initialze paging links */
      $(".page-link").click(function() {

        var search = document.getElementById("episode-list");
        var url    = $(this).data("url");

        // Scroll page to search form
        search.scrollIntoView();

        // Load requested page if target URL is present
        if (typeof(url) != "undefined") {
          Search.loadEpisodeList(url);
        }

        return false;

      });

      // Initialize Play-buttons in episode list
      Player.initPlayButtons();

    });

  },

  /* Initialize episode search when form values are changed */
  initSearchForm: function() {

    var search = $("#episode-search");
    var list   = $("#episode-list");

    // Set search form values as search data-parameters
    list.data("brand", search.find("select#brand").val());
    list.data("genre", search.find("select#genre").val());
    list.data("limit", search.find("select#limit").val());
    list.data("order", search.find("select#order").val());

    // Initialize episode search by using data-parameters
    Search.getSearchParameters();

  }

};

/* Document ready state */
$(document).ready(function() {

  // Load default episode list on page load
  Search.getSearchParameters();

  // Initialize episode search when form values are changed
  $("#episode-search select").change(function() {
    Search.initSearchForm();
  });

});