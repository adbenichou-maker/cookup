class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :chats
  has_many :messages, through: :chats
  has_many :recipes

  devise :database_authenticatable, :registerable,
<<<<<<< HEAD
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true

=======
          :recoverable, :rememberable, :validatable
>>>>>>> cce00dff691f86d990871d53c5f793e832c75fe6
end
