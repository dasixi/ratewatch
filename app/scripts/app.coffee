'use strict'

angular.module('ratewatchApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'ratewatchServices'
])
  .config ['$routeProvider', ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'
  ]
