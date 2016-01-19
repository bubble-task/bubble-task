class TagsController < ApplicationController
  before_action :authorize!

  def index
    @tags = TagRepository.index
  end

  def filter
    term = params[:term]
    @tags = TagRepository.index(term)
    render json: @tags
  end
end
