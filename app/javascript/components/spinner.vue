<template>
  <div>
    <div class="w-full h-full absolute top-0 left-0 z-30 flex flex-col
                items-center justify-center">
      <div class="spinner ease-linear rounded-full border-8 border-t-8 border-gray-200
                  h-32 w-32">
      </div>
      <div>
        <slot></slot>
      </div>
    </div>
    <div class="w-full h-full bg-white absolute top-0 left-0 z-20 opacity-75">
    </div>
  </div>
</template>

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
