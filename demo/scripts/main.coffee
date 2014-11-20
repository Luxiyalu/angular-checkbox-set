define ['jquery', 'angular', 'angularCheckboxSet'], ($, angular) ->
  app = angular.module 'mainModule', ['luxiyalu.checkboxSet']
  app.controller 'appCtrl', ($scope, checkboxHooks) ->
    $scope.grandParent = {identity: 'gp'}
    $scope.parents = [{identity: 'p1'}, {identity: 'p2'}]
    $scope.childrenA = [{identity: 'ca1'}, {identity: 'ca2'}, {identity: 'ca3'}]
    $scope.childrenB = [{identity: 'cb1'}, {identity: 'cb2'}]
