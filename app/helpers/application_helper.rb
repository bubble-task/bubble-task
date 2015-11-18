module ApplicationHelper

  def activate_menu(menu_url)
    ' class="active"'.html_safe if request.original_url == menu_url
  end
end
