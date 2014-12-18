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
  templateUrl: 'templates/checkbox.html'
  link: ($scope, element, attr) ->
    self = {}
    hook = $scope.hook
    hookedTo = $scope.hookedTo
    statusObj = $scope.statusStoredIn
    statusObj.checked = false
    
    if hookedTo?  # parentCheckboxHooks
      # if my parent already exists, check its status, follow its status
      # and broadcast my status to my potential children at the end
      # (my scope toggleCheck hasn't been defined yet)
      if checkboxHooks[hookedTo]?
        pcb = checkboxHooks[hookedTo]
        statusObj.checked = pcb.scope.statusStoredIn.checked
      else
        pcb = checkboxHooks[hookedTo] = {}
        
      self.scope = $scope
      self.parent = hookedTo
      self.statusObj = statusObj
      
      pcb.children ?= []
      pcb.children.push(self)
        
    if hook?  # childrenCheckboxHooks, this is the object
      self = checkboxHooks[hook] ?= {}
      self.scope ?= $scope
      self.parent = hookedTo
      
      # as a parent, have an api to check if all its children is
      # of a certain state. If they're all checked, check itself.
      $scope.checkIfAll = (state) ->
        result = self.children.every (e, i, a) ->
          e.statusObj.checked is state
        
    $scope.toggleCheck = (specify, direction) ->
      statusObj.checked =if specify? then specify else !statusObj.checked
      # if specify exists then this is not user action
      if !specify? then broadcastUpdate(); emitUpdate()
      else if direction is 'broadcast' then broadcastUpdate()
      else if direction is 'emit' then emitUpdate()
      
    # everything below me should update their status to my status
    broadcastUpdate = ->
      return if !self?.children?
      for child in self.children
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
        
    if hook?
      # if I have children before I even initialised, broadcast my status down
      $scope.toggleCheck(statusObj.checked, 'broadcast')
      # recycle my position in checkboxHooks if I'm destroyed
      $scope.$on '$destroy', -> delete checkboxHooks[hook]