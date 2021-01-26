<template>
  <div class="bg-gray-100 min-h-screen">
    <div class="container max-w-xl mx-auto flex flex-col items-center justify-center px-2 py-6">
      <div class="mt-12 w-full" v-if="!finished">
        <vue-typed-js
          @onComplete="finishDialog"
          :showCursor="false"
          :backSpeed="50"
          :typeSpeed="40"
          :smartBackspace="true"
          :strings="['Ya terminamos de procesar tus gastos.']"
        >
          <h2 class="typing inline font-mono"></h2>
        </vue-typed-js>
      </div>

      <div v-if="finished" class="font-mono">
        <h1 class="mt-6 text-xl text-center font-regular text-gray-900">
          Te gastaste en delivery
        </h1>
        <h2 class="mt-6 text-5xl text-center text-red-500">
          ${{ deliveryExpenses.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') }} CLP
        </h2>
        <div class="flex flex-row justify-between">
          <div class="w-56">
            <h1 class="mt-6 text-xl text-center font-regular text-gray-900">
              Rappi
            </h1>
            <h2 class="mt-6 text-lg text-center text-red-500">
              ${{ rappi.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') }} CLP
            </h2>
          </div>
          <div class="w-56">
            <h1 class="mt-6 text-xl text-center font-regular text-gray-900">
              Uber Eats
            </h1>
            <h2 class="mt-6 text-lg text-center text-red-500">
              ${{ uber_eats.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') }} CLP
            </h2>
          </div>
          <div class="w-56">
            <h1 class="mt-6 text-xl text-center font-regular text-gray-900">
              Uber
            </h1>
            <h2 class="mt-6 text-lg text-center text-red-500">
              ${{ uber.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') }} CLP
            </h2>
          </div>
        </div>
        <h1 class="mt-6 text-xl text-center font-regular text-gray-900">
          En Fintual hubieras ganado
        </h1>
        <h2 class="mt-6 text-3xl text-center text-green-500">
          ${{ savings.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') }} CLP
        </h2>
        <div class="mt-12 text-center">
          <p class="font-bold text-xs">Powered by</p>
          <a href="https://fintoc.com" target="_blank">
            <img
              class="mx-auto h-6 w-auto"
              src="https://d651wjhrjhvon.cloudfront.net/fintoc-logo.svg"
              alt="fintoc"
            >
          </a>
        </div>
      </div> 
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      showWidget: false,
      finished: false,
      rappi: 0,
      uber_eats: 0,
      uber: 0,
    };
  },
  props: ['results'],
  computed: {

    deliveryExpenses() {
      // const { rappi, uber_eats, uber } = { rappi: 1233123, uber_eats: 1233123, uber: 1233123 };
      const { rappi, uber_eats, uber } = this.results.expenses;
      this.rappi = rappi;
      this.uber_eats = uber_eats;
      this.uber = uber;
      return rappi + uber_eats + uber;
    },

    savings() {
      // const { rappi, uber_eats, uber } = { rappi: 1233123, uber_eats: 1233123, uber: 1233123 };
      const { rappi, uber_eats, uber } = this.results.investment;
      return rappi + uber_eats + uber;
    }
  },
  methods: {
    finishDialog() {
      this.finished = true;
    },
  },
};
</script>

<style scoped>
</style>
