class User
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  include Mongo::Voteable
  
  field :name, :type => String, :allow_nil => false
  field :email, :type => String, :allow_nil => false
  field :crypted_password, :type => String, :allow_nil => false
  field :salt, :type => String, :allow_nil => false
  field :enabled, :type => Boolean, :allow_nil => false, :default => true
  field :confirmed, :type => Boolean, :allow_nil => false, :default => false
  field :remember_token, :type => String
  field :remember_token_expires_at, :type => Time
  field :reset_token, :type => String
  field :reset_token_expires_at, :type => Time
  field :validation_token, :type => String
  field :validation_token_expires_at, :type => Time
  
  attr_accessor :password, :password_confirmation
    
  validates_presence_of :name, :message => "can't be blank"
  validates_presence_of :email, :message => "can't be blank"
  validates_uniqueness_of :email, :message => "already has an account. Did you forget your password?"
  validates_format_of :email, :with => /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "is invalid"
  validates_presence_of :password, :if => proc{|m| m.password_required?}
  validates_confirmation_of :password, :if => proc{|m| m.password_required?}
  
  before_save :encrypt_password
  after_create :send_validation_message
  
  ######################################
  # authentication methods
  def self.authenticate(login, password)
    @u = where(:email => login, :enabled => true).first
    @u && @u.authenticated?(password) ? @u : nil
  end
  
  def self.authenticate_remembered(id, remember_token)
    where(
      :_id => id,
      :remember_token => remember_token,
      :remember_token_expires_at.gt => Date.today,
      :enabled => true
    ).first
  end
  
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end
  
  def self.validate_email(id, validation_token)
    u = where(:_id => id, :validation_token => validation_token, :enabled => true).first
    if u
      u.update_attributes(:confirmed => true, :validation_token => nil)
      u
    else
      nil
    end
  end
  
  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def password_required?
    crypted_password.blank? || !password.blank?
  end

  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if salt.blank?
    self.crypted_password = encrypt(password)
  end
  
  def generate_remember_token!
    update_attributes(:remember_token => Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{salt}--"), :remember_token_expires_at => Time.now + 30.days)
    remember_token
  end

  def clear_remember_token!
    update_attributes(:remember_token => nil, :remember_token_expires_at => nil)
  end

  def generate_reset_token!
    update_attributes(:reset_token => Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{salt}--"), :reset_token_expires_at => Time.now + 1.hour)
    reset_token
  end
  
  def clear_reset_token!
    update_attributes(:reset_token => nil, :reset_token_expires_at => nil)
  end
  
  def generate_validation_token!
    update_attributes(:validation_token => Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{salt}--"))
    validation_token
  end
  
  ######################################
  
  # make sure we don't get duplicates
  # this is the unique account identifier
  def email=(new_email)
    write_attribute(:email, new_email.downcase)
  end
  
  def add_invites(count = 1)
    count.times do
      invites.build.save
    end
  end
  
  def available_invites
    invites.where(:sent => false, :accepted => false)
  end
  
  # updated after confirmation email is clicked through
  def confirm
    update_attributes(:comfirmed => true, :enbaled => true)
  end
  
  def send_validation_message
    deliver(:users, :validate, self)
  end

  def send_password_reset_message
    deliver(:users, :password_reset, self)
  end

  private
  # called after_create
  def accept_invite
    unless accepted_invite.blank?
      accepted_invite.update_attributes(:accepted => true, :accepted_user_id => self.id)
    end
  end
  
  def deliver(*args)
    KnitWriter.settings.deliver(*args)
  end
end
