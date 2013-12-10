'use strict'

window.RATES =
  'USD':
    'USD': 1
    'RMB': 6.0579
    'CAD': 1.063728
    'EUR': 0.727426
    'GBP': 0.608241
  'RMB':
    'RMB': 1
    'USD': 0.16507
    'CAD': 0.17597
    'EUR': 0.12033
    'GBP': 0.10066


$( ->
  moment.lang('zh-CN')
  googleapis = '//ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=50&callback=?&q='
  url = 'http://blog.dasixi.com/rss.xml'
  $.getJSON(googleapis + encodeURIComponent(url)).then (res) ->
    entries = res.responseData.feed.entries
    content = ""
    $(entries).each (index, entry) ->
      content += "<div>
                    <h4>
                      <a href='#{entry.link}'>#{entry.title}</a>
                      <small>#{moment(entry.publishedDate).fromNow()}</small>
                    </h4>
                  </div>
                  <div class='text-muted'>#{entry.content}</div>
                 "
    $('#blog').empty().append(content)
)
#########################

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

