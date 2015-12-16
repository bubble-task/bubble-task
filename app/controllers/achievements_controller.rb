class AchievementsController < ApplicationController
  before_action :authorize!

  def index
    from_date = params[:from] && Time.zone.parse(params[:from])
    to_date = params[:to] && Time.zone.parse(params[:to])
    @tasks = TaskRepository.all_completed_by_author_id(current_user.id, from_date: from_date, to_date: to_date).map do |task|
      TaskPresenter.new(task)
    end
  end
end
