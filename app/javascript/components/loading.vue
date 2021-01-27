<template>
  <div class="bg-gray-100 min-h-screen">
    <div class="container max-w-xl mx-auto flex flex-col items-center justify-center px-2 py-6">
      <div class="mt-12 w-full">
        <vue-typed-js
          @onComplete="finishFirstParagraph"
          :showCursor="false"
          :backSpeed="50"
          :typeSpeed="40"
          :smartBackspace="true"
          :strings="['Estamos procesando tus pagos con tarjeta para calcular tus gastos. 🤖 beep boop']"
        >
          <h2 class="typing inline font-mono"></h2>
        </vue-typed-js>

        <vue-typed-js
          v-if="firstParagraphFinished"
          @onComplete="finishSecondParagraph"
          :showCursor="false"
          :backSpeed="50"
          :typeSpeed="40"
          :startDelay="3000"
          :smartBackspace="true"
          :strings="['Nos podemos demorar unos segundos 🕗', 'Nos podemos demorar unos minutos 🕔, puedes ir a hacerte un café por mientras. ☕️']"
        >
          <h2 class="mt-6 typing font-mono"></h2>
        </vue-typed-js>

        <vue-typed-js
          v-if="secondParagraphFinished"
          @onComplete="finishThirdParagraph"
          :showCursor="false"
          :startDelay="3000"
          :backSpeed="50"
          :typeSpeed="40"
          :smartBackspace="true"
          :strings="['Ok, nos está tomando un poco más 😅', 'Ok, nos está tomando más de lo que pensabamos. 😐']"
        >
          <h2 class="mt-6 typing font-mono"></h2>
        </vue-typed-js>


        <vue-typed-js
          v-if="thirdParagraphFinished"
          @onComplete="finishSecondParagraph"
          :loop="true"
          :startDelay="3000"
          :backDelay="3000"
          :showCursor="false"
          :backSpeed="50"
          :typeSpeed="40"
          :smartBackspace="true"
          :strings="['No te hemos abandonado, seguimos trabajando. 🚧',
                     'Paciencia.',
                     '¿Quizás otro café? ☕️',
                     'Ya estamos casí. ',
                     '¿Sabías que la Universidad de Oxford es más antigua que la cultura Azteca? 😱',
                     '¿Sabías que el elefante es el único animal del mundo con 4 rodillas? 😱',
                     '¿Sabías que Fintoc nacio en marzo del 2020? 😏',
                     'Estamos haciendo calculos muy complicados. 🧮 beep boop. 🤖',
                     'Me quedo sin ideas, pero probablemente falta muy poco. 🕞'
                     ]"
        >
          <h2 class="mt-6 typing font-mono"></h2>
        </vue-typed-js>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      firstParagraphFinished: false,
      secondParagraphFinished: false,
      thirdParagraphFinished: false,
    };
  },
  methods: {
    finishFirstParagraph() {
      this.firstParagraphFinished = true;
    },

    finishSecondParagraph() {
      this.secondParagraphFinished = true;
    },

    finishThirdParagraph() {
      this.thirdParagraphFinished = true;
    }
  }
};
</script>

<style scoped>
</style>
