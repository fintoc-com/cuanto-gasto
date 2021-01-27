<template>
  <div class="bg-gray-100 min-h-screen">
    <div class="container max-w-xl mx-auto flex flex-col items-center px-2 py-6">

      <div v-if="showDialog == false">
        <h1 class="text-5xl text-center font-mono leading-tight text-gray-900">
          ¿Cuánto gastas en delivery?
        </h1>

        <h1 class="mt-6 text-6xl text-center">
          💸😱
        </h1>

        <h1 class="mt-6 text-xl text-center text-gray-800 font-mono leading-relaxed">
          Nuestra Inteligencia Artificial calculará tus gastos anuales en comida delivery
        </h1>

        <button
            @click="closeIntro"
            type="submit"
            class="mt-10 fintoc-blue text-white mx-auto group flex justify-center py-2 px-10 border
                   border-transparent text-sm leading-5 font-medium rounded-2xl
                   focus:outline-none transition duration-150
                   ease-in-out focus:opacity-50 hover:opacity-50 font-mono shadow-2xl"
        >
          Continuar
        </button>

        <div class="mt-10 text-center">
          <p class="text-xs m-1 font-bold font-mono">Powered by</p>
          <a href="https://fintoc.com" target="_blank">
            <img
              class="mx-auto h-6 w-auto"
              src="https://d651wjhrjhvon.cloudfront.net/fintoc-logo.svg"
              alt="fintoc"
            >
          </a>
        </div>
      </div>

      <div v-if="showDialog == true" class="mt-12 w-full">
        <vue-typed-js
          @onComplete="showNextDialog"
          :showCursor="false"
          :backSpeed="40"
          :typeSpeed="30"
          :smartBackspace="true"
          :strings="['Hola! Soy X AE A-XII, una I.A entrenada para detectar cuanto gastas por año en delivery (Rappi y Uber Eats).']"
        >
          <h2 class="typing font-mono"></h2>
        </vue-typed-js>

        <vue-typed-js v-if="showSecondDialog"
          @onComplete="changeToShowWidgetButton"
          :showCursor="false"
          :backSpeed="40"
          :typeSpeed="30"
          :smartBackspace="true"
          :strings="['Voy a necesitar conectarme con tu cuenta bancaria. Solo revisaré los gastos de la tarjeta de crédito.']"
        >
          <h2 class="mt-6 typing font-mono"></h2>
        </vue-typed-js>

        <div class="w-full flex flex-col">
          <button
            v-show="showWidgetButton && !showWhyDialog"
            @click="openWidget"
            type="submit"
            class="mt-6 group self-end py-2 px-4 border font-mono
                  border-transparent text-sm rounded-2xl text-white fintoc-blue
                  focus:outline-none transition duration-150 shadow-2xl
                  ease-in-out focus:opacity-50 hover:opacity-50"
          >
            Conectar cuenta
          </button>

          <button
            v-show="showWidgetButton"
            @click="changeToChangeShowDialog"
            type="submit"
            class="mt-4 group self-end relative py-2 px-4 border font-mono
                  border-transparent text-sm rounded-2xl
                  text-white fintoc-blue focus:outline-none transition duration-150
                  ease-in-out focus:opacity-50 hover:opacity-50 shadow-2xl"
            :class="{ 'opacity-50': showWhyDialog }">
            ¿Por qué hacen esto?
          </button>
        </div>

        <vue-typed-js v-if="showWhyDialog"
          @onComplete="finishThirdDialog"
          :showCursor="false"
          :backSpeed="40"
          :typeSpeed="30"
          :smartBackspace="true"
          :strings="['Mis creadores me construyeron cómo un ejemplo de las cosas que se pueden construir con Fintoc.']"
        >
          <h2 class="mt-6 typing font-mono"></h2>
        </vue-typed-js>

        <div class="w-full flex flex-col">
          <button
            v-show="thirdDialogFinished && !showNoThanksDialog"
            @click="openWidget"
            type="submit"
            class="mt-6 group self-end py-2 px-4 border font-mono
                  border-transparent text-sm rounded-2xl text-white fintoc-blue
                  focus:outline-none transition duration-150 shadow-2xl
                  ease-in-out focus:opacity-50 hover:opacity-50"
          >
            Conectar cuenta
          </button>

          <button
            v-show="thirdDialogFinished"
            @click="changeToChangeShowNoThanksDialog"
            type="submit"
            class="mt-4 group self-end relative py-2 px-4 border font-mono
                  border-transparent text-sm rounded-2xl
                  text-white fintoc-blue focus:outline-none transition duration-150
                  ease-in-out focus:opacity-50 hover:opacity-50 shadow-2xl"
            :class="{ 'opacity-50': showNoThanksDialog }">
            No gracias
          </button>
        </div>

        <vue-typed-js v-if="showNoThanksDialog"
          @onComplete="finishNothanksDialog"
          :showCursor="false"
          :backSpeed="40"
          :typeSpeed="30"
          :smartBackspace="true"
          :strings="['No puedo ver cuanto gastaste en Delivery sin conectarme a tu banco. Conectar tu cuenta de banco usando Fintoc es seguro. Tus datos se mantienen privados y la conexión con el banco se encuentra encriptada.']"
        >
          <h2 class="mt-6 typing font-mono"></h2>
        </vue-typed-js>
      </div>

      <div class="w-full flex flex-col">
          <button
            v-show="noThanksDialogFinished"
            @click="openWidget"
            type="submit"
            class="mt-6 group self-end py-2 px-4 border font-mono
                  border-transparent text-sm rounded-2xl text-white fintoc-blue
                  focus:outline-none transition duration-150 shadow-2xl
                  ease-in-out focus:opacity-50 hover:opacity-50"
          >
            Conectar cuenta
          </button>
      </div>

      <widget v-if="showWidget" v-bind:widgetWebhookHost="widgetWebhookHost" v-bind:session="session" @close="closeWidget" @linkCreated="linkCreated"></widget>
    </div>
  </div>
</template>

<script>
import widget from 'components/widget.vue';

export default {
  data() {
    return {
      showWidget: false,
      showDialog: false,
      showSecondDialog: false,
      thirdDialogFinished: false,
      showWidgetButton: false,
      showWhyDialog: false,
      showNoThanksDialog: false,
      noThanksDialogFinished: false,
    };
  },
  props: ['session', 'widgetWebhookHost'],
  components: { widget, },
  methods: {
    finishNothanksDialog(){
      this.noThanksDialogFinished = true;
    },

    changeToChangeShowNoThanksDialog() {
      this.showNoThanksDialog = true;
    },

    finishThirdDialog() {
      this.thirdDialogFinished = true;
    },

    changeToShowWidgetButton() {
      this.showWidgetButton = true
    },

    closeIntro() {
      window.analytics.track('Intro Dialog Viewed');
      this.showDialog = true;
    },

    openWidget() {
      window.analytics.track('Widget Opened');
      this.showWidget = true;
    },

    closeWidget() {
      window.analytics.track('Widget Closed');
      this.showWidget = false;
    },

    showNextDialog() {
      this.showSecondDialog = true;
    },

    changeToChangeShowDialog() {
      this.showWhyDialog = true;
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
      window.analytics.track('Link Created');
      this.$emit('goToLoading');
    },
  },
};
</script>
