# appetito


## About
We are a platform (messaging) and content (restaurants) provider.
We are operating under the assumption that on a everyday basis people choose a restaurant based on location and convenience, but we have also accounted for the fact that cuisine, price range, and ratings are important.

## Team Members

- Eunice Kim, Product Manager
- Ciara Foran, Web Developer
- George Lu, Web Developer
- Remin Greenfield, Web Developer
- Scott Morgenthaler, UX Designer

## How it Works

The app is built around organizing events and inviting your friends to vote on a location relative to the location of everyone's location.

### Friends / Contacts

Each person has a privacy setting. Depending on this setting you can either add another person as a contact immediately or send a 'Friend Request'.

Search results appear instantly. And you can add or request friends in the modal.

### Notifications

The notification system uses single table inheritance to separate friend requests, event invites, event updates, and invite rsvps into seperate models that are recorded in the same table.

```ruby
class Notification < ActiveRecord::Base
	attr_accessor :message
  belongs_to :user
  belongs_to :event

  after_update :check_accept_status

  scope :friend_requests, -> { where(type: 'FriendRequest')}
  scope :event_invites, -> { where(type: 'EventInvite')}
  scope :event_updates, -> { where(type: 'EventUpdates')}
  scope :invite_rsvps, -> { where(type: 'InviteRSVPs')}
end

```

### Events

The events are the main focus of the app. Each user can see the events they are invited to and set their rsvp.

Once invited they set their location and can immediately start searching for restaurants.

Each invitee location that is set creates a marker in google maps and the bounds.

Then a radius is created based on distance of the min/max of the map's longitude and latitude. The search results are bound to that radius relative to the center of the map.

The app uses the Foursquare API where the search result is dictated by type of cuisine, price, and reservation status.As the user you can add the search results to a list of restaurants where other users can vote on a location.

Each event also has a built in chat client using websocket.io and node.js which is deployed seperately.
