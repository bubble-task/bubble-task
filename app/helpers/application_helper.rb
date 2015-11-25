module ApplicationHelper
  def activate_menu(actives)
    ' class=active'.html_safe if current_page_active?(actives)
  end

  def current_page_active?(actives)
    actives
      .map(&:flatten)
      .detect { |(c, a)| controller.controller_name == c && controller.action_name == a }
  end
end
