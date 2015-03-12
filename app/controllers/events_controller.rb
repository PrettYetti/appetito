class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = current_user.events if current_user
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @notifications = @event.notifications
    @invitees = @event.invites
  end

  # GET /events/new
  def new
    if current_user
      @friends = current_user.friends
      @event = current_user.events.new
    else
      @event = Event.new
    end
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    invitees = params[:user_id]
    @event = current_user.events.new(event_params)
    respond_to do |format|
      if @event.save
        invitees.each do |id| 
          @event.event_invites.create(user_id: id, sender_id: current_user.id)
          @event.invites.create(user_id: id)
        end
        @event.invites.create(user_id: current_user.id, rsvp: true)
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:user_id, :name, :when, :location, :finalized, :cuisine)
    end
end
