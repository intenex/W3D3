# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint(8)        not null, primary key
#  short_url  :string
#  long_url   :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require_relative 'visit'


class ShortenedUrl < ApplicationRecord
    validates :short_url, presence: true, uniqueness: true 
    validates :long_url, :user_id, presence: true

    def self.random_code
        shortened_url = SecureRandom::urlsafe_base64
        while ShortenedUrl.exists?(short_url: shortened_url)
            shortened_url = SecureRandom::urlsafe_base64
        end
        shortened_url
    end

    def self.short_url_instance(user, original_url)
        ShortenedUrl.create!({short_url: ShortenedUrl.random_code,
                             long_url: original_url,
                             user_id: user.id})
    end

    belongs_to :submitter, 
        class_name: 'User',
        foreign_key: :user_id,
        primary_key: :id

    has_many(
        :visits,
        class_name: 'Visit',
        foreign_key: :shortened_url_id,
        primary_key: :id
    )

    has_many(
        :visitors,
        through: :visits,
        source: :users
    )

    has_many(
        :distinct_visitors,
        -> { distinct },
        through: :visits,
        source: :users
    )

    has_many(
        :taggings,
        class_name: 'Tagging',
        foreign_key: :shortened_url_id,
        primary_key: :id
    )

    has_many(
        :tag_topics,
        through: :taggings,
        source: :tag_topic
    )

    def num_clicks
        # Visit.where({:shortened_url_id => self.id}).select(:user_id).distinct.count
        visits.select(:user_id).count
    end

    def num_uniques
        visits.select(:user_id).distinct.count
    end

    def num_recent_uniques
        distinct_visitors.where(["visits.updated_at > ?",  "#{10.minutes.ago}"]).select(:id).distinct.count
        # .count
    end

    # def generate_short_url
    #     self.short_url = ShortenedUrl.random_code
    # end

    # before_validation :generate_short_url
end
