module PreviousUrlHelper
  def previous_url_for_task
    return root_url if from_show_task?
    return root_url if from_edit_task?
    request.referrer
  end

  def from_edit_task?
    from_path_match?(%r{/tasks/\d+/edit$})
  end

  def from_show_task?
    from_path_match?(%r{tasks/\d+\z})
  end

  def from_home?
    from_path_match?(%r{\A/\z})
  end

  private

    def from_path_match?(regexp)
      regexp.match(request.referrer).present?
    end
end
