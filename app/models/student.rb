class Student < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtBlacklist

  has_many :attendances
  has_many :sessions, through: :attendances
  belongs_to :company, optional: true

  after_create :welcome_send

  def welcome_send
    StudentMailer.welcome_email(self).deliver_now
  end


  def self.get_data(student_id, user_id, user_type)
    if (user_type == 'student' && user_id == 'student_id' || user_type == 'admin')
      return Student.find(student_id)
    else
      render json: 'Access Unauthorized'
    end
  end

  

end
