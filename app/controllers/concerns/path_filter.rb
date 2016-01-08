module PathFilter

  def filter_for_achievement(path)
    return path if path.start_with?('/achievements')
    '/achievements'
  end
end
