const mainComponent = {
  template: '#main'
}

var vm = new Vue({
  el: '#app',
  router: new VueRouter({
    routes: [
      { path: '/main', component: mainComponent },
      { path: '/example_one', component: anotherComponent }, // nother-component.js
      { path: '*', redirect: '/main'}
    ]
  }),
})


