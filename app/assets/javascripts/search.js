const Search = {
  /* Get current search data-parameters from episode list element */
  getSearchParameters: function () {
    const data = $('#episode-list').data()
    Search.setSearchState(data)
  },

  /* Update episode list data-parameters */
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
    const brand = data ? data.brand : 'any'
    const genre = data ? data.genre : 'any'
    const limit = data ? parseInt(data.limit) : 15
    const order = data ? data.order : 'date-desc'
    const id = data ? data.id : null
    let page = data ? data.page : 1

    // Set search form selected values
    search.find('select#brand').val(brand)
    search.find('select#genre').val(genre)
    search.find('select#limit').val(limit)
    search.find('select#order').val(order)

    if (data) {
      const url = `/search/${brand}/${genre}/${limit}/${order}/${id}/${page}`

      // Update episode list data-parameters and content
      Search.setSearchParameters(brand, genre, limit, order)
      $('#episode-list').data('page', page)
      Search.loadEpisodeList(url)
    } else {
      if (queryString.length !== 0) {
        const urlParameters = new URLSearchParams(queryString)
        page = parseInt(urlParameters.get('page')) || 1
      }

      $('#episode-list').data('page', page)
      Search.initSearchForm(false)
    }
  },

  /* Init page history event and add search parameters to URL */
  setUrlParameters: function () {
    const data = $('#episode-list').data()
    const url = new URL(window.location)

    url.searchParams.set('brand', data.brand)
    url.searchParams.set('genre', data.genre)
    url.searchParams.set('limit', data.limit)
    url.searchParams.set('order', data.order)
    url.searchParams.set('page', data.page)

    history.pushState(null, '', url)
  },

  /* Load episode list and insert into target element */
  loadEpisodeList: function (url) {
    const list = $('#episode-list')
    const loading = $('#loading-indicator')
    const interval = 333

    list.fadeTo(interval, 0)
    loading.fadeTo(0, 1)
    loading.css('z-index', 99)

    list.load(url, function () {
      list.fadeTo(interval, 1)
      loading.fadeTo(0, 0)
      loading.css('z-index', -1)

      Search.initPagingButtons()
      Player.initPlayButtons()
    })
  },

  /* Initialize paging buttons */
  initPagingButtons: function () {
    $('.page-link').click(function () {
      const list = $('#episode-list')
      const url = $(this).data('url')

      list.data('page', $(this).data('page'))
      Search.setUrlParameters()
      document.getElementById('episode-list').scrollIntoView()

      if (typeof url !== 'undefined') {
        Search.loadEpisodeList(url)
      }

      return false
    })

    return false
  },

  /* Initialize episode search when form values are changed */
  initSearchForm: function (setUrlParameters) {
    const search = $('#episode-search')

    Search.setSearchParameters(
      search.find('select#brand').val(),
      search.find('select#genre').val(),
      search.find('select#limit').val(),
      search.find('select#order').val()
    )

    Search.getSearchParameters()

    if (setUrlParameters === true) {
      Search.setUrlParameters()
    }
  }
}

/* Document ready state */
$(document).ready(function () {
  Player.initPlayButtons()
  Search.initPagingButtons()

  // Initialize episode search when form values are changed
  $('#episode-search select').change(function () {
    Search.initSearchForm(true)
  })

  let lastUrlWithoutHash = window.location.origin + window.location.pathname + window.location.search

  // Update episode list when URL changes
  window.addEventListener('popstate', function () {
    const currentUrlWithoutHash = window.location.origin + window.location.pathname + window.location.search

    if (currentUrlWithoutHash === lastUrlWithoutHash) {
      return
    }

    lastUrlWithoutHash = currentUrlWithoutHash

    const urlParams = new URLSearchParams(window.location.search)
    const data = {
      brand: urlParams.get('brand') || 'any',
      genre: urlParams.get('genre') || 'any',
      limit: urlParams.get('limit') || 15,
      order: urlParams.get('order') || 'date-desc',
      page: urlParams.get('page') || 1
    }

    Search.setSearchState(data)
  })
})
