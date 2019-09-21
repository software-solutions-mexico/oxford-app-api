  class User < ApplicationRecord
    ROLES = ["ADMIN", "PARENT"]

    acts_as_token_authenticatable
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable

    validates :email, :password, :name, :role, presence: true
    validates :family_key, presence: true, if: -> { is_parent? }
    validate :role_validation
    validate :family_validation, if: -> { is_parent? }
    before_save :normalize_date


    has_and_belongs_to_many :kids
    has_many :notifications

    def normalize_date
      self.name&.upcase!
      self.relationship&.upcase!
      self.relationship == ["PADRE", "MADRE", "PARENT"] ? self.role = "PARENT" : self.role = "ADMIN"
    end

    def is_admin?
      self.role == 'ADMIN'
    end

    def is_parent?
      self.role == 'PARENT'
    end

    def role_validation
      if !ROLES.include? self.role
        errors.add('Role', 'not valid')
        throw(:abort)
      end
    end

    def family_validation
      if Kid.where(family_key: self.family_key)&.any?
        Kid.where(family_key: self.family_key)&.each do |kid|
          family_added = false
          if kid.users&.where(id: self)&.empty?
            self.kids << kid
            family_added = true
          end
          kid.save if family_added
        end
      else
        errors.add('Family', 'key not found')
        throw(:abort)
      end
    end

    def notifications
      super.where("publication_date > ?", Date.today)
    end

    scope :by_role, -> (role) { where(role: role) }
    scope :by_admin_campus, -> (campus) { where(admin_campus: campus) }
    scope :by_email, -> (email) { where(email: email) }

  end
