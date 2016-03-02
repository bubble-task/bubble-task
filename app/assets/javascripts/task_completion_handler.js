var taskCompletionHandler = function(element) {
//$('.task_completion').change(function() {
  $(element).change(function() {
    $(this).parent().submit();
  });
}
