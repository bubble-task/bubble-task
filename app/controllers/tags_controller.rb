class TagsController < ApplicationController

  def index
    @tags = TagRepository.index
  end
end
