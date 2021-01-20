<template>
  <div id="app">
    <Intro v-if="isIntro" v-bind:session="session" @goToLoading="setLoadingStep"></Intro>
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
    this.fetchSession();
    console.log(RAILS_API_URL);
  },

  methods: {
    setLoadingStep() {
      this.currentStep = 'loading';
      this.pollForResults();
    },

    setResultStep() {
      this.currentStep = 'results';
    },

    async fetchSession() {
      const resp = await axios.post('http://localhost:3000/api/v1/session');
      this.session = resp.data.session;
    },

    pollForResults() {
      this.polling = setInterval(this.resultsPolling, 2000);
    },

    resultsPolling() {
      axios.get(`http://localhost:3000/api/v1/fintoc/${this.session}`)
        .then((resp) => {
            if (resp.data.status === 'completed') {
              this.results = resp.data;
              console.log(this.results);
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
