class AdditionsController < ApplicationController

  def new
    @addition = Addition.new
  end

  def create
    @addition = Addition.new(params[:addition])
    @addition.compute!
  end
end
