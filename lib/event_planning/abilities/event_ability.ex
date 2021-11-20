alias EventPlanning.IAE
alias EventPlanning.IAE.Event

alias EventPlanning.Accounts
alias EventPlanning.Accounts.User

defimpl Ability, for: Event do
  def can?(%Event{}, :create, current_user) do
    true
  end

  def can?(%Event{}, :read, current_user) do
    Accounts.get_user!(current_user.id).role == "admin"
  end

  def can?(%Event{}, :update, current_user) do
    true
  end

  def can?(%Event{}, :delete, current_user) do
    true
  end
end
