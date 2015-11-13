class HomeController < ApplicationController
  before_action :authorize!

  def index
    @tasks = Task.all
  end
end
