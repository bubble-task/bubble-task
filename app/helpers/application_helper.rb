module ApplicationHelper

  def activate_menu(actives)
    ' class=active'.html_safe if detect_active_page(actives)
  end

  def detect_active_page(actives)
    actives
      .map(&:flatten)
      .detect { |(c, a)| current_page?(controller: c, action: a) }
  end
end
