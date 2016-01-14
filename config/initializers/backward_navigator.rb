Rails.application.config.after_initialize do
  BackwardNavigator.register_backable_paths(%w(/ /tasks))
end
