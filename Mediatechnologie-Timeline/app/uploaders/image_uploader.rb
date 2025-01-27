# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:

  include CarrierWave::RMagick

  # include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
   asset_path([version_name, "default_image.png"].compact.join('_'))
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  resize_to_limit(1024, 768)

  # version :large do
  #   # process :crop
  # end
  # version :thumb do
  #   # process :crop
  #   resize_to_fill(100, 100)
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  version :large do
    process :crop
  end

  version :preview do
    process :crop
    resize_to_limit(690, 518)
  end

  version :thumb do
    process :crop
    resize_to_fill(100, 100)
  end

  version :banner do
    process :crop
    resize_to_fill(550, 110)
  end


  def crop
    if model.crop_x.present?
      manipulate! do |img|
        x = model.crop_x.to_i
        y = model.crop_y.to_i
        w = model.crop_w.to_i
        h = model.crop_h.to_i
        img = img.crop(x, y, w, h)
        img
      end
    end
  end

  def convert_to_grayscale
    manipulate! do |img|
      img.colorspace = MiniMagick::GRAYColorspace
      img
    end
  end

  def brightness
    manipulate! do |img|
      img.modulate(1.20, 0.5, 1.2)
    end
  end
end
