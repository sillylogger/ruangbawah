class SearchDocument < PgSearch::Document
  include PgSearch

  attr_accessor :distance

  acts_as_mappable lat_column_name: :latitude,
    lng_column_name: :longitude

  pg_search_scope :search_for, against: %i(content)

  scope :for_nearests, -> (origin, text: '', distance: 50) {
    scoped = within(50, origin: origin).by_distance(origin: origin)
    scoped = scoped.search_for(text) if text.present?
    scoped
  }
end