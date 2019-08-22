class Kid < ApplicationRecord
  has_and_belongs_to_many :users
  validates :name, :grade, :group, :family_key, presence: true
  validate :family_validation
  before_save :upcase_fields

  def upcase_fields
    self.full_name.upcase!
    self.father_last_name.upcase!
    self.mother_last_name.upcase!
    self.name.upcase!
    self.campus.upcase!
    self.grade.upcase!
    self.group.upcase!
  end

  def family_validation
    if User.where(family_key: self.family_key).any?
      User.where(family_key: self.family_key, role: 'PARENT')&.each do |parent|
        family_added = false
        if parent.kids&.where(id: self)&.empty?
          self.parents << parent
          family_added = true
        end
        self.save if family_added
      end
    end
  end

end