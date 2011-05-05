class Media::Image < Media
  mount_uploader :file, MediaImageUploader
end
