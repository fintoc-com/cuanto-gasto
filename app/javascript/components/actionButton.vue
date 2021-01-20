<template>
  <button
    type="submit"
    class="group relative w-full flex justify-center py-4 px-4 border
           border-transparent text-sm leading-5 font-medium rounded-md
           text-white fintoc-blue focus:outline-none transition duration-150
           ease-in-out"
    :class="{ 'hover:opacity-50': !invalidForm, 'cursor-not-allowed': invalidForm }"
  >
  </button>
</template>

<script>
export default {
  props: {
    hasLockIcon: Boolean,
    invalidForm: Boolean,
  },
};
</script>
