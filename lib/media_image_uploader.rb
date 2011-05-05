class MediaImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::ImageScience
  # storage :fog

  # def root; File.join(Padrino.root,"public/"); end

  ##
  # Directory where uploaded files will be stored (default is /public/uploads)
  #
  def store_dir
    'media/images'
  end

  ##
  # Directory where uploaded temp files will be stored (default is [root]/tmp)
  #
  def cache_dir
    "/tmp"
  end

  ##
  # Default URL as a default if there hasn't been a file uploaded
  #
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  ##
  # Process files as they are uploaded.
  #
  # process :resize_to_fit => [740, 580]

  ##
  # Create different versions of your uploaded files
  #
  version :thumb do
    process :resize_to_fill => [100, 100]
  end
  
  ##
  # White list of extensions which are allowed to be uploaded:
  #
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  ##
  # Override the filename of the uploaded files
  #
  def filename
    model.id.to_s + File.extname(original_filename) unless original_filename.blank?
  end
end
