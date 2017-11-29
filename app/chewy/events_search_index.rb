class EventsSearchIndex < Chewy::Index
  define_type Event do
    field :id, type: :integer
    field :title
  end
end
