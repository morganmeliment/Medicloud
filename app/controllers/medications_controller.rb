class MedicationsController < ApplicationController
  def index
  	@medications = Medication.where(:userid => viewuser.id)
  end
end
