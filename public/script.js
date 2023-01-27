const { createApp } = Vue;

var masonry = null;
var App = createApp({
  data() {
    return {
      backends: {},
      hovered: null,
      mapLink: null,
      cookie: document.cookie.split(';').map((w) => w.trim()),
      query: window.location.search.replace('?','').split('&').filter((w) => w.length > 0)
    }
  },

  created() {
    if (this.theme == 'light') {
      document.getElementsByTagName('body')[0].style.backgroundColor = '#eee';
    }
    var theme = document.createElement('link');
    theme.rel = 'stylesheet';
    theme.href = 'bootstrap-' + this.theme + '.min.css';
    document.getElementsByTagName('head')[0].appendChild(theme);

    var paginated = this.hasQuery('num');
    var self = this;

    var open = this.hasQuery('open') ? "?open=true" : "";

    var restpromise = axios.get('/api/restaurants' + open);

    if (paginated) {
      restpromise.then(function(resp) {
        var names = []
        for (it in resp.data) {
          names.push(it);
        }
        names.sort();

        var perPage = Number(self.getQuery('num'));
        var page = (Number(self.getQuery('page') || 1)) - 1;

        var promises = []
        names = names.slice(page * perPage, (page * perPage) + perPage);
        names.forEach(function(backend) {
          self.backends[backend] = resp.data[backend];

          promises.push(axios.get('/api/restaurant/' + backend)
               .then(function(resp) {
            console.log("Retrieved data for " + backend);
            self.backends[backend] = resp.data;
            self.backends[backend].loaded = true;
          }).catch(function(error) {
            self.setError(backend, error);
          }));
        });

        Promise.allSettled(promises).then(function() { self.reloadLayout(); });
      });
    } else {
      restpromise.then(function(resp) {
        var loaded = false;
        for (it in self.backends) {
          if (self.backends[it].loaded) {
            loaded = true;
          }
        }

        if (!loaded) {
          self.backends = resp.data;
        }
      });

      axios.get('/api/all' + open, { timeout: 750 })
                         .then(function(resp) {
        console.log("Retrieved all data from cache");
        self.backends = resp.data;
        for (it in self.backends) {
          self.backends[it].loaded = true;
        }
        self.reloadLayout();
      }).catch(function(_) {
        console.log("Full retrieval timed out, running per-entry");
        restpromise.then(function() {
          var promises = []
          Object.keys(self.backends).forEach(function(backend) {
            promises.push(axios.get('/api/restaurant/' + backend).then(function(resp) {
              console.log("Retrieved data for " + backend);
              self.backends[backend] = resp.data;
              self.backends[backend].loaded = true;
            }).catch(function(error) {
              self.setError(backend, error);
            }).then(function() { self.reloadLayout(); }));
          });
        });
      });
    }
  },
  computed: {
    isKiosk() {
      return this.hasQuery('kiosk');
    },
    backendNames() {
      return Object.keys(this.backends).sort();
    },
    theme() {
      if (!this.hasQuery('light') && (this.hasQuery('dark') || this.getCookie('theme') == 'dark')) {
        return 'dark';
      } else {
        return 'light';
      }
    },
    containerClass() {
      return {
        container: !this.isKiosk,
        'container-fluid': this.isKiosk
      }
    }
  },
  methods: {
    hasQuery(name) {
      return this.getQuery(name) != undefined;
    },
    getQuery(name) {
      var e = this.query.find(e => e.startsWith(name));
      if (e == undefined) { return e; }
      return e.split('=')[1] || true;
    },
    hasCookie(name) {
      return this.getCookie(name) != undefined;
    },
    getCookie(name) {
      var e = this.cookie.find(e => e.startsWith(name));
      if (e == undefined) { return e; }
      return e.split('=')[1] || true;
    },

    setError(backend, error) {
      if (error.response != undefined) {
        this.backends[backend] = { error: error, summary: $(error.response.data).find('#summary').html() };
      } else {
        this.backends[backend] = { error: error };
      }
    },
    mapIcon(icon) {
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
    mapTheme(colour) {
      if (colour != 'THEME') {
        return colour;
      }

      if (this.theme == 'light') {
        return 'dark';
      } else {
        return 'light';
      }
    },
    switchTheme(_) {
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
    reloadLayout() {
      if (!masonry) {
        console.log("Initializing masonry");
        setTimeout(function() {
          masonry = new Masonry('#menyer', {
            itemSelector: '.cardholder',
            percentPosition: true,
            transitionDuration: 0
          });
        }, 100);

        setTimeout(() => masonry.layout(), 150);
      } else {
        console.log("Reloading masonry layout");
        setTimeout(() => masonry.layout(), 100);
      }
    }
  }
});

App.mount('#app');
