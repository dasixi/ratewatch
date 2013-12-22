'use strict'

angular.module('ratewatchApp')
  .controller 'MainCtrl', ['$scope', 'exchangeFilter', ($scope, exchangeFilter) ->
    toRMB = (arr) ->
      ['RMB', RATES[arr[0]]['RMB'] * arr[1]]
    diffByRMB = (arr1, arr2) ->
      arr1 = toRMB(arr1)
      arr2 = toRMB(arr2)
      arr1[1] - arr2[1]

    $scope.calculateDiffRate = (type)->
      exchanges = $scope[type + 'Exchanges']
      names = $scope[type + 'ExchangeNames']

      selected = exchange for name, exchange of exchanges when exchange?.selected
      return unless selected

      for name in names
        exchange = exchanges[name]
        exchange.diffRate = if name isnt selected.name
          diff = diffByRMB(exchange.buy, selected.sell)
          Math.round(diff * 10000 / toRMB(selected.last)[1]) / 100 + '%, ' + exchangeFilter(['RMB', diff], $scope.currency)
        else
          ""

    $scope.select = (selectedName, type) ->
      exchanges = $scope[type + 'Exchanges']
      names = $scope[type + 'ExchangeNames']
      selected = exchanges[selectedName]

      for name in names
        exchanges[name].selected = (selectedName == name)

      $scope.calculateDiffRate(type)

    $scope.bitcoinExchangeNames = ['btcchina', 'okcoin', 'chbtc', 'mtgox', 'bitstamp', 'btc-e']
    $scope.bitcoinExchanges = {}
    $scope.bitcoinExchanges[name] = {} for name in $scope.bitcoinExchangeNames

    $scope.litecoinExchangeNames = ['okcoin', 'btc-e']
    $scope.litecoinExchanges = {}
    $scope.litecoinExchanges[name] = {} for name in $scope.litecoinExchangeNames

    $scope.currency = 'RMB'
    $scope.currentRate = ->
      "RMB/" + $scope.currency + " " + Math.round(100/RATES['RMB'][$scope.currency]) / 100 unless $scope.currency is 'RMB'
    $scope.$watch('currency', ->
      $scope.calculateDiffRate('bitcoin')
      $scope.calculateDiffRate('litecoin')
    )
  ]
