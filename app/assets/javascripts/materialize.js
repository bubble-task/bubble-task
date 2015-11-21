var setupMaterialize = function() {
  var d = new $.Deferred;

  Materialize.updateTextFields();
  Waves.displayEffect();
  $('.dropdown-button').dropdown();
  $('.tooltipped').tooltip({delay: 0});
  $('.button-collapse').sideNav();
  //$('.button-collapse').sideNav({ menuWidth: 90 });

  d.resolve();
  return d.promise();
};