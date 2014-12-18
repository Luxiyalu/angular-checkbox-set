angular-checkbox-set
====================
Angular directive, with recursive support for multiple layers of checkboxes.

1. The `checked` status would be stored in a unique object for each checkbox. This attribute is mandatory.
2. The `hook` and `hooked-to` attributes are optional. `hook` act as a hook, `hooked-to` hook the checkbox to the filled-in hook.
3. A checkbox could have both `hook` and `hooked-to` attributes, which means:
4. You could have as many levels of checkboxes as you like.
5. No need to initialise all the checkboxes at the same time: you could put children checkboxes inside `ng-if`s and when they come into existence, they'll automatically follow the status of their parent.

### Install
```command
$ bower install angular-checkbox-set
```

### Directive Attributes
1. `hook`, string. **Notice the single quote within double quote!**
2. `hooked-to`, string. Same as above.
3. `status-stored-in`, scope object.

### Code Example
```html
<!-- provide a hook string for its children -->
<!-- gpObj will have a property "checked", its value would be boolean -->
<checkbox hook="'grandParent'" status-stored-in="gpObj"></checkbox>

<!-- since these two are hooked to 'grandParent' -->
<!-- 1. checking parentA would auto check these two -->
<!-- 2. unchecking parentA would auto uncheck these two -->
<!-- 3. unchecking either of these would uncheck their hook 'grandParent' -->
<!-- 4. if these two are checked, their hook 'grandParent' would be checked -->
<checkbox hook="'parentA'" hooked-to="'grandParent'" status-stored-in="pObjA"></checkbox>
<checkbox hook="'parentB'" hooked-to="'grandParent'" status-stored-in="pObjB"></checkbox>

<!-- you could link the hooks recursively, and they don't have to be placed in a inherited structure in html -->
<checkbox hooked-to="'parentA'" status-stored-in="cObjA1"></checkbox>
<checkbox hooked-to="'parentA'" status-stored-in="cObjA2"></checkbox>
```

See it in action [here](http://luxiyalu.com/playground/checkbox/).
