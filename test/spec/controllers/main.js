// Generated by CoffeeScript 1.3.3
'use strict';

describe('Controller: MainCtrl', function() {
  var MainCtrl, scope;
  beforeEach(module('ratewatchApp'));
  MainCtrl = {};
  scope = {};
  beforeEach(inject(function($controller, $rootScope) {
    scope = $rootScope.$new();
    return MainCtrl = $controller('MainCtrl', {
      $scope: scope
    });
  }));
  return it('should attach a list of awesomeThings to the scope', function() {
    return expect(1).toBe(1);
  });
});