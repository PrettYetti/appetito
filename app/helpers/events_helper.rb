module EventsHelper

	def info_html(user_name)
		return "<strong style='color: blue;'>#{user_name}</strong>"
	end

	def api(coordinates)
		json = ''
		
		File.open('secret.json', 'r') do |f|
		  f.each_line do |line|
		    json << line
		  end
		end

		consumer_key = json_hash['key']
		consumer_secret = json_hash['con_secret']
		token = json_hash['token']
		token_secret = json_hash['token_secret']

		Yelp.client.configure do |config|
		  config.consumer_key = consumer_key
		  config.consumer_secret = consumer_secret
		  config.token = token
		  config.token_secret = token_secret
		end

		params = { term: "food", limit: 5, }


	end
end
