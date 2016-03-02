var taskCompletionHandler = function(element) {
  $(element).change(function() {
    $(this).parent().submit();
  });
}
