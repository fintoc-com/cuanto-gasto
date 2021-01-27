<template>
  <div id="app">
    <Intro v-if="isIntro" v-bind:widgetWebhookHost="widgetWebhookHost" v-bind:session="session" @goToLoading="setLoadingStep"></Intro>
    <Loading v-if="isLoading"></Loading>
    <Results v-if="isResults" v-bind:results="results"></Results>
  </div>
</template>

<script>
import Intro from './views/intro.vue';
import Loading from './components/loading.vue';
import Results from './components/results.vue';

import axios from 'axios';

export default {
  data() {
    return {
      currentStep: 'intro',
      session: '',
      widgetWebhookHost: WIDGET_WEBHOOK_HOST,
    }
  },
  computed: {
    isIntro() {
      return this.currentStep === 'intro';
    },

    isLoading() {
      return this.currentStep === 'loading';
    },

    isResults() {
      return this.currentStep === 'results';
    },
  },
  components: { Intro, Loading, Results },

  created() {
    window.analytics.track('Intro Viewed');
    this.fetchSession();
  },

  methods: {
    setLoadingStep() {
      window.analytics.track('Loading Results Viewed');
      this.currentStep = 'loading';
      this.pollForResults();
    },

    setResultStep() {
      window.analytics.track('Results Viewed');
      this.currentStep = 'results';
    },

    async fetchSession() {
      const resp = await axios.post(`${RAILS_API_URL}/api/v1/session`);
      this.session = resp.data.session;
    },

    pollForResults() {
      this.polling = setInterval(this.resultsPolling, 2000);
    },

    resultsPolling() {
      axios.get(`${RAILS_API_URL}/api/v1/fintoc/${this.session}`)
        .then((resp) => {
            if (resp.data.status === 'completed') {
              this.results = resp.data;
              this.setResultStep();
              clearInterval(this.polling);
            }
        });
    },

  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
