json.data do
  json.notification do
    json.call(
        @notification,
        :category,
        :title,
        :description,
        :publication_date,
        :role,
        :relationship,
        :campus,
        :grade,
        :group,
        :family_key,
        :student_name,
        :seen,
        :assist,
        :event_id
    )
  end
end