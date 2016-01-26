module PathFilter

  def filter_for_search(path)
    return path if path.start_with?('/search')
    '/search'
  end
end
