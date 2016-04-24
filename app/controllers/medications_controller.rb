class MedicationsController < ApplicationController
  require 'open-uri'

  def index
    @medarray = []
    Medication.all.each do |med|
      if decrypt(med.userid) == viewuser.id
        @medarray.push med
      end
    end
    @medarray.sort! {|x, y| x.updated_at <=> y.updated_at}
    @medications = @medarray
  end

  def completemedsearch
  	fin = []
    #.split(' ').map(&:capitalize).join(' ')
  	MedDb.search(params[:term].downcase).each do |med|
  		if med.name.length < 15
  			fin.push med.name.split(' ').map(&:capitalize).join(' ')
  		end
  	end
  	fini = fin.sort_by(&:length)
    render json: fini[0..5]
  end

  def create
    @result = JSON.parse(open("https://rxnav.nlm.nih.gov/REST/rxcui.json?name=#{params[:name].tr(' ', '_')}&allsrc=0&search=1").read)['idGroup']['rxnormId']
    if @result
    	medication = Medication.new(:userid => params[:auth], :name => encrypt(params[:name]), :schedule => encrypt("#{params[:times]} times/#{params[:timeunit]}"), :dose => encrypt("#{params[:dosenum]}#{params[:doseun]}"), :notification_time => encrypt("#{params[:time]} #{params[:mer]}"), :interaction_id => encrypt(@result.first))
    	medication.save
    end
    redirect_to medications_index_path
  end

  def update
  	@result = JSON.parse(open("https://rxnav.nlm.nih.gov/REST/rxcui.json?name=#{params[:name].tr(' ', '_')}&allsrc=0&search=1").read)['idGroup']['rxnormId']
    if @result
    	medication = Medication.update(decrypt(params[:ident]), :name => encrypt(params[:name]), :schedule => encrypt("#{params[:times]} times/#{params[:timeunit]}"), :dose => encrypt("#{params[:dosenum]}#{params[:doseun]}"), :notification_time => encrypt("#{params[:time]} #{params[:mer]}"), :interaction_id => encrypt(@result.first))
    	medication.save
    end
    redirect_to medications_index_path
  end

  def delete
    medarray = []
    Medication.all.each do |med|
      if decrypt(med.userid) == viewuser.id
        medarray.push med
      end
    end
    medarray.sort! {|x, y| x.id <=> y.id}
    Medication.destroy(medarray[decrypt(params[:ind])].id)
    redirect_to medications_index_path
  end

  def checkforinteractions
    @interactions = []
    @interactiondescs = []
    @usermeds = []
    Medication.all.each do |medi|
    	if decrypt(medi.userid) == viewuser.id
    		@usermeds.push medi
    	end
    end
    @usermeds.each do |medication|
    	@parsedopen = JSON.parse(open("https://rxnav.nlm.nih.gov/REST/interaction/interaction.json?rxcui=#{decrypt(medication.interaction_id)}").read)
    	@trtying = @parsedopen['interactionTypeGroup']
    	if !@trtying.nil?
        	medicationinteractions = []
        	medicationinteractiondesc = []
        	@trtying[0]['interactionType'][0]['interactionPair'].each do |cyclenumber|
        		medicationinteractions.push cyclenumber['interactionConcept'][1]['minConceptItem']['name']
       			medicationinteractiondesc.push cyclenumber['description']
        	end
        	if !medicationinteractions.nil?
        		i = 0
        		medicationinteractions.each do |notgood|
        			i += 1 
            		@usermeds.each do |med|
            			if decrypt(med.name).upcase == notgood.upcase
       		    			@interactions.push "#{decrypt(med.name)} and #{decrypt(medication.name)}"
        	        		lastvari = medicationinteractiondesc[i - 1]
        	    			@interactiondescs.push lastvari
        	    		end
        			end
        		end
        	end
    	end
    end
    if @interactions.length != 0
   		html = "<p id = 'interactions-found'>#{@interactions.length} interaction#{"s" unless @interactions.length == 1} found</p><img src = '/assets/alert-icn.png' class = 'alert-img'>"
   		m = 0
   		for inter in @interactions
   			html = html + "<div class = 'interaction-box'>
					<p class = 'int-title'>#{inter}</p>
					<div class = 'int-divider'></div>
					<p class = 'int-body'>#{@interactiondescs[m]}</p>
				</div>"
   			m += 1
   		end
   	else
   		html = "<p style = 'text-align: center; padding: 30px 0 15px 0;'>No Interactions Found</p>"
   	end
    render :html => html.html_safe
  end

end









