# == Schema Information
#
# Table name: volunteers
#
#  id                       :integer          not null, primary key
#  first_name               :string(255)
#  middle_name              :string(255)
#  last_name                :string(255)
#  address1                 :string(255)
#  address2                 :string(255)
#  address3                 :string(255)
#  city                     :string(255)
#  state                    :string(255)
#  postal                   :string(255)
#  country                  :string(255)
#  home_phone               :string(255)
#  work_phone               :string(255)
#  other_phone              :string(255)
#  email                    :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  user_id                  :integer
#  can_have_multiple_radios :boolean
#

class Volunteer < ActiveRecord::Base
  has_paper_trail

  paginates_per 25

  has_one :volunteer_training, dependent: :destroy, autosave: true
  has_many :radio_assignments
  has_many :radios, through: :radio_assignments
  belongs_to :user

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates_format_of [:home_phone, :work_phone, :other_phone], allow_blank: true, allow_nil: true,
                      message:                                               "must be a valid telephone number.",
                      with:                                                  /\A[\(\)0-9\- \+\.]{10,20}\z/
  validates_associated :volunteer_training
  validate :at_least_one_phone_number
  accepts_nested_attributes_for :volunteer_training
  scope :radio_volunteers, -> { joins(:volunteer_training).order(:last_name).where("radio = ?", true) }
  scope :radio_volunteer, ->(first, last) {
    joins(:volunteer_training).
        order(:last_name).where("first_name ilike ? and last_name ilike ? and radio = ?",
                                "#{first}%",
                                "#{last}%",
                                true) }

  def name
    return (first_name ? first_name + " " : "") +
        (middle_name ? middle_name + " " : "") +
        (last_name ? last_name : "")
  end

  private

  def at_least_one_phone_number
    if (home_phone.nil? or home_phone.empty?) and
        (work_phone.nil? or work_phone.empty?) and
        (other_phone.nil? or other_phone.empty?)
      errors.add :home_phone, "At least one phone number must be specified"
    end
  end
end
