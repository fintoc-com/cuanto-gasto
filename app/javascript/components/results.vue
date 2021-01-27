<template>
  <div class="bg-gray-100 min-h-screen">
    <div class="container max-w-xl mx-auto flex flex-col items-center justify-center px-2 py-6" v-show="!showPressKit">
      <div class="mt-12 w-full flex flex-col" v-if="!finished">
        <vue-typed-js
          @onComplete="changeToShowExperience"
          :showCursor="false"
          :backSpeed="40"
          :typeSpeed="35"
          :smartBackspace="true"
          :strings="['Ya terminamos de procesar tus gastos. 🤖  Veamos cómo estuvo el 2020. 🧐']"
        >
          <h2 class="typing inline font-mono"></h2>
        </vue-typed-js>

        <div v-if="showExperience">
          <div v-if="isNoExpensesExperience">
            <vue-typed-js
              @onComplete="finishLastDialog"
              :showCursor="false"
              :startDelay="2000"
              :backDelay="1000"
              :backSpeed="40"
              :typeSpeed="35"
              :smartBackspace="true"
              :strings="['Este año gastaste muuuucho.', 'Broma, en realidad no gastaste NADA. No tengo mucho más que aportar acá.']"
            >
              <h2 class="mt-6 typing inline font-mono"></h2>
            </vue-typed-js>
          </div>

          <div v-if="!isNoExpensesExperience">
            <vue-typed-js
              @onComplete="finishRappiOverUber"
              :showCursor="false"
              :startDelay="2000"
              :backDelay="1000"
              :backSpeed="40"
              :typeSpeed="35"
              :smartBackspace="true"
              :strings="[rappiOverUberText]"
            >
              <h2 class="mt-6 typing inline font-mono"></h2>
            </vue-typed-js>

            <vue-typed-js
              v-if="rappiOverUberFinished"
              @onComplete="finishCityTrips"
              :showCursor="false"
              :startDelay="2000"
              :backDelay="1000"
              :backSpeed="40"
              :typeSpeed="35"
              :smartBackspace="true"
              :strings="[cityTripsMessage1, cityTripsMessage2]"
            >
              <h2 class="mt-6 typing inline font-mono"></h2>
            </vue-typed-js>
          </div>

          <vue-typed-js
            v-if="isSmallExpenseExperience && cityTripsFinished"
            :showCursor="false"
            @onComplete="finishLastDialog"
            :startDelay="2000"
            :backDelay="1000"
            :backSpeed="40"
            :typeSpeed="35"
            :smartBackspace="true"
            :strings="['Este año no gastaste mucho en delivery. No debes tener mucha plata. 😅', `Este año no gastaste mucho en delivery. Eres un buen administrador 🤭. Estimo que pides delivery 1-2 veces por semana. 💸 ${finalMessage}`]"
          >
            <h2 class="mt-6 typing inline font-mono"></h2>
          </vue-typed-js>

          <vue-typed-js
            v-if="isMediumExpenseExperience && cityTripsFinished"
            :showCursor="false"
            @onComplete="finishLastDialog"
            :startDelay="2000"
            :backDelay="1000"
            :backSpeed="40"
            :typeSpeed="35"
            :smartBackspace="true"
            :strings="[`Te guuuuusta el delivery ah! 🐽 Bueno no te culpo, pandemia y todo eso 🦠. Estimo que pides delivery 3-4 veces por semana 😅. ${finalMessage}`]"
          >
            <h2 class="mt-6 typing inline font-mono"></h2>
          </vue-typed-js>

          <vue-typed-js
            v-if="isBigExpenseExperience && cityTripsFinished"
            :showCursor="false"
            @onComplete="finishLastDialog"
            :startDelay="2000"
            :backDelay="1000"
            :backSpeed="40"
            :typeSpeed="35"
            :smartBackspace="true"
            :strings="['Este año no gastaste muuuucho en Delivery. 😃', `Este año gastaste muuuuuuuuuuuuuuucho en Delivery.😆 Demasiado. Estás bien? Se te pasó la mano. Deberias considerar tomar clases de cocina. Tus números me dicen que pides delivery 4 veces por semana. 💸 ${finalMessage}`]"
          >
            <h2 class="mt-6 typing inline font-mono"></h2>
          </vue-typed-js>

          <vue-typed-js
            v-if="isCrazyExpenseExperience && cityTripsFinished"
            :showCursor="false"
            @onComplete="finishLastDialog"
            :startDelay="2000"
            :backDelay="1000"
            :backSpeed="40"
            :typeSpeed="35"
            :smartBackspace="true"
            :strings="['No, estos números no me cuadran debe haber un problema 😐. Es imposible lo que veo.', `Acabo de revisar y el problema eres tú. Soy un robot solamente 🤖, pero deberías pedir ayuda. Pides Delivery casi todos los días. 💸 ${finalMessage}`]"
          >
            <h2 class="mt-6 typing inline font-mono"></h2>
          </vue-typed-js>
        </div>

        <button
          v-show="showSummaryButton"
          @click="finishDialog"
          type="submit"
          class="mt-4 group self-end relative py-2 px-4 border font-mono
                border-transparent text-sm rounded-2xl
                text-white fintoc-blue focus:outline-none transition duration-150
                ease-in-out focus:opacity-50 hover:opacity-50 shadow-2xl">
          Resumen de tus gastos
        </button>
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
          Esa plata invertida en Fondos Mutuos hoy sería
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

        <div class="flex flex-row justify-center mx-auto mt-8">
          <button
            @click="toggleShowPressKit"
            class="pl-10 pr-5 cursor-pointer underline focus:outline-none">
            Press Kit
          </button>
          <a class="pr-5 pl-10 underline" href="mailto:hello@fintoc.com">Email Us </a>
        </div>
      </div>
    </div>

    <div class="container max-w-xl mx-auto flex flex-col items-center justify-center px-2 py-6" v-show="showPressKit">
      <div class="mt-12 w-full font-mono">
        <button class="cursor-pointer underline" @click="toggleShowPressKit"> Volver </button>
        <p class="mt-10">
          <span class="font-bold">Descripción:</span>
          Cuanto gasto es un robot que usando la API de Fintoc, te muestra cuanto gastaste el 2020 en delivery. Lo hace viendo todas las transacciones bancarias a tu nombre de Rappi y Uber Eats.
        </p>

        <p class="mt-10">
          <span class="font-bold">Objetivo:</span>
        </p>

        <p class="mt-10">
          <span class="font-bold">¿Qué es Fintoc?:</span> Es una herramienta que les permite a los programadores conectarse con las cuentas bancarias de sus usuarios. Es una API bancaria que funciona con bancos de personas y empresas.
        </p>

        <p class="mt-10">
          <span class="font-bold">¿Cuando partió Fintoc?:</span> En marzo de 2020. <a href="https://ventures.platan.us/" class="underline">Fuimos incubados por PV</a>.
        </p>

        <p class="mt-10">
          <span class="font-bold">¿Quienes están detrás de Fintoc?:</span>4 Ingenieros en Computación -Software Engineers-. <a class="underline">Cristóbal Griffero</a> y <a class="underline">Lukas Zorich</a> como fundadores/devs. <a class="underline">Juan Pablo Jofré</a> y <a class="underline">Nicolás Teare</a> como devs. 3/4 están en el ranking de los <a href="https://commits.top/chile_private.html" class="underline">programadores más activos de Chile</a>.
        </p>

        <p class="mt-10">
          <span class="font-bold">¿Comparten o venden los datos?:</span> Los datos no son compartidos con nadie. Tampoco de manera anonimizada. Toda la información es propiedad de los usuarios.
        </p>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      rappiOverUberFinished: false,
      showExperience: false,
      showSummaryButton: false,
      cityTripsFinished: false,
      showPressKit: false,
      showWidget: false,
      finished: false,
      rappi: 0,
      uber_eats: 0,
      uber: 0,
    };
  },
  props: ['results'],
  computed: {

    isNoExpensesExperience() {
      return this.deliveryExpenses == 0;
    },

    isSmallExpenseExperience() {
      return this.deliveryExpenses > 0 && this.deliveryExpenses < 650000;
    },

    isMediumExpenseExperience() {
      return this.deliveryExpenses >= 650000 && this.deliveryExpenses < 1300000;
    },

    isBigExpenseExperience() {
      return this.deliveryExpenses >= 1300000 && this.deliveryExpenses < 2600000;
    },

    isCrazyExpenseExperience() {
      return this.deliveryExpenses > 2600000;
    },

    cityTripsMessage1() {
      if (this.uber == 0) {
        return 'No te subiste a ningún Uber este año. O si lo hiciste no pagaste. 🤨'
      } else {
        return 'También fuiste a muchas fiestas clandestinas. 🤫'
      }
    },

    cityTripsMessage2() {
      if (this.uber == 0) {
        return 'No te subiste a ningún Uber este año. O si lo hiciste no pagaste. 🤨'
      } else if (this.uber < 250000) {
        return `Nuestra I.A. nos dice que gastaste ${this.uber} CLP en Uber 👀. A donde viajabas tanto en pandemia? 😏`
      } else {
        let extendMessage = 'A comprar comida supongo 👀 por que no pediste mucho a la casa.';
        if (this.rappi > 50000 || this.uber_eats > 50000) {
          extendMessage = '...Si ya sabemos que comida no te falto 🤭';
        }
        return `... 😐 Tú si que te moviste por la ciudad. 🚗 Gastaste $${this.uber.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,')} CLP en Uber. 💸  A donde viajabas tanto? ${extendMessage}`
      }
    },

    rappiOverUberText() {
      if (this.rappi > this.uber_eats) {
        return `Vamos por partes. Nuestra I.A. nos dice que te gusta más Rappi que UberEats. De hecho te gusta ${(this.rappi / this.uber_eats).toFixed(1)} veces más. Que tienes con Rappi? 🤨   Estás bien? No necesitas ayuda?`
      } else if (this.rappi < this.uber_eats) {
        return `Vamos por partes. Nuestra I.A. nos dice que prefieres UberEats sobre Rappi. De hecho lo prefieres ${(this.uber_eats / this.rappi).toFixed(1)} veces más. Que tienes con Uber? 🤨   Estás bien? No necesitas ayuda?`
      } else if (this.rappi === 0 && this.uber_eats === 0) {
        `Vamos por partes. Nuestra super I.A nos dice que... no tienes mucha plata?         No no... perdon, me equivoque de cuenta. Simplemente eres bueno ahorrando 😜`
      } else {
        return 'Vamos por partes. Nuestra I.A. nos dice que te gusta Rappi y UberEats ...por igual? 😱 ...Esto significa que eres igual de malo ahorrando en ambas plataformas 🤭 Bueno, sigamos.';
      }
    },

    finalMessage() {
      return `El total que gastaste fue de $${this.deliveryExpenses.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,')} CLP 💸, en fondos mutuos hoy esta plata sumaría $${this.savings.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,')} CLP. 📈`
    },

    deliveryExpenses() {
      const { rappi, uber_eats, uber } = this.results.expenses;
      this.rappi = -rappi;
      this.uber_eats = -uber_eats;
      this.uber = -uber;
      console.log(-rappi + -uber_eats + -uber)
      return -rappi + -uber_eats + -uber;
    },

    savings() {
      const { rappi, uber_eats, uber } = this.results.investment;
      return rappi + uber_eats + uber;
    }
  },
  methods: {
    finishLastDialog(){
      this.showSummaryButton = true;
    },

    finishCityTrips(){
      this.cityTripsFinished = true;
    },

    finishRappiOverUber() {
      this.rappiOverUberFinished = true;
    },

    changeToShowExperience(){
      this.showExperience = true;
    },

    toggleShowPressKit(){
      this.showPressKit = !this.showPressKit;

      if (this.showPressKit) window.analytics.track('Press Kit Viewed');
    },

    finishDialog() {
      this.finished = true;
    },
  },
};
</script>

<style scoped>
</style>
