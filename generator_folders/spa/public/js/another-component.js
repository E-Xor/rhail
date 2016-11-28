const anotherComponent  = {
  template: '#another-component',

  data: function() { return { 
    peopleWithAddresses: {},
    name: '',
    city: '',
    state: '',
    zipcode: '',
    csrfToken: ''
  }},

  created: function() {
    this.callOnCreate()
  },

  methods: {
    getData: function() {
      var vm = this
      var res = {}

      axios.get('/api/example_one')
      .then(function(response) {
        vm.peopleWithAddresses = response.data
        vm.csrfToken = response.headers.csrf_token
      })
      .catch(function(error){
        console.log('ERROR in getData')
        console.log(error)
      })
    },

    sendData: function(event) {
      var vm = this
      event.preventDefault() // Otherwise browser will submit form too

      axios({
        method: 'post',
        url: '/api/example_two',
        data: {

          name: vm.name,
          city: vm.city,
          state: vm.state,
          zipcode: vm.zipcode

        },
        headers: {'CSRF-Token': vm.csrfToken}
      })
      .then(function(response) {

        // Clean the form
        vm.name = ''
        vm.city = ''
        vm.state = ''
        vm.zip = ''

        vm.getData()
      })
      .catch(function(error){
        console.log('ERROR in sendData')
        console.log(error)
      })
    },

    callOnCreate: function() {
      this.getData()
    }

  }
}

