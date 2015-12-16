class AchievementsController < ApplicationController
  before_action :authorize!

  def index
    command = AchievementSearch.new(params[:achievement_search])
    command.run(current_user.id)
    @tasks = command.result
  end
end
