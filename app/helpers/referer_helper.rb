module RefererHelper

  def from_show_task?
    from_path_match?(%r{tasks/\d+\z})
  end

  private

    def from_path_match?(regexp)
      Regexp.new(regexp).match(request.referer).present?
    end
end
