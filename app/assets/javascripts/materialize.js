var setupMaterialize = function() {
  var d = new $.Deferred;

  Waves.displayEffect();
  $('.dropdown-button').dropdown();
  $('.tooltipped').tooltip({delay: 0});
  $('.button-collapse').sideNav({ menuWidth: 240 });

  d.resolve();
  return d.promise();
};
