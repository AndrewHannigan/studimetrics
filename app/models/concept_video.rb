class ConceptVideo < ActiveRecord::Base
  belongs_to :concept, touch: true
  validates :video_link, presence: true

  delegate :name, to: :concept, prefix: true, allow_nil: true

  has_attached_file :pdf, path: "/:class/:attachment/:hash.:extension", hash_secret: "Uk2tEwMEsZ7gsh.WjzFC4jV26hzEdm!!"

  %w(large medium small).each do |size|
    define_method :"#{size}_thumbnail" do
      Vimeo::Simple::Video.info(video_link).parsed_response.first["thumbnail_#{size}"]
    end
  end
end
