class Media
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  include ActsAsList::Mongoid
  include Mongo::Voteable
  
  field :description, :type => String
  
  belongs_to :post, :required => true
  validates_presence_of :post_id, :message => "can't be blank"
  
  acts_as_list :column => :position, :scope => :post_id
  voteable self, :up => +1, :down => -1
  voteable Post, :up => +1, :down => -1
  
end
