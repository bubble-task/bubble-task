// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require materialize-sprockets
//= require jquery-tags-input
//= require gravtastic
//= require datepicker-ja
//= require turbolinks
//= require_tree .

Turbolinks.enableProgressBar();

$(document).on('ready page:load', function() {
  setupDatepicker();

  $('.task_completion').change(function() {
    $(this).parent().submit();
  });
  $('.sign_up').on('ajax:beforeSend', function() {
    $(this).tooltip('remove');
  });
});

$(document).on('page:change', function() {
  setupMaterialize()
    .then(function() { setupForm(); })
    .then(function() { setupTagsInput(); });
});
