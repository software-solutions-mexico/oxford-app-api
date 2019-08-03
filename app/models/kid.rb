class Kid < ApplicationRecord
  has_and_belongs_to_many :users
  validates :name, :grade, :group, :family_key, presence: true
  validate :family_validation
  before_save :downcase_fields

  def downcase_fields
    self.campus.downcase!
  end

  def family_validation
    if User.where(family_key: self.family_key).any?
      User.where(family_key: self.family_key, role: 'parent')&.each do |parent|
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