alias EventPlanning.Models.User

defimpl Ability, for: User do
  alias EventPlanning.Repo

  def can?(%User{}, action, current_user) when action in ~w[create delete]a do
    true
  end

  def can?(%User{}, action, current_user) when action in ~w[read update]a do
    user = Repo.get!(User, current_user.id)
    user.role == "admin"
  end
end
