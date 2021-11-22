defprotocol Ability do
  # @spec can?(
  #         schema :: Ecto.Schema.t(),
  #         :create | :read | :update | :delete,
  #         current_user :: Ecto.Schema.t()
  #       ) :: boolean

  def can?(schema, _action, current_user)
end
