<template>
  <div class="bg-gray-100 min-h-screen flex flex-col">
    <div class="container max-w-lg mx-auto flex-1 flex flex-col items-center justify-center px-2">
      <img
        class="mx-auto h-12 w-auto"
        src="https://d651wjhrjhvon.cloudfront.net/fintoc-logo.svg"
        alt="fintoc"
      >
      <h1 class="mt-5 text-xl text-center font-regular text-gray-900">
        Te gastaste en delivery
      </h1>
      <h2 class="m-5 text-3xl text-center text-red-500">
        {{ deliveryExpenses }}
      </h2>

      <h1 class="mt-5 text-xl text-center font-regular text-gray-900">
        En Fintual hubieras ganado
      </h1>
      <h2 class="m-5 text-3xl text-center text-green-500">
        {{ savings }}
      </h2>

    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      showwidget: false,
    };
  },
  props: ['results'],
  computed: {
    deliveryExpenses() {
      const { rappi, uber_eats, uber } = this.results.expenses;
      return rappi + uber_eats + uber;
    },

    savings() {
      const { rappi, uber_eats, uber } = this.results.investment;
      return rappi + uber_eats + uber;
    }
  },
  methods: {
  },
};
</script>

<style scoped>
</style>
