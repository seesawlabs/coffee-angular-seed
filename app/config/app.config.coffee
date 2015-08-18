'use strict'

do ->
  appConfig = ($stateProvider)->
    $stateProvider
      .state 'root',
        url: '/'
        templateUrl: 'templates/layout.view.html'
        abstract: true

      .state 'root.home',
        url: 'home'
        templateUrl: 'templates/home.view.html'
        controller: 'HomeCtrl as ctrl'
    return

  appConfig.$inject = ['$stateProvider']


  routesConfig = ($urlRouterProvider, $locationProvider)->
    $urlRouterProvider.otherwise('home')

    $locationProvider.html5Mode
      enabled: false
      requireBase: false

    return

  routesConfig.$inject = ['$urlRouterProvider', '$locationProvider']

  angular.module 'app'
    .config routesConfig
    .config appConfig