require 'rails_helper'

class DummyView
  include ApplicationHelper

  Controller = Struct.new(:controller_name, :action_name)

  attr_reader :controller

  def initialize(controller_name, action_name)
    @controller = Controller.new(controller_name, action_name)
  end
end

describe ApplicationHelper do
  describe '#activate_menu' do
    it do
      c = DummyView.new('home', 'index')
      r = c.activate_menu([{ 'tasks' => 'new' }, { 'tasks' => 'show' }, { 'home' => 'index' }])
      expect(r).to eq(' class="active"')
    end

    it do
      c = DummyView.new('tasks', 'new')
      r = c.activate_menu({ 'home' => 'index' })
      expect(r).to eq(nil)
    end
  end
end
