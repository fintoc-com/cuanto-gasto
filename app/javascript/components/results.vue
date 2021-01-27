<template>
  <div>
    <div class="container max-w-xl mx-auto flex flex-col items-center justify-center my-6" v-show="!showPressKit">
      <div class="mt-4 sm:mt-12 w-full flex flex-col" v-if="!finished">
        <vue-typed-js
          @onComplete="changeToShowExperience"
          :showCursor="false"
          :backSpeed="40"
          :typeSpeed="35"
          :smartBackspace="true"
          :strings="['Ya terminamos de procesar tus gastos. Veamos cómo estuvo el 2020. 🧐']"
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
            v-if="showBeforeEnding"
            :showCursor="false"
            @onComplete="goToEnding"
            :startDelay="2000"
            :backDelay="1000"
            :backSpeed="40"
            :typeSpeed="35"
            :smartBackspace="true"
            :strings="['Entonces... que aprendimos hoy 🔍']"
          >
            <h2 class="mt-6 typing inline font-mono"></h2>
          </vue-typed-js>

          <vue-typed-js
            v-if="isSmallExpenseExperience && cityTripsFinished"
            :showCursor="false"
            @onComplete="finishLastDialog"
            :startDelay="2000"
            :backDelay="1000"
            :backSpeed="40"
            :typeSpeed="35"
            :smartBackspace="true"
            :strings="['Este año no gastaste mucho en delivery. No debes tener mucha plata. 😅', `Este año no gastaste mucho en delivery. Eres un buen administrador. 🤭 Estimo que pides delivery 1-2 veces por semana. 💸 `]"
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
            :strings="[`De verdad te guuuuusta el delivery ah! 🐽 Bueno no te culpo, pandemia y todo eso. 🤭 Estimo que pides delivery 3-4 veces por semana. 😅`]"
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
            :strings="['Este año no gastaste mucho en Delivery. 😃', `Este año gastaste muuuuuuuuuuuuchisimo en Delivery. 😆 Demasiado. Estás bien? Se te pasó la mano. Deberias considerar tomar clases de cocina. Tus números me dicen que pides delivery 4 veces por semana.`]"
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
            :strings="['No, estos números no me cuadran debe haber un problema 😐. Es imposible lo que veo.', `Acabo de revisar y el problema eres tú. Soy un robot solamente 🤖, pero deberías pedir ayuda. Pides Delivery casi todos los días.`]"
          >
            <h2 class="mt-6 typing inline font-mono"></h2>
          </vue-typed-js>

          <vue-typed-js
            v-if="showFintual"
            :showCursor="false"
            @onComplete="showButton"
            :startDelay="2000"
            :backDelay="1000"
            :backSpeed="40"
            :typeSpeed="35"
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
          class="mt-4 group self-end relative py-2 px-4 border font-mono
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
      showFintual: false,
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
        return 'No te subiste a ningún Uber este año. O si lo hiciste no pagaste. 🤨'
      } else if (this.uber < 250000) {
        return 'Que? Pero que veo acá, en serio? 👀  Al parecer también fuiste a muchas fiestas clandestinas. 🤫'
      } else {
        return '... 😐  En serio? Gastaste todo esto en Uber?'
      }
    },

    cityTripsMessage2() {
      const uberText = this.uber.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,')
      if (this.uber == 0) {
        return 'No te subiste a ningún Uber este año. O si lo hiciste no pagaste. 🤨'
      } else if (this.uber < 250000) {
        return `Que? Pero que veo acá, en serio? 👀  Al parecer viajabas harto en pandemia. 🚗 Gastaste $${uberText} CLP en Uber.`
      } else if (this.uber < 500000) {
        let extendMessage = 'A comprar comida supongo 👀 por que no pediste mucho a la casa.';
        if (this.rappi > 50000 || this.uber_eats > 50000) {
          extendMessage = '...Si ya sabemos que comida no te falto 🤭';
        }
        return `... 😐  En serio? Gastaste todo esto en Uber? Tú si que te moviste por la ciudad. 🚗 Gastaste $${uberText} CLP en Uber. 💸  A donde viajabas tanto? ${extendMessage}`
      } else {
        return `... Creo que estoy funcionando mal. 😐 Puedes avisarle a mis creadores? Por que no encuentro explicacion a esto. Viajaste a Argentina o que, como gastaste $${uberText} CLP en Uber 🤯`
      }
    },

    rappiOverUberText() {
      if (this.rappi > this.uber_eats) {
        const value = this.uber_eats !== 0 ? (this.rappi / this.uber_eats).toFixed(1) : 'infinitas';
        return `Veamos... Mi cerebro artificial 🤖 dice que te gusta más Rappi que UberEats. De hecho te gusta ${value} veces más. Que tienes con Rappi? 🤨  Estás bien?`
      } else if (this.rappi < this.uber_eats) {
        const value = this.rappi !== 0 ? (this.uber_eats / this.rappi).toFixed(1) : 'infinitas';
        return `Veamos... Mi cerebro artificial 🤖 dice que prefieres UberEats sobre Rappi. De hecho lo prefieres ${value} veces más. Que tienes con UberEats? 🤨  Estás bien?`
      } else {
        return 'Veamos... Mi cerebro artificial 🤖  dice que te gusta Rappi y UberEats ...por igual? 😱 ...Esto significa que eres igual de malo ahorrando en ambas plataformas 🤭 Bueno, sigamos.';
      }
    },

    finalMessage() {
      let percentileMessage = '';
      const { rappi, uber, uber_eats} = this.percentiles;
      // const { rappi, uber, uber_eats} = { rappi: 0.51, uber: 0.9, uber_eats: 0.1};
      if (this.rappi > 0) {
        if (rappi < 0.1) {
          percentileMessage += `Estás en el ${rappi*100}% que menos gasta en Rappi.`
        } else if (rappi < 0.5) {
          percentileMessage += `Estás en el ${rappi*100}% que menos gasta en Rappi.`
        } else if (rappi < 0.85) {
          percentileMessage += `Estás sobre el ${rappi*100}% que mas gasta en Rappi.`
        } else {
          percentileMessage += `Estás sobre el ${rappi*100}% que mas gasta en Rappi.`
        }
      }

      if (this.uber_eats > 0) {
        if (uber_eats < 0.1) {
          percentileMessage += `Estás en el ${uber_eats*100}% que menos gasta en UberEats.`
        } else if (rappi < 0.5) {
          percentileMessage += `Estás en el ${uber_eats*100}% que menos gasta en UberEats.`
        } else if (uber < 0.85) {
          percentileMessage += `Estás sobre el ${uber_eats*100}% que mas gasta en UberEats.`
        } else {
          percentileMessage += `Estás sobre el ${uber_eats*100}% que mas gasta en UberEats.`
        }
      }

      if ((this.rappi === 0 && this.uber_eats === 0) || (rappi < 0.1 && uber_eats < 0.1)) {
        percentileMessage +=  'Eres bueno ahorrando! 🥳'
      } else {
        if (this.rappi > 0 || this.uber_eats > 0) {
          if (rappi <= 0.1 && uber_eats <= 0.1) {
            percentileMessage +=  'Eres bueno ahorrando! 🥳'
          } else if ((rappi > 0.1 && rappi <= 0.5) || (uber_eats > 0.1 && uber_eats <= 0.5)) {
            percentileMessage +=  'Podrías aprender a cocinar y ahorrarias bastante. 👩‍🍳🧑‍🍳'
          } else if ((rappi > 0.5 && rappi <= 0.85) || (uber_eats > 0.5 && uber_eats <= 0.85)) {
            percentileMessage +=  '😧 Podrias hasta pagarte clases de cocina.'
          } else {
            percentileMessage += '... 🤯  Cada vez que me salga que Rappi o UberEats estan con mucha demanda, te voy a echar la culpa. 😖'
          }
        }
      }

      if (this.uber > 0) {
        percentileMessage += 'También encontre que'
        if (uber < 0.1) {
          percentileMessage += ` con suerte usar uber. 🚙 Estás en el ${uber*100}% que menos gasta en Uber.`
        } else if (rappi < 0.5) {
          percentileMessage += ` estás en el ${uber*100}% que menos gasta en Uber. 🚗 A donde viajabas tanto en pandemia? 🤨`
        } else if (uber < 0.85) {
          percentileMessage += `... omitire comentarios. 🚗  Estás sobre el ${uber*100}% que mas gasta en Uber. `
        } else {
          percentileMessage += `...🤯  Creo que te salía más barato viajar en 🚐 o 🛩. Estás sobre el ${uber*100}% que mas gasta en Uber. `
        }
      }

      const fintualMessage = `El total que gastaste fue de $${this.deliveryExpenses.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,')} CLP. 💸  Si hubieses invertido esto en fondos mutuos hoy esta plata sumaría $${this.savings.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,')} CLP. 📈`
      return `${percentileMessage} \n ${fintualMessage}`
    },

    deliveryExpenses() {
      const { rappi, uber_eats, uber } = this.results.expenses;
      // const { rappi, uber_eats, uber } = { rappi: -450000, uber_eats: -500000, uber: -750000 };
      this.rappi = -rappi;
      this.uber_eats = -uber_eats;
      this.uber = -uber;
      return -rappi + -uber_eats + -uber;
    },

    savings() {
      const { rappi, uber_eats, uber } = this.results.investment;
      // const { rappi, uber_eats, uber } = { rappi: 490000, uber_eats: 550000, uber: 250000 };
      return rappi + uber_eats + uber;
    },

    percentiles() {
      return this.results.percentiles;
    }
  },
  methods: {
    finishLastDialog(){
      this.showFintual = true;
    },

    showButton() {
      this.showSummaryButton = true
    },

    finishCityTrips(){
      this.showBeforeEnding = true;
    },

    goToEnding() {
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
