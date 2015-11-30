var setupForm = function() {
  var d = new $.Deferred;

  if ( $('form').length ) {
    Materialize.updateTextFields();
    $('.materialize-textarea').trigger('autoresize');
  }

  d.resolve();
  return d.promise();
};
