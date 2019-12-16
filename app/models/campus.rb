class Campus < ApplicationRecord
  before_save :upcase_fields

  def upcase_fields
    self.name&.upcase!
    self.groups&.upcase!
  end
end