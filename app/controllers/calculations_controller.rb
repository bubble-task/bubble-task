class CalculationsController < ApplicationController

  def new
    @calculation = Calculation.new
  end

  def create
    @calculation = Calculation.new(params[:calculation])
    @calculation.compute!
  end
end
