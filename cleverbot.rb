require 'cinch'

module Cinch
	module Plugins
		class Cleverbot
			require 'cleverbot'
			include Cinch::Plugin 

			match lambda { |m| /^#{m.bot.nick}(:|\s)+(.+)/i }, use_prefix: false 
			#why lambda here? and is this a match to anything said to the bot?

			def initialize(*args)
				super
				#why super?
				@cleverbot = Cleverbot::Client.new
			end

			def execute(m, sep, message) #sep??
				msg_back = @clevebot.write message
				m.reply msg_back, true
			end
		end
	end
end
