class Post < ActiveRecord::Base
  validates_presence_of :content
  validates_presence_of :scheduled_at
  validates_length_of :content, maximum: 140, message: "Less than 140 characters"
  validates_datetime :scheduled_at, on: :create, on_or_after: Time.zone.now
  belongs_to :user

  def to_twitter
    client = Twitter::REST::Client.new do |config|
      config.access_token = self.user.twitter.oauth_token
      config.access_token_secret = self.user.twitter.secret
      config.consumer_key = ENV["TWITTER_KEY"]
      config.consumer_secret = ENV["TWITTER_SECRET"]
    end
    client.update(self.content)
  end

  def to_facebook
    graph = Koala::Facebook::API.new(self.user.facebook.oauth_token)
    graph.put_connections("me", "feed", message: self.content)
  end
end
