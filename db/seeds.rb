require 'ffaker'

Event.destroy_all
Topic.destroy_all
User.destroy_all
Filter.destroy_all

6.times { User.create! email: FFaker::Internet.email, password: '123456' }

cities = [
  { name: 'Moscow' },
  { name: 'Saint Petersburg' },
  { name: 'Yekaterinburg' },
  { name: 'Kazan' },
  { name: 'Ufa' },
  { name: 'Magnitogorsk' }
].map { |data| City.find_or_create_by! data }

topics = 4.times { Topic.create! title: FFaker::Lorem.word.capitalize, description: FFaker::Lorem.paragraph }

events = 10.times.map do
  Event.create!(
    title: FFaker::Lorem.word.capitalize,
    city: cities[rand(0..cities.size - 1)],
    started_at: (24 * 2 + (rand(1..6))).hours.from_now,
    finished_at: (24 * 2 + 8 + (rand(1..6))).hours.from_now,
    skip_callback: true
  )
end

30.times { Comment.create! user: User.get_random, event: Event.get_random, text: FFaker::Lorem.sentences.join(' ') }

events.each { |e| e.topics << Topic.order("RAND()").limit(rand(1..3)) }
