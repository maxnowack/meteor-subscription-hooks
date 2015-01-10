@SubscriptionHooks = {} unless @SubscriptionHooks?

@SubscriptionHooks._triggers =
  ready: []
  error: []

@SubscriptionHooks.init = ->
  @_orig_subscribe = Meteor.subscribe
  Meteor.subscribe = @subscribe

@SubscriptionHooks.subscribe = ->
  params = Array.prototype.slice.call arguments
  params.push
    onReady: SubscriptionHooks._triggerReady
    onError: SubscriptionHooks._triggerError
  name = params[0]

  subscription: SubscriptionHooks._orig_subscribe.apply Meteor, params
  onReady: (callback) ->
    SubscriptionHooks._triggers.ready.push
      name: name
      callback: callback
  onError: (callback) ->
    SubscriptionHooks._triggers.error.push
      name: name
      callback: callback

@SubscriptionHooks._triggerReady = ->
  for obj in SubscriptionHooks._triggers.ready when obj.name is @name
    obj.callback.apply @

@SubscriptionHooks._triggerError = ->
  for obj in SubscriptionHooks._triggers.error when obj.name is @name
    obj.callback.apply @

@SubscriptionHooks.init()
