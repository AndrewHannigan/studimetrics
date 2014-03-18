class RenameCriticalReadingToReading < ActiveRecord::Migration
  def up
    critical_reading = Subject.where(name: "Critical Reading").first
    if (critical_reading!=nil)
      critical_reading.update_attributes(name: "Reading")
    end
  end

  def down
    critical_reading = Subject.where(name: "Reading").first
    critical_reading.update_attributes(name: "Critical Reading")
  end
end
