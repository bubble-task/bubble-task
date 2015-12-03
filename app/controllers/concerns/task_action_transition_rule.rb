class TaskActionTransitionRule

  def initialize(origin_page, url_generator)
    @origin_page = origin_page
    @url_generator = url_generator
  end

  def completion_url
    return @url_generator.root_url if @origin_page.blank?
    @url_generator.tasks_url(tag: @origin_page)
  end
end
