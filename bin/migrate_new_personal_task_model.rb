personal_tasks = Task.includes(:taggings).where(taggings: { id: nil })

personal_tasks.each do |pt|
  owner = User.find(pt.author_id)
  p "------------------"
  p title: pt.title
  p owner: owner
  pt.to_personal_task(owner)
end
