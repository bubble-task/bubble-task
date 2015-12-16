class AchievementsController < ApplicationController
  before_action :authorize!

  def index
    @command = AchievementSearch.new(params[:q])
    @command.run(current_user.id)
    @tasks = @command.result
  end
end
