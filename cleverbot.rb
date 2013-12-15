require 'cinch'
require 'cleverbot'
#binding.pry
module Cinch
	module Plugins
		class Cleverbot
			include Cinch::Plugin 

			match lambda { |m| /^#{m.bot.nick}:(\s)+(.+)/i }, use_prefix: false 
			#in lambda so that the line is evaluated each time. the regex is a match to anything said to the bot

			def initialize(*args)
				super
				#super called in order to call the same method from the parent class and then adding our thing (next line)
				@cleverbot = ::Cleverbot::Client.new #:: means look not at this namespace but at the very top and search down.
			end

			def execute(m, sep, message) #seperator
				msg_back = @cleverbot.write message
				m.reply msg_back, true
			end
		end
	end
end
