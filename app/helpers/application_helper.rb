module ApplicationHelper

  def activate_menu(actives)
    ' class=active'.html_safe if current_page_active?(actives)
  end

  def current_page_active?(actives)
    actives
      .map(&:flatten)
      .detect { |(c, a)| current_page?(controller: c, action: a) }
  end
end
