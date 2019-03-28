# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

# 50.times do
#     User.create!(email: Faker::Internet.email)
# end

# 100.times do
#     ShortenedUrl.short_url_instance(User.all.sample, Faker::Internet.url)
# end

# 1000.times do 
#     Visit.record_visit!(User.all.sample, ShortenedUrl.all.sample)
# end

2000.times do 
    TagTopic.create!(topic: Faker::Color.color_name)
end

2000.times do
    Tagging.create!(tag_topic_id: TagTopic.all.sample.id, shortened_url_id: ShortenedUrl.all.sample.id)
end