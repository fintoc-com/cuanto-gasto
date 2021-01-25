<template>
  <div class="bg-gray-100 min-h-screen flex flex-col">
    <div class="container max-w-lg mx-auto flex-1 flex flex-col items-center justify-center px-2">
      <h1 class="text-4xl">Cuánto<span class="font-bold">Gasto</span> 💸</h1>
      <h1 class="mt-6 text-3xl text-center font-regular text-gray-900">
        Estamos calculando tus gastos
      </h1>

      <div class="mt-6 loader ease-linear rounded-full border-8 border-t-8 border-gray-200 h-48 w-48" />

      <h1 class="mt-6 text-xl text-center text-gray-800">
        Nos podemos demorar <span class="italic">un poco</span> puedes ir por un café por mientras ☕
      </h1>
      <div class="mt-6">
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
</template>

<script>
export default {
  methods: {
  },
};
</script>

<style scoped>
.loader {
  border-top-color: #101058;
  -webkit-animation: spinner 1.5s linear infinite;
  animation: spinner 1.5s linear infinite;
}

@-webkit-keyframes spinner {
  0% { -webkit-transform: rotate(0deg); }
  100% { -webkit-transform: rotate(360deg); }
}

@keyframes spinner {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style>
