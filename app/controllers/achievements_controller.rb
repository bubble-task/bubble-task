class AchievementsController < ApplicationController
  before_action :authorize!

  def index
    @form = AchievementCriteriaForm.new(form_params.merge(assignee_id: current_user.id))
    tasks = TaskRepository.search_by_criteria(@form.criteria)
    @tasks = tasks.map { |t| TaskPresenter.new(t) }
  end

  private

    def form_params
      params[AchievementCriteriaForm.param_name] || { is_signed_up_only: '1' }
    end
end
