angular.module('ratewatchServices', []).factory('DataProcessor', ->
  processExchange: (exchange) ->
    for attr in ['last', 'sell', 'buy', 'high', 'low']
      currency = if exchange.name in ['mtgox', 'btc-e', 'bitstamp'] then 'USD' else 'RMB'
      exchange[attr] = [currency, exchange[attr]]
    now = new Date().getTime()
    timestamp = new Date(exchange.time ? exchange.created_at).getTime()
    exchange.seconds  = Math.round((now - timestamp)/1000)
    exchange.vol = Math.round(exchange.vol)
    exchange.spread = Math.round((exchange.sell[1] - exchange.buy[1]) * 10000 / exchange.buy[1]) / 100
    exchange
)
