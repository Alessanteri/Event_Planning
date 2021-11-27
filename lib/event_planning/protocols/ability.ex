defprotocol Ability do
  alias EventPlanning.Models.Event

  def can?(schema, _action, current_user)
end
