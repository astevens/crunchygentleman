class Media
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  
  field :description, :type => String
  
  belongs_to :post, :required => true
  validates_presence_of :post_id, :message => "can't be blank"
end
