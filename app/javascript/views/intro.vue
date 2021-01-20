<template>
  <div class="bg-gray-100 min-h-screen flex flex-col">
    <div class="container max-w-lg mx-auto flex-1 flex flex-col items-center justify-center px-2">
      <img
        class="mx-auto h-12 w-auto"
        src="https://d651wjhrjhvon.cloudfront.net/fintoc-logo.svg"
        alt="fintoc"
      >
      <h1 class="mt-5 text-3xl text-center font-regular text-gray-900">
        Revisa cuánto gastas en delivery
      </h1>
      <h1 class="m-5 text-xl text-center text-gray-800">
        primero tienes que conectar tu cuenta de banco con <a href="https://fintoc.com">fintoc</a>
      </h1>

      <button
        type="submit"
        v-on:click="openwidget"
        class="group relative w-full flex justify-center py-4 px-4 border
           border-transparent text-sm leading-5 rounded-md
           text-white fintoc-blue focus:outline-none transition duration-150
           ease-in-out">
           conectar cuenta
      </button>

      <widget v-if="showwidget" v-bind:session="session" @close="closewidget" @linkCreated="linkCreated"></widget>
    </div>
  </div>
</template>

<script>
import widget from 'components/widget.vue';

export default {
  data() {
    return {
      showwidget: false,
    };
  },
  props: ['session'],
  components: { widget, },
  methods: {
     openwidget() {
      this.showwidget = true;
     },

     closewidget() {
      this.showwidget = false;
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
  .vertical-slide-fade-enter,
  .vertical-slide-fade-leave-to {
    opacity: 0;
    transform: translatey(-18px);
  }
  .vertical-slide-fade-enter-active,
  .vertical-slide-fade-leave-active {
    transition: all .5s ease;
  }
</style>
