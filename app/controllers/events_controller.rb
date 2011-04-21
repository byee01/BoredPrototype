class EventsController < ApplicationController

respond_to :html, :js, :json
  # GET /events
  # GET /events.xml
  def index
    @events = Event.all.upcoming
	@my_events = Event.where(:user_id => 1)
	@event = Event.new
	
	@logged_in_user = 1

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new
	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
	
	respond_to do |format|
		format.html
		format.js do
			
		end
	end
  end
  
  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
	@logged_in_user = 1
	@event.user_id = @logged_in_user
    respond_to do |format|
      if @event.save
        format.html { redirect_to(@event, :notice => 'Event was successfully created.') }
		format.js do
			responds_to_parent {render}
		end
      else
	  puts @event.errors
        format.html { render :action => "new" }
		format.js do 
			responds_to_parent{render}
		end
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

		puts "does it even get here?"
    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
        format.js do
			responds_to_parent {render}
		end
      else
        format.html { render :action => "edit" }
        format.js do
			responds_to_parent{render}
		end
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
	
    respond_to do |format|
	  if @event.destroy
		@my_events = Event.where(:user_id => 1)
      format.html { redirect_to(list_events_path) }
      format.js do
		responds_to_parent{render}
	  end
	  end
    end
  end
  
  def list
	@events = Event.all
	
	 respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
	
  end
  
  def approve
	@event = Event.find(params[:id])
	@event.active = true
	
	respond_to do |format|
		 if @event.save
			format.html { redirect_to(list_events_path, :notice => 'Event was successfully approved.') }
		 else
			format.html { redirect_to(list_events_path, :notice => 'Event could not be approved.') }
		end
	end
	
  end
  
  def disapprove
	@event = Event.find(params[:id])
	@event.active = false
	
	respond_to do |format|
		 if @event.save
			format.html { redirect_to(list_events_path, :notice => 'Event was successfully disapproved.') }
		 else
			format.html { redirect_to(list_events_path, :notice => 'Event could not be disapproved.') }
		end
	end
  end
  
  def search
	num_events = 20
	query = params[:search]
	
	@search_results =  Event.description_like("").limit(num_events)
	respond_with @search_results
  end

  def date_input
    require 'chronic'
    @date_input  = Chronic.parse(params[:date], :context => :future)
    puts @date_input
    respond_with @date_input
  end
end