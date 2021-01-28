import Vue from 'vue/dist/vue.esm';
import App from '../app.vue';
import '../css/application.css';

import VueTypedJs from 'vue-typed-js'
Vue.use(VueTypedJs)

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#vue-app',
    components: { App },
  });

  return app;
});
