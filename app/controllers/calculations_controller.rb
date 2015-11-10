class CalculationsController < ApplicationController

  def new
    @calculation = Calculation.new
  end

  def create
    @calculation = Calculation.new(params[:calculation])
    @calculation.compute!
    if @calculation.errors.empty?
      render :create
    else
      render :new
    end
  end
end
