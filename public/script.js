const { createApp } = Vue;

var staticData = {};
document.querySelectorAll('[data-backend-name]').forEach(function(data) {
  console.log("Loading backend");
  console.log(data);
  const backend = data.getAttribute('data-backend-name');
  staticData[backend] = {
    open: (data.getAttribute('data-backend-open') == 'true'),
    loaded: (data.getAttribute('data-backend-cached') == 'true' || data.getAttribute('data-backend-open') != 'true'),
  };
});

var masonry = null;
var App = createApp({
  data() {
    return {
      backends: staticData,
      hovered: null,
      mapLink: null,
      cookie: document.cookie.split(';').map((w) => w.trim()),
      query: window.location.search.replace('?','').split('&').filter((w) => w.length > 0),
      theme: 'light',
    }
  },

  created() {
    this.theme = (!this.hasQuery('light') && (this.hasQuery('dark') || this.getCookie('theme') == 'dark')) ? 'dark' : 'light';

    var self = this;
    var promises = []
    Object.keys(this.backends).forEach(function(backend) {
      if (!self.backends[backend].loaded) {
        console.log("Requesting data for " + backend);
        promises.push(axios.get('/api/restaurant/' + backend).then(function(resp) {
          console.log("Retrieved data for " + backend);
          self.backends[backend] = resp.data;
          self.backends[backend].loaded = true;
        }).catch(function(error) {
          self.setError(backend, error);
        }).then(function() {
          self.reloadLayout();
        }));
      }
    });

    self.reloadLayout();
  },

  computed: {
    isKiosk() {
      return this.hasQuery('kiosk');
    },
    backendNames() {
      return Object.keys(this.backends).sort();
    },
    theme() {
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
      if (this.theme == 'light') {
        this.theme = 'dark';
      } else {
        this.theme = 'light';
      }

      document.cookie = 'theme=' + this.theme;
      var stylesheet = document.querySelector('link[name="theme"]');
      stylesheet.href = 'bootstrap-' + this.theme + '.min.css';

      document.getElementById('app').className = this.theme;
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
