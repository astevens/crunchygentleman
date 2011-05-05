class Gallery
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  field :tags, :type => Array
  field :description, :type => String
  validates_presence_of :description, :message => "can't be blank"
  

  has_many :medias
  belongs_to :user
  belongs_to :sponsor
end
