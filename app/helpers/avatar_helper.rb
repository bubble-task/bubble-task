module AvatarHelper

  def show_avatar_image(user, force: false)
    return if Rails.env.test? && !force
    javascript_tag("$('#current-user-avatar').attr({ src: Gravtastic('#{user.email}') })").html_safe
  end
end
