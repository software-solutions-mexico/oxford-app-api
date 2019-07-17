json.data do
  json.user do
    json.call(
        @user,
        :id,
        :email
    )
  end
end