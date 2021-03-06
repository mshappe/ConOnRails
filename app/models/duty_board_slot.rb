# == Schema Information
#
# Table name: duty_board_slots
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  duty_board_group_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class DutyBoardSlot < ActiveRecord::Base
  has_paper_trail

  belongs_to :duty_board_group
  has_one :duty_board_assignment
  accepts_nested_attributes_for :duty_board_assignment

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :duty_board_group_id
end
