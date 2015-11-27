class TagsController < ApplicationController
  before_action :authorize!

  def index
    @tags = TagRepository.index
  end
end
