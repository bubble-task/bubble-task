var setupDatepicker = function() {
  var d = new $.Deferred;

  $('.datepicker').pickadate({
    showWeekdaysShort: true,
    selectMonths: true,
    selectYears: 10
  });

  d.resolve();
  return d.promise();
};
