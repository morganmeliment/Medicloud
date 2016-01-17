class MedicationsController < ApplicationController
  def index
  	@medications = Medication.where(:userid => viewuser.id)
  end

  def completemedsearch
  	fin = []
    #.split(' ').map(&:capitalize).join(' ')
  	MedDb.search(params[:term]).each do |med|
  		if med.name.length < 15
  			fin.push med.name
  		end
  	end
  	fini = fin.sort_by(&:length)
    render json: fini[0..5]
  end
end
