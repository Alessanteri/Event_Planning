defprotocol Ability do
  def can?(schema, _action, current_user)
end
