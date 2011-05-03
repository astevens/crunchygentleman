class User
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  
  field :name, :type => String, :allow_nil => false
  validates_presence_of :name, :message => "can't be blank"
  field :email, :type => String, :allow_nil => false
  validates_presence_of :email, :message => "can't be blank"
  validates_format_of :email, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i, :message => "is invalid"
  
end
