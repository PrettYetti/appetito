george = User.create(
	{
		name: "George",
		email: "george@email.com",
		password: "password"
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
		password: "password"
	}
)

eunice = User.create(
	{
		name: "Eunice",
		email: "eunice@email.com",
		password: "password"
	}
)

george.events.create({
	name: "PartyHarty",
	location: "someplace",
	cuisine: "mexican"
	})

ciara.events.create({
	name: "PartyHarty",
	location: "someplace",
	cuisine: "mexican"
	})

remina.events.create({
	name: "PartyHarty",
	location: "someplace",
	cuisine: "mexican"
	})

eunice.events.create({
	name: "PartyHarty",
	location: "someplace",
	cuisine: "mexican"
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