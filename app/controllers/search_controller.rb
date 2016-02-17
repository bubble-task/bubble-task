class SearchController < ApplicationController
  before_action :authorize!

  def index
    @form = TaskCriteriaForm.new(current_user.id, form_params)
    tasks = if form_params.empty?
              []
            else
              TaskRepository.search_by_criteria(current_user.id, @form.criteria)
            end
    @tasks = tasks.map { |t| TaskPresenter.new(t) }
  end

  private

    def form_params
      params[TaskCriteriaForm.param_name] || {}
    end
end
