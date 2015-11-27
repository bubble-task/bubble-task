module PreviousUrlHelper

  def previous_url_for_task
    referrer = request.referrer
    return root_url if referrer =~ %r|/tasks/\d+/edit$|
    request.referrer
  end
end
