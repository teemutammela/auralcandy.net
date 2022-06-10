const Search = {

  /* Get current search data-parameters from episode list element */
  getSearchParameters: function () {
    const data = $('#episode-list').data()
    Search.setSearchState(data)
  },

  /* Update episode list data-parameters */
  // NOTE! Page value is updated by paging button events
  setSearchParameters: function (brand, genre, limit, order) {
    const list = $('#episode-list')

    list.data('brand', brand)
    list.data('genre', genre)
    list.data('limit', limit)
    list.data('order', order)
  },

  /* Update episode list using search parameters (data from history event) */
  setSearchState: function (data) {
    const search = $('#episode-search')
    const queryString = window.location.search
    const brand = (data !== null ? data.brand : 'any')
    const genre = (data !== null ? data.genre : 'any')
    const limit = (data !== null ? parseInt(data.limit) : 12)
    const order = (data !== null ? data.order : 'date-desc')
    const id = (data !== null ? data.id : null)
    let page = (data !== null ? data.page : 1)

    // Set search form selected values
    search.find('select#brand').val(brand)
    search.find('select#genre').val(genre)
    search.find('select#limit').val(limit)
    search.find('select#order').val(order)

    // Handle history event's data content
    if (data !== null) {
      const url = '/search/' + brand + '/' + genre + '/' + limit + '/' + order + '/' + id + '/' + page

      // Update episode list data-parameters and content
      Search.setSearchParameters(data.brand, data.genre, data.limit, data.order)
      Search.loadEpisodeList(url)
    } else {
      // Get page value from URL-parameter if present
      if (queryString.length !== 0) {
        const urlParameters = new URLSearchParams(queryString)
        page = parseInt(urlParameters.get('page'))
      }

      // Update episode list page data-parameter
      $('#episode-list').data('page', page)

      // Initialize episode search with default values
      Search.initSearchForm(false)
    }
  },

  /* Init page history event and add search parameters to URL */
  setUrlParameters: function () {
    // Get values from episode list's data-parameters
    const data = $('#episode-list').data()
    const url = new URL(window.location)

    // Set URL-parameters
    url.searchParams.set('brand', data.brand)
    url.searchParams.set('genre', data.genre)
    url.searchParams.set('limit', data.limit)
    url.searchParams.set('order', data.order)
    url.searchParams.set('page', data.page)

    // Set history event
    history.pushState(data, document.title, url)
  },

  /* Load episode list and insert into target element */
  loadEpisodeList: function (url) {
    const list = $('#episode-list')
    const loading = $('#loading-indicator')
    const interval = 333

    // Fade out episode list
    list.fadeTo(interval, 0)
    loading.fadeTo(0, 1)
    loading.css('z-index', 99)

    /* Insert response into element */
    list.load(url, function () {
      // Fade in episode list
      list.fadeTo(interval, 1)
      loading.fadeTo(0, 0)
      loading.css('z-index', -1)

      // Initialize paging buttons
      Search.initPagingButtons()

      // Initialize Play-buttons in episode list
      Player.initPlayButtons()
    })
  },

  /* Initialize paging buttons */
  initPagingButtons: function () {
    $('.page-link').click(function () {
      const list = $('#episode-list')
      const url = $(this).data('url')

      // Update episode list page data-parameter
      list.data('page', $(this).data('page'))

      // Set search parameters to URL
      Search.setUrlParameters()

      // Scroll page to beginning of episode list
      document.getElementById('episode-list').scrollIntoView()

      // Load requested page if target URL is present
      if (typeof (url) !== 'undefined') {
        Search.loadEpisodeList(url)
      }

      return false
    })

    return false
  },

  /* Initialize episode search when form values are changed */
  initSearchForm: function (setUrlParameters) {
    const search = $('#episode-search')

    // Update episode list data-parameters
    Search.setSearchParameters(
      search.find('select#brand').val(),
      search.find('select#genre').val(),
      search.find('select#limit').val(),
      search.find('select#order').val()
    )

    // Initialize episode search by using data-parameters
    Search.getSearchParameters()

    // Set search parameters to URL
    if (setUrlParameters === true) {
      Search.setUrlParameters()
    }
  }

}

/* Document ready state */
$(document).ready(function () {
  // Initialize play and paging buttons
  Player.initPlayButtons()
  Search.initPagingButtons()

  // Initialize episode search when form values are changed
  $('#episode-search select').change(function () {
    Search.initSearchForm(true)
  })

  // Update search parameters on page change event
  window.addEventListener('popstate', function (event) {
    Search.setSearchState(event.state)
  })
})
