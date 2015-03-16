george = User.create(
	{
		name: "George",
		email: "george@email.com",
		password: "password",
		privacy: true
	}
)

ciara = User.create(
	{
		name: "Ciara",
		email: "ciara@email.com",
		password: "password"
	}
)

remina = User.create(
	{
		name: "Remina",
		email: "remina@email.com",
		password: "password",
		privacy: true
	}
)

eunice = User.create(
	{
		name: "Eunice",
		email: "eunice@email.com",
		password: "password"
	}
)


george.created_events.create({
	name: "PartyHarty",
	location: "someplace",
	cuisine: "mexican"
	})

ciara.created_events.create({
	name: "HangerMeats",
	location: "someplace",
	cuisine: "chinese"
	})

remina.created_events.create({
	name: "Chumba Wumba",
	location: "someplace",
	cuisine: "American"
	})

eunice.created_events.create({
	name: "Tom's Bistro",
	location: "someplace",
	cuisine: "French"
	})

george.friend_ids=[2,3]
remina.friend_ids=[1,4]
ciara.friend_ids=[1,4]
eunice.friend_ids=[2,3]


[
	{
		user_id: 1,
		sender_id: 2,
		event_id: 2
	},
	{
		user_id: 2,
		sender_id: 4,
		event_id: 4
	},
	{
		user_id: 3,
		sender_id: 1,
		event_id: 1
	},
	{
		user_id: 4,
		sender_id: 3,
		event_id: 3
	}

].each { |event| EventInvite.create(event)}

[
	{
		user_id: 1,
		sender_id: 4
	},
	{
		user_id: 2,
		sender_id: 3
	},
	{
		user_id: 3,
		sender_id: 2
	},
	{
		user_id: 4,
		sender_id: 1
	}
].each { |friend| FriendRequest.create(friend)}

[
	{
		user_id: 1,
		event_id: 1,
		rsvp: "Attending",
		location: "3 East 14th street, New York, NY 10003"
	},
	{
		user_id: 2,
		event_id: 1,
		rsvp: "Maybe",
		location: "893 BROADWAY, FLATIRON DISTRICT, NEW YORK, NY 10003"
	},
	{
		user_id: 3,
		event_id: 1,
		rsvp: "Not Attending",
		location: "10 East 21st Street, 4th Floor, New York, NY 10010"
	},
	{
		user_id: 1,
		event_id: 2,
		rsvp: "Maybe",
		location: "3 East 14th street, New York, NY 10003"
	},
	{
		user_id: 2,
		event_id: 2,
		rsvp: "Attending",
		location: "10 Lincoln Center Plaza, New York, NY 10023"
	},
	{
		user_id: 4,
		event_id: 2,
		rsvp: "Not Attending",
		location: "1 World Trade Center, New York, NY 10006"
	},
	{
		user_id: 1,
		event_id: 3,
		rsvp: "Not Attending",
		location: "77-08 Woodside Ave, Queens, NY 11373"
	},
	{
		user_id: 3,
		event_id: 3,
		rsvp: "Attending",
		location: "34-08 31st Ave, Astoria, NY 11106"
	},
	{
		user_id: 4,
		event_id: 3,
		rsvp: "Attending",
		location: "38-12 Prince St, Flushing, NY 11354"
	},
	{
		user_id: 2,
		event_id: 4,
		rsvp: "Maybe",
		location: "990 Washington Ave, Brooklyn, NY 11225"
	},
	{
		user_id: 3,
		event_id: 4,
		rsvp: "Maybe",
		location: "1 Front St, New York, NY 11201"
	},
	{
		user_id: 4,
		event_id: 4,
		rsvp: "Attending",
		location: "1 Beard St, Brooklyn, NY 11231"
	}

].each { |friend| Invite.create(friend)}