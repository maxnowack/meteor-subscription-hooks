scaffoldTest = (publish, callback) ->
  TestCollection = new Mongo.Collection null
  if Meteor.isServer
    Meteor.publish publish, ->
      TestCollection.find()
  if Meteor.isClient
    callback()

Tinytest.add 'SubscriptionHooks - simple onReady', (test) ->
  scaffoldTest 'test', ->
    subscription = Meteor.subscribe 'test'
    subscription.onReady ->
      test.isTrue true, 'test passed'

Tinytest.add 'SubscriptionHooks - fire callback after onReady', (test) ->
  scaffoldTest 'test2', ->
    subscription = Meteor.subscribe 'test2'
    subscription.onReady ->
      subscription.onReady ->
        test.isTrue true, 'test passed'
