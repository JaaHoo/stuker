class Post < ActiveRecord::Base
  validates_presence_of :content
  validates_presence_of :scheduled_at
  validates_length_of :content, maximum: 140, message: "Less than 140 characters"
  belongs_to :user
end
