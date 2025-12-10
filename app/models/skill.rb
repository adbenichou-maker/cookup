class Skill < ApplicationRecord
  enum :skill_level, [ :beginner, :intermediate, :expert ], _prefix: true
  has_one :step
  has_one_attached :video
  validates :title, :description, :video, :skill_level, presence: true

  def cloudinary_video_url(width: 700, quality: 'auto', format: 'auto')
    return nil unless self.video.present?

    cloud_name = ENV['CLOUDINARY_CLOUD_NAME'] || Cloudinary.config.cloud_name
    base_url = "https://res.cloudinary.com/#{cloud_name}/video/upload/"

    # transformations = "w_#{width},q_#{quality},f_#{format}"

    "#{base_url}/#{self.video}"
  end

end
