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
          Nuestra Inteligencia Artificial calculará tus gastos anuales en comida delivery.
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
              src="https://d651wjhrjhvon.cloudfront.net/imagotipo.svg"
              alt="fintoc"
            >
          </a>
        </div>
      </div>

      <div v-if="showDialog == true" class="mt-12 w-full">
        <vue-typed-js
          @onComplete="showNextDialog"
          :showCursor="false"
          :backSpeed="35"
          :typeSpeed="20"
          :smartBackspace="true"
          :strings="['Hola! Soy Bender, una I.A entrenada para detectar cuánto gastas por año en delivery (Rappi y Uber Eats).']"
        >
          <h2 class="typing font-mono"></h2>
        </vue-typed-js>

        <vue-typed-js v-if="showSecondDialog"
          @onComplete="changeToShowWidgetButton"
          :showCursor="false"
          :backSpeed="35"
          :typeSpeed="20"
          :smartBackspace="true"
          :strings="['Partamos por conectar tu cuenta. Solo nos tomará unos segundos.']"
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
          :backSpeed="35"
          :typeSpeed="20"
          :smartBackspace="true"
          :contentType="'html'"
          :strings="[whyText]"
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
          :backSpeed="35"
          :typeSpeed="20"
          :smartBackspace="true"
          :strings="['No puedo ver cuanto gastaste en Delivery sin conectarme a tu banco. Tus datos se mantienen privados y la conexión con el banco se encuentra encriptada.']"
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
    </div>
  </div>
</template>

<script>
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
      widget: null,
    };
  },
  props: ['session', 'widgetWebhookHost'],
  computed: {
    whyText() {
      return `<p>Soy un ejemplo de las cosas que se pueden armar sobre Fintoc. <a href='https://blog.fintoc.com/por-que-creamos-cuanto-gasto/' class='underline' target='_blank'>Acá</a> hay un post que explica esto mejor que yo.</p>. Si te preocupan tus datos, <a href='https://fintoc.com/legal/' class='underline' target='_blank'>acá</a> explicamos cómo los cuidamos.`;
    },
  },
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
      // window.analytics.track('Intro Dialog Viewed');
      this.showDialog = true;

      this.widget = Fintoc.create({
        holderType: 'individual',
        product: 'movements',
        webhookUrl: `${this.widgetWebhookHost}/api/v1/fintoc/${this.session}/webhook`,
        publicKey: 'pk_test_NSx_XfEuRNn4xnA7MJ7DQQpje7cjghYA',
        onSuccess: this.linkCreated,
      })
    },

    openWidget() {
      // window.analytics.track('Widget Opened');
      this.showWidget = true;
      this.widget.open();
    },

    closeWidget() {
      // window.analytics.track('Widget Closed');
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
      // window.analytics.track('Link Created');
      this.$emit('goToLoading');
    },
  },
};
</script>
