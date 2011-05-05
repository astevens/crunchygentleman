class Gallery
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  field :tags, :type => Array

  has_many :medias
  belongs_to :user
  belongs_to :sponsor
end
