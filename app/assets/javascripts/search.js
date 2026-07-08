const AppDom = {
  ready: function (callback) {
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', callback)
      return
    }

    window.setTimeout(callback, 0)
  },

  query: function (selector, root) {
    return (root || document).querySelector(selector)
  },

  queryAll: function (selector, root) {
    return Array.from((root || document).querySelectorAll(selector))
  },

  data: function (element) {
    return Object.keys(element.dataset).reduce(function (data, key) {
      data[key] = AppDom.parseDataValue(element.dataset[key])
      return data
    }, {})
  },

  setData: function (element, key, value) {
    element.dataset[key] = value
  },

  parseDataValue: function (value) {
    if (value === 'true') {
      return true
    }

    if (value === 'false') {
      return false
    }

    if (value === 'null') {
      return null
    }

    if (value !== '' && String(Number(value)) === value) {
      return Number(value)
    }

    return value
  },

  parseDuration: function (speed) {
    if (speed === 'slow') {
      return 600
    }

    if (speed === 'fast') {
      return 200
    }

    return Number(speed) || 0
  },

  fadeTo: function (element, speed, opacity, callback) {
    const duration = AppDom.parseDuration(speed)
    const transition = element.style.transition

    if (duration === 0) {
      element.style.opacity = opacity

      if (callback) {
        callback()
      }

      return
    }

    element.style.transition = `opacity ${duration}ms`
    window.requestAnimationFrame(function () {
      element.style.opacity = opacity
    })

    window.setTimeout(function () {
      element.style.transition = transition

      if (callback) {
        callback()
      }
    }, duration)
  },

  fadeIn: function (element, speed, display, callback) {
    element.style.opacity = 0
    element.style.display = display || 'block'
    AppDom.fadeTo(element, speed, 1, callback)
  },

  fadeOut: function (element, speed, callback) {
    AppDom.fadeTo(element, speed, 0, function () {
      element.style.display = 'none'

      if (callback) {
        callback()
      }
    })
  }
}

const Search = {
  /* Get current search data-parameters from episode list element */
  getSearchParameters: function () {
    const data = AppDom.data(AppDom.query('#episode-list'))
    Search.setSearchState(data)
  },

  /* Update episode list data-parameters */
  setSearchParameters: function (brand, genre, limit, order) {
    const list = AppDom.query('#episode-list')
    AppDom.setData(list, 'brand', brand)
    AppDom.setData(list, 'genre', genre)
    AppDom.setData(list, 'limit', limit)
    AppDom.setData(list, 'order', order)
  },

  /* Update episode list using search parameters (data from history event) */
  setSearchState: function (data) {
    const search = AppDom.query('#episode-search')
    const queryString = window.location.search
    const brand = data ? data.brand : 'any'
    const genre = data ? data.genre : 'any'
    const limit = data ? parseInt(data.limit) : 15
    const order = data ? data.order : 'date-desc'
    const id = data ? data.id : null
    let page = data ? data.page : 1

    // Set search form selected values
    AppDom.query('select#brand', search).value = brand
    AppDom.query('select#genre', search).value = genre
    AppDom.query('select#limit', search).value = limit
    AppDom.query('select#order', search).value = order

    if (data) {
      const url = `/search/${brand}/${genre}/${limit}/${order}/${id}/${page}`

      // Update episode list data-parameters and content
      Search.setSearchParameters(brand, genre, limit, order)
      AppDom.setData(AppDom.query('#episode-list'), 'page', page)
      Search.loadEpisodeList(url)
    } else {
      if (queryString.length !== 0) {
        const urlParameters = new URLSearchParams(queryString)
        page = parseInt(urlParameters.get('page')) || 1
      }

      AppDom.setData(AppDom.query('#episode-list'), 'page', page)
      Search.initSearchForm(false)
    }
  },

  /* Init page history event and add search parameters to URL */
  setUrlParameters: function () {
    const data = AppDom.data(AppDom.query('#episode-list'))
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
    const list = AppDom.query('#episode-list')
    const loading = AppDom.query('#loading-indicator')
    const interval = 333

    AppDom.fadeTo(list, interval, 0)
    AppDom.fadeTo(loading, 0, 1)
    loading.style.zIndex = 99

    fetch(url)
      .then(function (response) {
        return response.text().then(function (html) {
          return {
            html,
            ok: response.ok
          }
        })
      })
      .then(function (response) {
        AppDom.fadeTo(list, interval, 1)
        AppDom.fadeTo(loading, 0, 0)
        loading.style.zIndex = -1

        if (!response.ok) {
          return
        }

        list.innerHTML = response.html
        Search.initPagingButtons()
        Player.initPlayButtons()
      })
      .catch(function () {
        AppDom.fadeTo(list, interval, 1)
        AppDom.fadeTo(loading, 0, 0)
        loading.style.zIndex = -1
      })
  },

  /* Initialize paging buttons */
  initPagingButtons: function () {
    AppDom.queryAll('.page-link').forEach(function (link) {
      if (link.dataset.pagingInitialized === 'true') {
        return
      }

      link.dataset.pagingInitialized = 'true'

      link.addEventListener('click', function (event) {
        const list = AppDom.query('#episode-list')
        const data = AppDom.data(link)

        event.preventDefault()

        AppDom.setData(list, 'page', data.page)
        Search.setUrlParameters()
        list.scrollIntoView()

        if (typeof data.url !== 'undefined') {
          Search.loadEpisodeList(data.url)
        }
      })
    })

    return false
  },

  /* Initialize episode search when form values are changed */
  initSearchForm: function (setUrlParameters) {
    const search = AppDom.query('#episode-search')

    Search.setSearchParameters(
      AppDom.query('select#brand', search).value,
      AppDom.query('select#genre', search).value,
      AppDom.query('select#limit', search).value,
      AppDom.query('select#order', search).value
    )

    Search.getSearchParameters()

    if (setUrlParameters === true) {
      Search.setUrlParameters()
    }
  }
}

/* Document ready state */
AppDom.ready(function () {
  Player.initPlayButtons()
  Search.initPagingButtons()

  // Initialize episode search when form values are changed
  AppDom.queryAll('#episode-search select').forEach(function (select) {
    select.addEventListener('change', function () {
      Search.initSearchForm(true)
    })
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
