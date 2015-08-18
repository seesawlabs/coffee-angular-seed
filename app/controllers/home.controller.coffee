'use strict'

do ->
  class HomeCtrl
    @$inject: []
    constructor: ()->
      console.log 'blah'
      return

  angular.module 'app'
    .controller 'HomeCtrl', HomeCtrl