angular.module('ratewatchApp')
  .filter('exchange', ->
    (input, code = 'RMB') ->
      return unless input && input[1]

      symbols =
        'USD': '$'
        'RMB': '¥'
        'CAD': '$'
        'EUR': '€'
        'GBP': '£'
        'BTC': '฿'
        'LTC': 'Ł'
      res = input[1] * RATES[input[0]][code]
      "#{symbols[code]} #{Math.round(res*100)/100}"
  )
