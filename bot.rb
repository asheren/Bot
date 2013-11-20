require 'cinch'

bot = Cinch::Bot.new do #using cinch to create a new bot. The new method takes a block
  configure do |c| #In the block. configuring (method configure) that also takes a block
                  #and passes in cinch configuration for the bot. passes a reference to itself that you can configure
    c.server = 'irc.freenode.net' #the server we're connecting to 
    c.realname = 'DictaBot' #real name that shows up in who's there list in irc
   # c.password = ENV['IRC_PASS'] password used to connect to IRC server. don't need one for freenode
 
      c.channels = ['#testchan'] #the channel the bot connects to 
      c.user = 'Dictabot' #actual name of the bot
      c.nick = c.user #sets nickname as same as user name
  end

  on :message, "hello" do |m| #when a message happens that says hello, call my block
    m.reply "Hello, #{m.user.nick}"
  end

  on :message, /cheer up (.*)/ do |m, name| #via cinch amazingness, it uses a regex to find the parameters and pass in that information
    m.reply "feel better, #{name}"
  end
end


bot.start 

