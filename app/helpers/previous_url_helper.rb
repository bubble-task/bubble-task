module PreviousUrlHelper
  def previous_url_for_task
    referrer = request.referrer
    return root_url if from_path_match?(%r{/tasks/\d+/edit$}, referrer: referrer)
    referrer
  end

  def from_show_task?
    from_path_match?(%r{tasks/\d+\z})
  end

  private

    def from_path_match?(regexp, referrer: request.referrer)
      Regexp.new(regexp).match(referrer).present?
    end
end
