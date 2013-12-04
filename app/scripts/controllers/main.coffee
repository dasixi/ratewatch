'use strict'

angular.module('ratewatchApp')
  .controller 'MainCtrl', ['$scope', ($scope) ->
    notice = (msg) ->
      console.log 'begin notice'
      if (window.webkitNotifications.checkPermission() == 0)
        window.webkitNotifications.createNotification('icon.png', '$$$', msg)
      else
        window.webkitNotifications.requestPermission()
    notice('hi')

    $scope.calculateDiffRate = ->
      for name, exchange of $scope.exchanges
        selected = exchange if exchange.selected

      return unless selected
      for exchangeName in $scope.exchangeNames
        exchange = $scope.exchanges[exchangeName]
        exchange.diffRate = if exchangeName isnt selected.name
          Math.round((exchange.last - selected.last) * 10000 / selected.last) / 100 + '%, ￥' + Math.round(exchange.last - selected.last)
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

  ]
