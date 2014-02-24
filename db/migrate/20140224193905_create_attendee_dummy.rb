class CreateAttendeeDummy < ActiveRecord::Migration
  def change
    create_table :attendee_dummies do |t|
      t.integer :ATTENDEE_ID
      t.string :FIRST_NAME
      t.string :MIDDLE_NAME
      t.string :LAST_NAME
      t.string :COMMENTS
      t.string :EMAIL
      t.string :HOME_PHONE
      t.string :WORK_PHONE
      t.string :OTHER_PHONE
      t.string :ADDRESS_LINE_1
      t.string :ADDRESS_LINE_2
      t.string :ADDRESS_LINE_3
      t.string :ADDRESS_CITY
      t.string :ADDRESS_STATE_CODE
      t.string :ADDRESS_ZIP
      t.string :FOREIGN_POSTAL_CODE
      t.string :COUNTRY_CODE
      t.integer :BADGE_NUMBER
      t.string :BADGE_NAME
    end
  end
end
