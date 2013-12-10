'use strict'

angular.module('ratewatchApp')
  .controller 'MainCtrl', ['$scope', 'exchangeFilter', ($scope, exchangeFilter) ->
    toRMB = (arr) ->
      ['RMB', RATES[arr[0]]['RMB'] * arr[1]]
    diffByRMB = (arr1, arr2) ->
      arr1 = toRMB(arr1)
      arr2 = toRMB(arr2)
      arr1[1] - arr2[1]

    $scope.calculateDiffRate = ->
      for name, exchange of $scope.exchanges
        selected = exchange if exchange.selected

      return unless selected
      for exchangeName in $scope.exchangeNames
        exchange = $scope.exchanges[exchangeName]
        exchange.diffRate = if exchangeName isnt selected.name
          diff = diffByRMB(exchange.last, selected.last)
          Math.round(diff * 10000 / toRMB(selected.last)[1]) / 100 + '%, ' + exchangeFilter(['RMB', diff], $scope.currency)
        else
          ""

    $scope.select = (selectedName) ->
      selected = $scope.exchanges[selectedName]
      for exchangeName in $scope.exchangeNames
        $scope.exchanges[exchangeName].selected = (selectedName == exchangeName)

      $scope.calculateDiffRate(selected)

    $scope.exchangeNames = ['btcchina', 'okcoin', 'mtgox', 'bitstamp', 'btc-e']
    $scope.exchanges = {}
    $scope.exchanges[name] = {} for name in $scope.exchangeNames
    $scope.currency = 'RMB'
    $scope.currentRate = ->
      "RMB/" + $scope.currency + " " + Math.round(100/RATES['RMB'][$scope.currency]) / 100 unless $scope.currency is 'RMB'
    $scope.$watch('currency', ->
      $scope.calculateDiffRate()
    )
  ]
