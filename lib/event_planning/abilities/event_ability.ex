alias EventPlanning.Models.Event

defimpl Ability, for: Event do
  alias EventPlanning.Repo
  alias EventPlanning.Models.User

  def can?(%Event{}, action, _current_user) when action in ~w[create update delete]a do
    true
  end

  def can?(%Event{}, :read, current_user) do
    user = Repo.get!(User, current_user.id)
    user.role == "admin"
  end
end
