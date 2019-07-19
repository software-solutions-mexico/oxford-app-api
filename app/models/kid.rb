class Kid < ApplicationRecord
  has_and_belongs_to_many :users
  validates :name, :grade, :group, :family_key, presence: true
  validate :family_validation

  def family_validation
    if User.where(family_key: self.family_key).any?
      family_added = false
      User.where(family_key: self.family_key, role: 'parent')&.each do |parent|
        if !parent.kids.find(self)&.any?
          self.parents << parent
          family_added = true
        end
      end
      self.save if family_added
    end
  end

end
