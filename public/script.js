App = new Vue({
  el: "#app",

  data: {
    backends: {},
    hovered: null,
    mapLink: null,
    cookie: document.cookie.split(';').map((w) => w.trim()),
    query: window.location.search.replace('?','').split('&').filter((w) => w.length > 0),
    masonry: null
  },

  created: function() {
    if (this.theme == 'light') {
      document.getElementsByTagName('body')[0].style.backgroundColor = '#eee';
    }
    var theme = document.createElement('link');
    theme.rel = 'stylesheet';
    theme.href = 'bootstrap-' + this.theme + '.min.css';
    document.getElementsByTagName('head')[0].appendChild(theme);

    var paginated = this.hasQuery('num');

    var namepromise = axios.get('/api/names');

    if (paginated) {
      namepromise.then(function(resp) {
        var names = []
        for (it in resp.data) {
          let name = resp.data[it];
          names.push(name);
        }

        var perPage = Number(App.getQuery('num'));
        var page = (Number(App.getQuery('page') || 1)) - 1;

        var promises = []
        names = names.slice(page * perPage, (page * perPage) + perPage);
        names.forEach(function(backend) {
          Vue.set(App.backends, backend, {});
          promises.push(axios.get('/api/' + backend)
               .then(function(resp) {
            console.log("Retrieved data for " + backend);
            Vue.set(App.backends, backend, Object.assign({}, App.backends[backend], resp.data));
          }).catch(function(error) {
            App.setError(backend, error);
          }));
        });

        Promise.allSettled(promises).then(function() { App.reloadLayout(); });
      });
    } else {
      namepromise.then(function(resp) {
        for (it in resp.data) {
          let name = resp.data[it];
          if (!App.backends[name]) {
            Vue.set(App.backends, name, {});
          }
        }
      });

      axios.get('/api/all', { timeout: 750 })
                         .then(function(resp) {
        console.log("Retrieved all data from cache");
        Vue.set(App, 'backends', Object.assign({}, resp.data));
        App.reloadLayout();
      }).catch(function(ex) {
        console.log("Full retrieval timed out, running per-entry");
        namepromise.then(function() {
          var promises = []
          Object.keys(App.backends).forEach(function(backend) {
            promises.push(axios.get('/api/' + backend).then(function(resp) {
              console.log("Retrieved data for " + backend);
              Vue.set(App.backends, backend, Object.assign({}, resp.data));
            }).catch(function(error) {
              App.setError(backend, error);
            }));
          });

          Promise.allSettled(promises).then(function() { App.reloadLayout(); });
        });
      });
    }
  },
  computed: {
    isKiosk: function() {
      return this.hasQuery('kiosk');
    },
    theme: function() {
      if (!this.hasQuery('light') && (this.hasQuery('dark') || this.getCookie('theme') == 'dark')) {
        return 'dark';
      } else {
        return 'light';
      }
    }
  },
  methods: {
    hasQuery: function(name) {
      return this.getQuery(name) != undefined;
    },
    getQuery: function(name) {
      var e = this.query.find(e => e.startsWith(name));
      if (e == undefined) { return e; }
      return e.split('=')[1] || true;
    },
    hasCookie: function(name) {
      return this.getCookie(name) != undefined;
    },
    getCookie: function(name) {
      var e = this.cookie.find(e => e.startsWith(name));
      if (e == undefined) { return e; }
      return e.split('=')[1] || true;
    },

    setError: function(backend, error) {
      if (error.response != undefined) {
        Vue.set(App.backends, backend, { error: error, summary: $(error.response.data).find('#summary').html() });
      } else {
        Vue.set(App.backends, backend, { error: error });
      }
    },
    mapIcon: function(icon) {
      var hasClass = false;
      var classes = icon.split(' ').map(function(w) {
        if (w.match(/^fa[srldb]$/)) {
          hasClass = true;
          return w;
        } else {
          return 'fa-' + w;
        }
      });
      if (!hasClass) {
        classes.unshift('fas');
      }
      return classes;
    },
    mapTheme: function(colour) {
      if (colour != 'THEME') {
        return colour;
      }

      if (this.theme == 'light') {
        return 'dark';
      } else {
        return 'light';
      }
    },
    switchTheme: function(_) {
      var query = this.query.filter((w) => w != 'dark' && w != 'light');
      if (this.theme == 'light') {
        document.cookie = 'theme=dark';
      } else {
        document.cookie = 'theme=light';
      }

      if (query.length == 0) {
        document.location.search = '';
      } else {
        document.location.search = '?' + query.filter((w) => w.length > 0).join('&');
      }
    },
    reloadLayout: function() {
      if (!this.masonry) {
        console.log("Initializing masonry");
        setTimeout(function() {
          App.masonry = new Masonry('#menyer', {
            itemSelector: '.cardholder',
            percentPosition: true,
            transitionDuration: 0
          });
        }, 100);

        setTimeout(() => App.masonry.layout(), 150);
      } else {
        console.log("Reloading masonry layout");
        setTimeout(() => App.masonry.layout(), 100);
      }
    }
  }
});