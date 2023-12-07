# == Schema Information
#
# Table name: users
#
#  id                             :integer          not null, primary key
#  avatar_img                     :string
#  bio                            :string
#  comments_count                 :integer          default(0)
#  email                          :string           default(""), not null
#  encrypted_password             :string           default(""), not null
#  likes_count                    :integer          default(0)
#  own_photos_count               :integer
#  private                        :boolean
#  received_follow_requests_count :integer
#  remember_created_at            :datetime
#  reset_password_sent_at         :datetime
#  reset_password_token           :string
#  sent_follow_requests_count     :integer
#  username                       :string
#  website                        :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true
  validates :username, uniqueness: true

  #Direct Associations
  has_many :likes, class_name: "Like", foreign_key: "fan_id", dependent: :destroy
  has_many :comments, class_name: "Comment", foreign_key: "author_id", dependent: :destroy
  has_many :sent_follow_requests, class_name: "FollowRequest", foreign_key: "sender_id", dependent: :destroy
  has_many :received_follow_requests, class_name: "FollowRequest", foreign_key: "recipient_id", dependent: :destroy
  has_many :own_photos, class_name: "Photo", foreign_key: "owner_id", dependent: :destroy

  ##Indirect Associations
  #has_many :following, through: :sent_follow_requests, source: :recipient

  has_many :following, -> { where(follow_requests: { status: "accepted" }) },
           through: :sent_follow_requests, source: :recipient

  has_many :followers, -> { where(follow_requests: { status: "accepted" }) },
           through: :received_follow_requests, source: :sender

  #has_many :followers, through: :received_follow_requests, source: :sender

  has_many :liked_photos, through: :likes, source: :photo

  has_many :feed, through: :following, source: :own_photos

  has_many :activity, through: :following, source: :liked_photos
end
