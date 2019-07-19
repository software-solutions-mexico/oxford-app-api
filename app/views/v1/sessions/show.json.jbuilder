json.data do
  json.user do
    json.call(
        @user,
        :id,
        :name,
        :role,
        :email,
        :family_key
    )
  end
end