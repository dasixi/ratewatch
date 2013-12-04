angular.module('ratewatchServices', []).factory('DataProcessor', ->
  processExchange: (exchange) ->
    if exchange.name in ['mtgox', 'btc-e', 'bitstamp']
      for attr in ['last', 'sell', 'buy', 'high', 'low']
        exchange[attr] = Math.round(exchange[attr] * 610)/100
    now = new Date().getTime()
    timestamp = new Date(exchange.time ? exchange.created_at).getTime()
    exchange.seconds  = Math.round((now - timestamp)/1000)
    exchange.vol = Math.round(exchange.vol)
    exchange
)
