module = angular.module 'luxiyalu.checkboxSet', []

# make sure each checkbox has a unique name, since
# they'll depend on this to identify their parent/children
module.value 'checkboxHooks', {}

# if you don't want the check/uncheck status to remain
# after ng-view switch, clear the value checkboxes to {}
# upon entering pages.
module.directive 'checkbox', (checkboxHooks) ->
  restrict: 'E'
  scope:
    hook: '='
    hookedTo: '='
    statusStoredIn: '='
  template:
    '<div class="checkbox-outer" ng-click="toggleCheck()">' +
        '<div class="checkbox-inner" ng-show="statusStoredIn.checked"></div>' +
    '</div>'
  link: ($scope, element, attr) ->
    hook = $scope.hook
    hookedTo = $scope.hookedTo
    statusObj = $scope.statusStoredIn
    
    if hookedTo?  # parentCheckboxHooks
      pcb = checkboxHooks[hookedTo] ?= {}
      pcb.children ?= []
      pcb.children.push
        scope: $scope
        parent: hookedTo
        statusObj: statusObj
        
    if hook?  # childrenCheckboxHooks
      ccb = checkboxHooks[hook] ?= {}
      ccb.scope ?= $scope
      ccb.parent = hookedTo
      
      # as a parent, have an api to check if all its children is
      # of a certain state. If they're all checked, check itself.
      $scope.checkIfAll = (state) ->
        result = ccb.children.every (e, i, a) ->
          e.statusObj.checked is state
        
    $scope.toggleCheck = (specify, direction) ->
      statusObj.checked =if specify? then specify else !statusObj.checked
      # if specify exists then this is not user action
      if !specify? then broadcastUpdate(); emitUpdate()
      else if direction is 'broadcast' then broadcastUpdate()
      else if direction is 'emit' then emitUpdate()
      
    # everything below me should update their status to my status
    broadcastUpdate = ->
      return if !ccb?.children?
      for child in ccb.children
        child.scope.toggleCheck(statusObj.checked, 'broadcast')
      
    # everything above me:
    # if i'm unchecked, uncheck all the way up
    # if i'm checked, ask my parents to check. If its children (my siblings)
    #   are all checked, check my parent, then contunue emitting.
    emitUpdate = ->
      return if !hookedTo?
      if !statusObj.checked
        pcb.scope.toggleCheck(false, 'emit')
      else
        return if !pcb.scope.checkIfAll(true)
        pcb.scope.toggleCheck(true, 'emit')
