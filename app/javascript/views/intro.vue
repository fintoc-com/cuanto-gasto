<template>
  <div class="bg-gray-100 min-h-screen flex flex-col">
    <div class="container max-w-lg mx-auto flex-1 flex flex-col items-center justify-center px-2">
      <h1 class="text-4xl">Cuánto<span class="font-bold">Gasto</span> 💸</h1>
      <h1 class="mt-5 text-3xl text-center font-regular text-gray-900">
        Revisa cuánto gastas en delivery 😱
      </h1>
      <h1 class="m-5 text-xl text-center text-gray-800">
        Primero tienes que conectar tu cuenta 🔌 de banco con <a href="https://fintoc.com">fintoc</a>
      </h1>

      <button 
          @click="openwidget"
          type="submit"
          class="group relative w-full flex justify-center py-4 px-4 border
                  border-transparent text-sm leading-5 font-medium rounded-md
                  text-white fintoc-blue focus:outline-none transition duration-150
                  ease-in-out focus:opacity-50"
          :class="{ 'hover:opacity-50': !invalidForm, 'cursor-not-allowed': invalidForm }">
        <span
          class="absolute left-0 inset-y-0 flex items-center pl-3">
          <svg class="h-5 w-5 text-white opacity-25 transition ease-in-out duration-150"
              fill="currentColor"
              viewBox="0 0 20 20">
            <path fill-rule="evenodd"
                  d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0
                    01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z"
                  clip-rule="evenodd" />
          </svg>
        </span>
        Conectar cuenta
      </button>
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
      <a href="https://blog.fintoc.com/cuanto-gasto"
         target="_blank"
         class="mt-6 text-sm focus:outline-none hover:underline transition ease-in-out duration-150"
      >
        ¿Por qué hacemos esto?
      </a>
      <widget v-if="showWidget" v-bind:widgetWebhookHost="widgetWebhookHost" v-bind:session="session" @close="closewidget" @linkCreated="linkCreated"></widget>
    </div>
  </div>
</template>

<script>
import widget from 'components/widget.vue';

export default {
  data() {
    return {
      showWidget: false,
    };
  },
  props: ['session', 'widgetWebhookHost'],
  components: { widget, },
  methods: {
     openwidget() {
      this.showWidget = true;
     },

     closewidget() {
      this.showWidget = false;
     },

    touchifpresentelsereset(field) {
      // eslint-disable-next-line no-negated-condition
      if (field.$model !== '') {
        field.$touch();
      } else {
        field.$reset();
      }
    },

    linkCreated() {
      this.$emit('goToLoading');
    },
  },
};
</script>

<style scoped>
  /* .vertical-slide-fade-enter,
  .vertical-slide-fade-leave-to {
    opacity: 0;
    transform: translatey(-18px);
  }
  .vertical-slide-fade-enter-active,
  .vertical-slide-fade-leave-active {
    transition: all .5s ease;
  } */
</style>
