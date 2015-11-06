class Addition
  include ActiveModel::Model

  attr_accessor :left, :right

  def compute!
    @answer = left.to_i + right.to_i
  end

  def describe
    "#{left} + #{right} = #{@answer}"
  end
end

class AdditionsController < ApplicationController

  def new
    @addition = Addition.new
  end

  def create
    @addition = Addition.new(params[:addition])
    @addition.compute!
  end
end
