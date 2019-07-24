  class User < ApplicationRecord
    ROLES = ["admin", "parent"]

    acts_as_token_authenticatable
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable

    validates :email, :password, :name, :role, presence: true
    validates :family_key, presence: true, if: -> { is_parent? }
    validate :role_validation
    validate :family_validation, if: -> { is_parent? }



    has_and_belongs_to_many :kids

    def is_admin?
      self.role == 'admin'
    end

    def is_parent?
      self.role == 'parent'
    end

    def role_validation
      if !ROLES.include? self.role
        errors.add('Role', 'not valid')
        throw(:abort)
      end
    end

    def family_validation
      if Kid.where(family_key: self.family_key)&.any?
        family_added = false
        Kid.where(family_key: self.family_key)&.each do |kid|
          if !kid.users.where(id: self.id)&.any?
            self.kids << kid
            family_added = true
          end
        end
        self.save if family_added
      else
        errors.add('Family', 'key not found')
        throw(:abort)
      end
    end
  end
