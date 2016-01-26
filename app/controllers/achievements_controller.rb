class AchievementsController < ApplicationController
  before_action :authorize!

  def index
    @form = AchievementCriteriaForm.new(current_user.id, form_params)
    tasks = if form_params.empty?
              []
            else
              TaskRepository.search_by_criteria(@form.criteria)
            end
    @tasks = tasks.map { |t| TaskPresenter.new(t) }
  end

  private

    def form_params
      params[AchievementCriteriaForm.param_name] || {}
    end
end
