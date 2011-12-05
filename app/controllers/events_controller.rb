class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  # GET /events.xml
  def index
    @events = Event.approved

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
      format.xml
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])


    if params[:start_time_date].empty? or params[:end_time_date].empty?
      flash[:error] = 'You must give a date'
      @event.errors.add :start_time, "You need to input a date"
    else
      @event.start_time = @event.merge_times(params['start_time_date'], params[:event][:start_time])
      @event.end_time = @event.merge_times(params['end_time_date'], params[:event][:end_time])      
    end



    respond_to do |format|
      if @event.errors.empty? and @event.save 
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    if params[:start_time_date].empty? or params[:end_time_date].empty?
      flash[:error] = 'You must give a date'
      @event.errors.add :start_time, "You need to input a date"
    else
      @event.start_time = @event.merge_times(params['start_time_date'], params[:event][:start_time])
      @event.end_time = @event.merge_times(params['end_time_date'], params[:event][:end_time])      
    end

    respond_to do |format|
      if @event.errors.empty? and @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :ok }
    end
  end

  def approve
    @event = Event.find(params[:id])
    @event.approve_event
    @event.save
    respond_to do |format|
      format.html { redirect_to approval_url }
      format.json { head :ok }
    end
  end

  def decline
    @event = Event.find(params[:id])
    @event.decline_event
    @event.save
    respond_to do |format|
      format.html { redirect_to approval_url }
      format.json { head :ok }
    end
  end
end
