class Gallery
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  has_many :medias
end
