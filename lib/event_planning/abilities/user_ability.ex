alias EventPlanning.Accounts
alias EventPlanning.Accounts.User

defimpl Ability, for: User do
  def can?(%User{}, :create, current_user) do
  end

  def can?(%User{}, :read, current_user) do
    Accounts.get_user!(current_user.id).role == "admin"
  end

  def can?(%User{}, :update, current_user) do
    Accounts.get_user!(current_user.id).role == "admin"
  end

  def can?(%User{}, :delete, current_user) do
  end
end
