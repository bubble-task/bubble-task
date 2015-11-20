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
//= require turbolinks
//= require_tree .

$(document).on('page:load page:change', function () {
  /*** Materialize ***/
  Waves.displayEffect();
  $('.dropdown-button').dropdown();
  $('.tooltipped').tooltip({delay: 0});
  $('.button-collapse').sideNav();
  //$('.button-collapse').sideNav({ menuWidth: 90 });

  /*** Tags Input ***/
  $('#task_creation_tag_words').tagsInput({
    width: 'inherit',
    height: 'inherit',
    defaultText: '',
    delimiter: [' '],
  });
});
