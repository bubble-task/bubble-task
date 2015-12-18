class AchievementsController < ApplicationController
  before_action :authorize!

  def index
    @form = AchievementCriteriaForm.new(form_params.merge(author_id: current_user.id))
    tasks = TaskRepository.search_by_criteria(@form.criteria)
    @tasks = tasks.map { |t| TaskPresenter.new(t) }
  end

  private

    def form_params
      params[:q] || {}
    end
end
