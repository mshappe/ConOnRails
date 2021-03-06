# == Schema Information
#
# Table name: conventions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  start_date :datetime
#  end_date   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class NotTimeTravelingValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.present? && value > record.start_date
      record.errors[attribute] << (options[:message] || 'must be later than Start date!')
    end
  end

end

class Convention < ActiveRecord::Base
  has_paper_trail

  validates :name, presence: true, uniqueness: true
  validates :start_date, presence: true
  validates :end_date, presence: true, not_time_traveling: true

  def self.most_recent
    order('start_date desc').first
  end

  def self.least_recent
    order('start_date asc').first
  end

  def self.current_convention
    where { |c| (c.start_date <= Date.current) & (c.end_date >= Date.current) }.first || Convention.most_recent
  end
end
