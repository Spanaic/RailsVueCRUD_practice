import Vue from "vue";
import VueCurdComponent from "../vue_curd_component.vue";

document.addEventListener("DOMContentLoaded", () => {
  const app = new Vue({
    render: (h) => h(VueCurdComponent),
  }).$mount();
  document.getElementById("root").appendChild(app.$el);
});
