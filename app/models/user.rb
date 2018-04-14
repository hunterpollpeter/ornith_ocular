class User < ApplicationRecord
  validates_presence_of :first_name
  validates_presence_of :last_name

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  validates :username, presence: :true, uniqueness: { case_sensitive: false }
  
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, multiline: true

  has_many :sitings, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_attached_file :avatar, styles: { medium: "300x300>", small: "300x300#", thumb: "100x100#" }, default_url: "/assets/:style/missing.jpg"

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  # avatar must be less than 2MB
  validates_attachment_size :avatar, less_than: 2.megabytes

  acts_as_voter

  def name()
  	first_name + " " + last_name
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end
end
