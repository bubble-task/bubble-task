var setupDatepicker = function() {
  var d = new $.Deferred;

  $('.datepicker').pickadate({
    hiddenSuffix: '',
    showWeekdaysShort: true,
    selectMonths: true,
    selectYears: 10
  });

  d.resolve();
  return d.promise();
};
