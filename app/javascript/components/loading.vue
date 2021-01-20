<template>
  <div class="bg-gray-100 min-h-screen flex flex-col">
    <div class="container max-w-lg mx-auto flex-1 flex flex-col items-center justify-center px-2">
      <img
        class="mx-auto h-12 w-auto"
        src="https://d651wjhrjhvon.cloudfront.net/fintoc-logo.svg"
        alt="fintoc"
      >
      <h1 class="mt-5 text-3xl text-center font-regular text-gray-900">
        Estamos calculando tus gastos
      </h1>
      <h1 class="m-5 text-xl text-center text-gray-800">
        Nos podemos demorar un poco
      </h1>

      <div class="spinner ease-linear rounded-full border-8 border-t-8 border-gray-200
                  h-32 w-32">
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
@-webkit-keyframes spinner {
  0% { -webkit-transform: rotate(0deg); }
  100% { -webkit-transform: rotate(360deg); }
}
@keyframes spinner {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
.spinner {
  z-index: 1;
  border-top-color: #3498db;
  -webkit-animation: spinner 1.5s linear infinite;
  animation: spinner 1.5s linear infinite;
}
</style>
