angular.module('ratewatchApp')
  .directive 'tickerExchange', ['$timeout', '$http', 'DataProcessor', 'exchangeFilter', ($timeout, $http, DataProcessor, exchangeFilter) ->
    link = ($scope, $element, $attrs) ->
      timeoutId = null

      $scope.urls =
        okcoin: 'https://www.okcoin.com'
        btcchina: 'https://vip.btcchina.com'
        mtgox: 'https://www.mtgox.com'
        bitstamp: 'https://www.bitstamp.net'
        "btc-e": 'https://www.btc-e.com'
        chbtc: 'https://www.chbtc.com'

      updateData = ->
        timeoutId = $timeout ->
          $http.get("http://api.7pm.at/rate/#{$scope.exchangeName}/#{$scope.currencyType}")
          .success (data) ->
            selected = $scope.exchange?.selected
            $scope.exchanges[data.name] = $scope.exchange = DataProcessor.processExchange(data)
            $scope.exchange.selected = selected
            $scope.$parent.calculateDiffRate($scope.currencyType)
          .finally =>
            updateData()
        , 3000


      $element.on '$destroy', ->
        $timeout.cancel timeoutId

      updateData()


    restrict: 'A'
    link: link
    scope:
      exchangeName: '@tickerExchange'
      exchanges: '='
      currency: '@'
      currencyType: '@'
    template: "
      <td>{{exchange.diffRate}}</td>
      <td><a href='{{urls[exchangeName]}}'>{{exchangeName}}</a></td>
      <td>{{exchange.last | exchange:currency}}</td>
      <td>{{exchange.spread}}</td>
      <td>{{exchange.sell | exchange:currency}}</td>
      <td>{{exchange.buy | exchange:currency}}</td>
      <td>{{exchange.high | exchange:currency}}</td>
      <td>{{exchange.low | exchange:currency}}</td>
      <td>{{exchange.vol}}</td>
      <td>{{exchange.seconds}}</td>
    "
  ]
