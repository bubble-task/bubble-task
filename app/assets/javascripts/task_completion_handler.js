var taskCompletionHandler = function() {
  $('.task_completion').change(function() {
    $(this).parent().submit();
  });
}
