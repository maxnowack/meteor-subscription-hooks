Package.describe({
  name: 'maxnowack:subscription-hooks',
  summary: 'Meteor package for adding multiple callbacks to a subscription',
  version: '0.2.0',
  git: 'https://github.com/maxnowack/meteor-subscription-hooks'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0.2.1');
  api.use('coffeescript')
  api.addFiles('maxnowack:subscription-hooks.coffee');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('maxnowack:subscription-hooks');
  api.addFiles('maxnowack:subscription-hooks-tests.coffee');
});
