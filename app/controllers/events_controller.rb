class EventsController < ApplicationController
  include EventsHelper
  before_action :set_event, only: [:show, :edit, :update, :destroy, :chatlog, :add_favorite, :logchat]

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
    located = @invitees.where("location IS NOT NULL") 

      # rsvp = 'Attending' OR rsvp = 'Maybe' OR rsvp = 'Undecided'"
    @chatlog = @event.chatlogs
    @hash = Gmaps4rails.build_markers(located) do |invitee, marker|
      marker.lat invitee.latitude
      marker.lng invitee.longitude
      #info window settings accept html (using info_html helper)
      marker.json({:id => invitee.user.id, :name => invitee.user.name})
    end
  end

  # GET /events/new
  def new
    if current_user
      @friends = current_user.friends
      @event = current_user.created_events.new
    else
      @event = Event.new
    end
  end

  # GET /events/1/edit
  def edit
  end

  def chatlog
    chatlog = @event.chatlogs
    #need to limit to 50
    invitees = @event.users
    invitee_avatars = invitees.map { |invitee| {avatar_url: invitee.avatar.url(:icon), id: invitee.id}}
    respond_to do |format|
      format.json { render json: {chatlog: chatlog, current_user: current_user, invitees: invitees, invitee_avatars: invitee_avatars, avatar_url: current_user.avatar.url(:icon)}}
    end
  end

  def logchat
    @event.chatlogs.create(message: params[:message], user_id: current_user.id)
    respond_to do |format|
      format.json { render json: {message: "message received"} }
    end
  end

  def add_favorite
    favorite = @event.favorites.create(user_id: current_user.id, restaurant: params[:restaurant])
    respond_to do |format|
      format.json { render json: {favorite: favorite, favorites: @event.favorites }}
    end

  end

  # def yelp
  #   binding.pry
  #   coordinates = params[:coordinates]
  #   api(coordinates)
  # end

  # def foursquare
  #   baseURL = "https://api.foursquare.com/v2/venues/explore"
  #   clientID = "?client_id=CSXMPXYF20VXWMX4Z0BTKHVT5VGRKA1E3ZAPKCE04ELOMX3W"
  #   clientSecret = "&client_secret=LQ2UIGEDAP0O5CFMQEMEYEM1KORYH4ISVPXLRSHGYNU1LMOZ"

  #   render text: Net::HTTP.get baseURL + clientID + clientSecret + '&' + params[:foursquare].to_param
  # end

  # POST /events
  # POST /events.json
  def create
    invitees = params[:user_id]
    @event = current_user.created_events.new(event_params)
    respond_to do |format|
      if @event.save
        invitees.each do |id| 
          # binding.pry
          @event.event_invites.create(user_id: id, sender_id: current_user.id)
          @event.invites.create(user_id: id)
        end
        @event.invites.create(user_id: current_user.id, rsvp: "Attending")
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
