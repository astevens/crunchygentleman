class CrunchyGentleman < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers
  register CompassInitializer
  register Sinatra::SimpleNavigation


  set :session_secret, "15820d6004fcfaeea754524f398e85ef4c2bb46db181c454bf9d96de566dd9ea"
  set :sessions, true

  ##
  # Caching support
  #
  # register Padrino::Cache
  # enable :caching
  #
  # You can customize caching store engines:
  #
  #   set :cache, Padrino::Cache::Store::Memcache.new(::Memcached.new('127.0.0.1:11211', :exception_retry_limit => 1))
  #   set :cache, Padrino::Cache::Store::Memcache.new(::Dalli::Client.new('127.0.0.1:11211', :exception_retry_limit => 1))
  #   set :cache, Padrino::Cache::Store::Redis.new(::Redis.new(:host => '127.0.0.1', :port => 6379, :db => 0))
  #   set :cache, Padrino::Cache::Store::Memory.new(50)
  #   set :cache, Padrino::Cache::Store::File.new(Padrino.root('tmp', app_name.to_s, 'cache')) # default choice
  #

  ##
  # Application configuration options
  #
  # set :raise_errors, true     # Raise exceptions (will stop application) (default true for development)
  # set :show_exceptions, true  # Show a stack trace in browser (default is true)
  # set :public, "foo/bar"      # Location for static assets (default root/public)
  # set :reload, false          # Reload application files (default in development)
  # set :default_builder, "foo" # Set a custom form builder (default 'StandardFormBuilder')
  # set :locale_path, "bar"     # Set path for I18n translations (defaults to app/locale/)
  # enable :sessions            # Disabled by default
  # disable :flash              # Disables rack-flash (enabled by default if sessions)
  # disable :padrino_logging    # Disables Padrino logging (enabled by default)
  # layout  :my_layout          # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
  #

  CarrierWave.configure do |config|
    s3_config = YAML.load(File.open(Padrino.root('config/s3.yml')))[Padrino.env.to_s]
    config.storage = :fog
    config.fog_credentials = {
        :provider => 'AWS',
        :aws_access_key_id => s3_config["access_key"],
        :aws_secret_access_key => s3_config["secret_key"],
        :region => 'us-east-1'
    }
    config.fog_directory = s3_config["bucket"]
    config.fog_host = s3_config["host"]
    config.fog_public = true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000', 'x-amz-storage-class' => 'REDUCED_REDUNDANCY'}
  end

  ##
  # You can configure for a specified environment like:
  #
  #   configure :development do
  #     set :foo, :bar
  #     disable :asset_stamp # no asset timestamping for dev
  #   end
  #

  ##
  # You can manage errors like:
  #
  #   error 404 do
  #     render 'errors/404'
  #   end
  #
  #   error 505 do
  #     render 'errors/505'
  #   end
  #
end