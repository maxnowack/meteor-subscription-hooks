@SubscriptionHooks = {} unless @SubscriptionHooks?

@SubscriptionHooks._triggers =
  ready: []
  error: []

@SubscriptionHooks._subscriptions = {}

@SubscriptionHooks.init = ->
  @_orig_subscribe = Meteor.subscribe
  Meteor.subscribe = @subscribe

@SubscriptionHooks.subscribe = ->
  params = Array.prototype.slice.call arguments
  params.push
    onReady: SubscriptionHooks._triggerReady
    onError: SubscriptionHooks._triggerError
  name = params[0]

  subscription = SubscriptionHooks._orig_subscribe.apply Meteor, params
  SubscriptionHooks._subscriptions[name] =
    subscription: subscription
    ready: false
    error: false

  subscription: subscription
  onReady: (callback) ->
    SubscriptionHooks._triggers.ready.push
      name: name
      callback: callback
    callback.apply subscription if SubscriptionHooks._subscriptions[name].ready
  onError: (callback) ->
    SubscriptionHooks._triggers.error.push
      name: name
      callback: callback
    callback.apply subscription if SubscriptionHooks._subscriptions[name].error

@SubscriptionHooks._triggerReady = ->
  SubscriptionHooks._subscriptions[@name].ready = true
  for obj in SubscriptionHooks._triggers.ready when obj.name is @name
    obj.callback.apply @

@SubscriptionHooks._triggerError = ->
  SubscriptionHooks._subscriptions[@name].error = true
  for obj in SubscriptionHooks._triggers.error when obj.name is @name
    obj.callback.apply @

@SubscriptionHooks.init()
