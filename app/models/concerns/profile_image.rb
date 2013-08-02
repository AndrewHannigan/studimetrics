require 'active_support/concern'

module ProfileImage
  extend ActiveSupport::Concern

  included do
    has_attached_file :profile_image,
      path: "/:hash.:extension",
      hash_secret: "Uk2tEwMEsZ7gsh.WjzFC4jV6hzEdm!!",
      default_url: "/assets/:class/:attachment/:style/missing.png",
      styles: {
        medium: '300x300>',
        thumb: '80x80#'
      }
  end
end
