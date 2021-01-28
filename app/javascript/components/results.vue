<template>
  <div>
    <div class="container max-w-xl mx-auto flex flex-col items-center justify-center my-6" v-show="!showPressKit">
      <div class="py-2 space-y-2m:mt-12 w-full flex flex-col px-2" v-if="!finished">
        <vue-typed-js
          @onComplete="changeToShowExperience"
          :showCursor="false"
          :backSpeed="35"
          :typeSpeed="20"
          :smartBackspace="true"
          :strings="['Terminamos de procesar tus gastos. Veamos cómo estuvo el 2020 🧐.']"
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
              :backSpeed="35"
              :typeSpeed="20"
              :smartBackspace="true"
              :strings="['Este año gastaste muuuucho.', 'Broma, en verdad no compraste NADA. Nada más que decir acá.']"
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
              :backSpeed="35"
              :typeSpeed="20"
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
              :backSpeed="35"
              :typeSpeed="20"
              :smartBackspace="true"
              :strings="[cityTripsMessage1, cityTripsMessage2]"
            >
              <h2 class="mt-6 typing inline font-mono"></h2>
            </vue-typed-js>
          </div>


          <vue-typed-js
            v-if="showBeforeEnding"
            :showCursor="false"
            @onComplete="goToEnding"
            :startDelay="2000"
            :backDelay="1000"
            :backSpeed="35"
            :typeSpeed="20"
            :smartBackspace="true"
            :strings="['Entonces... qué aprendimos hoy 🔍']"
          >
            <h2 class="mt-6 typing inline font-mono"></h2>
          </vue-typed-js>

          <vue-typed-js
            v-if="isSmallExpenseExperience && cityTripsFinished"
            :showCursor="false"
            @onComplete="finishLastDialog"
            :startDelay="2000"
            :backDelay="1000"
            :backSpeed="35"
            :typeSpeed="20"
            :smartBackspace="true"
            :strings="['Este año no gastaste mucho en delivery. No debes tener mucha plata 😅.', `Este año no gastaste mucho en delivery. Eres un buen administrador 🤭. Creo que pides delivery 1-2 veces por semana 💸.`]"
          >
            <h2 class="mt-6 typing inline font-mono"></h2>
          </vue-typed-js>

          <vue-typed-js
            v-if="isMediumExpenseExperience && cityTripsFinished"
            :showCursor="false"
            @onComplete="finishLastDialog"
            :startDelay="2000"
            :backDelay="1000"
            :backSpeed="35"
            :typeSpeed="20"
            :smartBackspace="true"
            :strings="[`Eres bien malo para cocinar! Creo que pides delivery 3-4 veces por semana 😅.`]"
          >
            <h2 class="mt-6 typing inline font-mono"></h2> 
          </vue-typed-js>

          <vue-typed-js
            v-if="isBigExpenseExperience && cityTripsFinished"
            :showCursor="false"
            @onComplete="finishLastDialog"
            :startDelay="2000"
            :backDelay="1000"
            :backSpeed="35"
            :typeSpeed="20"
            :smartBackspace="true"
            :strings="['Este año no gastaste mucho en Delivery 😃.', `Este año gastaste mucho en Delivery. Se te pasó la mano. Pides delivery fácil 4 veces por semana.`]"
          >
            <h2 class="mt-6 typing inline font-mono"></h2>
          </vue-typed-js>

          <vue-typed-js
            v-if="isCrazyExpenseExperience && cityTripsFinished"
            :showCursor="false"
            @onComplete="finishLastDialog"
            :startDelay="2000"
            :backDelay="1000"
            :backSpeed="35"
            :typeSpeed="20"
            :smartBackspace="true"
            :strings="['Está raro esto. Esperame un poco...', `Deberías pedir ayuda. Pides Delivery casi todos los días.`]"
          >
            <h2 class="mt-6 typing inline font-mono"></h2>
          </vue-typed-js>

           <vue-typed-js
            v-if="showPercentile"
            :showCursor="false"
            @onComplete="showFintualChange"
            :startDelay="2000"
            :backDelay="1000"
            :backSpeed="35"
            :typeSpeed="20"
            :smartBackspace="true"
            :strings="[`${percentileSummaryMessage}`]"
          >
            <h2 class="mt-6 typing inline font-mono"></h2>
          </vue-typed-js>

          <vue-typed-js
            v-if="showFintual"
            :showCursor="false"
            @onComplete="showButton"
            :startDelay="2000"
            :backDelay="1000"
            :backSpeed="35"
            :typeSpeed="20"
            :smartBackspace="true"
            :strings="[`${finalMessage}`]"
          >
            <h2 class="mt-6 typing inline font-mono"></h2>
          </vue-typed-js>
        </div>

        <button
          v-show="showSummaryButton"
          @click="finishDialog"
          type="submit"
          class="mt-4 mb-6 mx-4 group self-end relative py-2 px-4 border font-mono
                border-transparent text-sm rounded-2xl
                text-white fintoc-blue focus:outline-none transition duration-150
                ease-in-out focus:opacity-50 hover:opacity-50 shadow-2xl">
          Resumen de tus gastos
        </button>
      </div>

      <div v-if="finished" class="font-mono flex flex-col items-center justify-center">
        <h1 class="mt-6 text-lg sm:text-xl text-center font-regular text-gray-900">
          Te gastaste en delivery 💸
        </h1>
        <h2 class="text-2xl sm:mt-6 sm:text-5xl text-center text-red-500">
          ${{ deliveryExpenses.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') }} CLP
        </h2>
        <div class="flex flex-row justify-between">
          <div class="w-24 sm:w-56">
            <h1 class="mt-6 text-lg sm:text-xl text-center font-regular text-gray-900">
              Rappi
            </h1>
            <h2 class="mt-6 text-sm sm:text-lg text-center text-red-500">
              ${{ rappi.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') }} CLP
            </h2>
          </div>
          <div class="w-24 sm:w-56">
            <h1 class="mt-6 text-lg sm:text-xl text-center font-regular text-gray-900">
              Uber Eats
            </h1>
            <h2 class="mt-6 text-sm sm:text-lg text-center text-red-500">
              ${{ uber_eats.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') }} CLP
            </h2>
          </div>
          <div class="w-24 sm:w-56">
            <h1 class="mt-6 text-lg sm:text-xl text-center font-regular text-gray-900">
              Uber
            </h1>
            <h2 class="mt-6 text-sm sm:text-lg text-center text-red-500">
              ${{ uber.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') }} CLP
            </h2>
          </div>
        </div>
        <h1 class="mt-6 text-lg sm:text-xl text-center font-regular text-gray-900">
          Esa plata invertida en Fondos Mutuos hoy sería 📈
        </h1>
        <h2 class="mt-6 text-xl sm:text-3xl text-center text-green-500">
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
          Cuánto gasto es un robot que usando la API de Fintoc, te muestra cuánto gastaste el 2020 en delivery. Lo hace viendo todas las transacciones bancarias a tu nombre de Rappi y Uber Eats.
        </p>

        <p class="mt-10">
          <span class="font-bold">Objetivo:</span>
          Explicar fintoc es difícil. Descubrimos que lo más fácil es mostrar ejemplos de las cosas que se pueden hacer con la herramienta. <a href="https://blog.fintoc.com/por-que-creamos-cuanto-gasto/" class="underline" target="_blank">Acá</a> una explicación más detallada.
        </p>

        <p class="mt-10">
          <span class="font-bold">¿Qué es Fintoc?:</span> Es una herramienta que les permite a los programadores conectarse con las cuentas bancarias de sus usuarios. Es una API bancaria que funciona con bancos de personas y empresas.
        </p>

        <p class="mt-10">
          <span class="font-bold">¿Cuando partió Fintoc?:</span> En marzo de 2020. <a href="https://ventures.platan.us/" class="underline">Fuimos incubados por PV</a>.
        </p>

        <p class="mt-10">
          <span class="font-bold">¿Quienes están detrás de Fintoc?:</span>4 Ingenieros en Computación -Software Engineers-. <a href="https://www.linkedin.com/in/griffero/" class="underline">Cristóbal Griffero</a> y <a href="https://www.linkedin.com/in/lezorich/" class="underline">Lukas Zorich</a> como fundadores/devs. <a class="underline" href="https://www.linkedin.com/in/juan-pablo-jofr%C3%A9-56bbb5b4/">Juan Pablo Jofré</a> y <a class="underline" href="https://www.linkedin.com/in/nateare/">Nicolás Teare</a> como devs. 3/4 están en el ranking de los <a href="https://commits.top/chile_private.html" class="underline">programadores más activos de Chile</a>.
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
      showFintual: false,
      showPercentile: false,
      showExperience: false,
      showSummaryButton: false,
      cityTripsFinished: false,
      showBeforeEnding: false,
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
        return 'No te subiste a ningún Uber este año. O si lo hiciste no pagaste 🐀.'
      } else if (this.uber < 250000) {
        return 'Fuiste a varias fiestas clandestinas 🤫.'
      } else {
        return ''
      }
    },

    cityTripsMessage2() {
      const uberText = this.uber.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,')
      if (this.uber == 0) {
        return 'No te subiste a ningún Uber este año. O si lo hiciste no pagaste 🐀.'
      } else if (this.uber < 250000) {
        return `Viajaste harto en pandemia. Gastaste $${uberText} CLP en Uber 🚗.`
      } else if (this.uber < 500000) {
        let extendMessage = '';
        if (this.rappi > 50000 || this.uber_eats > 50000) {
          extendMessage = '...Si ya sabemos que comida no te falto 🤭.';
        }
        return `Se te fueron $${uberText} CLP en Uber 🚗. ¿Por qué tanto? ${extendMessage}`
      } else {
        return `¿Cómo gastaste $${uberText} CLP en Uber 🤯.`
      }
    },

    rappiOverUberText() {
      if (this.rappi > this.uber_eats) {
        const value = this.uber_eats !== 0 ? (this.rappi / this.uber_eats).toFixed(1) : 'infinitas';
        return `Te gusta más Rappi que UberEats. De hecho te gusta ${value} veces más.`
      } else if (this.rappi < this.uber_eats) {
        const value = this.rappi !== 0 ? (this.uber_eats / this.rappi).toFixed(1) : 'infinitas';
        return `Prefieres UberEats sobre Rappi. De hecho lo prefieres ${value} veces más.`
      } else {
        return 'Te gusta Rappi y UberEats ...por igual? Bueno, sigamos.';
      }
    },

    finalMessage() {
      return `El total que gastaste fue de $${this.deliveryExpenses.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,')} CLP 💸. Si hubieses invertido esto en fondos mutuos hoy esta plata sumaría $${this.savings.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,')} CLP 📈.`
    },

    percentileSummaryMessage() {
      let percentileMessage = '';
      const { rappi, uber, uber_eats} = this.percentiles;
      if (this.rappi > 0) {
        if (rappi < 0.1) {
          percentileMessage += `Estás en el ${(rappi*100).toFixed(1)}% que menos gasta en Rappi. `
        } else if (rappi < 0.5) {
          percentileMessage += `Estás en el ${(rappi*100).toFixed(1)}% que menos gasta en Rappi. `
        } else if (rappi < 0.85) {
          percentileMessage += `Estás sobre el ${(rappi*100).toFixed(1)}% que más gasta en Rappi. `
        } else {
          percentileMessage += `Estás sobre el ${(rappi*100).toFixed(1)}% que más gasta en Rappi. `
        }
      }

      if (this.uber_eats > 0) {
        if (uber_eats < 0.1) {
          percentileMessage += `Estás en el ${(uber_eats*100).toFixed(1)}% que menos gasta en UberEats. `
        } else if (rappi < 0.5) {
          percentileMessage += `Estás en el ${(uber_eats*100).toFixed(1)}% que menos gasta en UberEats. `
        } else if (uber < 0.85) {
          percentileMessage += `Estás sobre el ${(uber_eats*100).toFixed(1)}% que más gasta en UberEats. `
        } else {
          percentileMessage += `Estás sobre el ${(uber_eats*100).toFixed(1)}% que más gasta en UberEats. `
        }
      }

      if ((this.rappi === 0 && this.uber_eats === 0) || (rappi < 0.1 && uber_eats < 0.1)) {
        percentileMessage +=  'Eres bueno ahorrando! 🥳 '
      } else {
        if (this.rappi > 0 || this.uber_eats > 0) {
          if (rappi <= 0.1 && uber_eats <= 0.1) {
            percentileMessage +=  'Eres güeeeno ahorrando! 🥳 '
          } else if ((rappi > 0.1 && rappi <= 0.5) || (uber_eats > 0.1 && uber_eats <= 0.5)) {
            percentileMessage +=  'Podrías aprender a cocinar y ahorrarías harto 👩‍🍳🧑‍🍳.'
          } else if ((rappi > 0.5 && rappi <= 0.85) || (uber_eats > 0.5 && uber_eats <= 0.85)) {
            percentileMessage +=  'Podrías pagarte clases de cocina 😧.'
          } else {
            percentileMessage += '... Si se cae Rappi o UberEats es por tu culpa'
          }
        }
      }

      if (this.uber > 0) {
        percentileMessage += 'También encontré que'
        if (uber < 0.1) {
          percentileMessage += ` casi no usas Uber 🚙. Estás en el ${(uber*100).toFixed(1)}% que menos gasta en Uber.`
        } else if (rappi < 0.5) {
          percentileMessage += ` estás en el ${(uber*100).toFixed(1)}% que menos gasta en Uber.`
        } else if (uber < 0.85) {
          percentileMessage += `... Estás sobre el ${(uber*100).toFixed(1)}% que mas gasta en Uber. `
        } else {
          percentileMessage += `...🤯  te sale más barato viajar en 🛩. Estás sobre el ${(uber*100).toFixed(1)}% que más gasta en Uber. `
        }
      }
      return percentileMessage;
    },

    deliveryExpenses() {
      const { rappi, uber_eats, uber } = this.results.expenses;
      this.rappi = -rappi;
      this.uber_eats = -uber_eats;
      this.uber = -uber;
      return -rappi + -uber_eats + -uber;
    },

    savings() {
      const { rappi, uber_eats, uber } = this.results.investment;
      return rappi + uber_eats + uber;
    },

    percentiles() {
      return this.results.percentiles;
    }
  },
  methods: {
    finishLastDialog(){
      window.scrollTo(0, document.body.scrollHeight || document.documentElement.scrollHeight);
      this.showPercentile = true;
    },

    showFintualChange() {
      window.scrollTo(0, document.body.scrollHeight || document.documentElement.scrollHeight);
      this.showFintual = true;
    },

    showButton() {
      window.scrollTo(0, document.body.scrollHeight || document.documentElement.scrollHeight);
      this.showSummaryButton = true
    },

    finishCityTrips(){
      window.scrollTo(0, document.body.scrollHeight || document.documentElement.scrollHeight);
      this.showBeforeEnding = true;
    },

    goToEnding() {
      window.scrollTo(0, document.body.scrollHeight || document.documentElement.scrollHeight);
      this.cityTripsFinished = true;
    },

    finishRappiOverUber() {
      window.scrollTo(0, document.body.scrollHeight || document.documentElement.scrollHeight);
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
      window.scrollTo(0, document.body.scrollHeight || document.documentElement.scrollHeight);
      this.finished = true;
    },
  },
};
</script>

<style scoped>
</style>
