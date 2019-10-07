class Kid < ApplicationRecord
  has_and_belongs_to_many :users
  validates :name, :grade, :group, :family_key, presence: true
  validate :family_validation
  before_save :upcase_fields, :verify_fullname

  def upcase_fields
    self.full_name&.upcase!
    self.father_last_name&.upcase!
    self.mother_last_name&.upcase!
    self.name&.upcase!
    self.campus&.upcase!
    self.grade&.upcase!
    self.group&.upcase!
  end

  def verify_fullname
    self.full_name = [self.father_last_name, self.mother_last_name, self.name].reject(&:empty?).join(' ') if self.full_name.blank?
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

  scope :by_campuses, -> (campuses) { where(campus: campuses) }
  scope :by_grades, -> (grades) { where(grade: grades) }
  scope :by_groups, -> (groups) { where(group: groups) }
  scope :by_family_keys, -> (family_keys) { where(family_key: family_keys) }
  scope :by_student_names, -> (student_names) { where(name: student_names) }

end