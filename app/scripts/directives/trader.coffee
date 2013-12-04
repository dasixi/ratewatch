angular.module('ratewatchApp')
  .directive 'tickerExchange', ['$timeout', '$http', 'DataProcessor', ($timeout, $http, DataProcessor) ->
    link = ($scope, $element, $attrs) ->
      timeoutId = null

      updateData = ->
        timeoutId = $timeout ->
          $http.get('http://api.7pm.at/rate/' + $scope.exchangeName)
          .success (data) ->
            selected = $scope.exchange?.selected
            $scope.exchanges[data.name] = $scope.exchange = DataProcessor.processExchange(data)
            $scope.exchange.selected = selected
            $scope.$parent.calculateDiffRate()
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
    template: "
      <td>{{exchange.diffRate}}</td>
      <td>{{exchangeName}}</td>
      <td>{{exchange.last}}</td>
      <td>{{exchange.sell}}</td>
      <td>{{exchange.buy}}</td>
      <td>{{exchange.high}}</td>
      <td>{{exchange.low}}</td>
      <td>{{exchange.vol}}</td>
      <td>{{exchange.seconds}}</td>
    "
  ]
