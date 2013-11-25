#Rosie the Bot

require 'cinch'
require 'open-uri'
require 'json'

bot = Cinch::Bot.new do #using cinch to create a new bot. The new method takes a block
  configure do |c| #In the block. configuring (method configure) that also takes a block
                  #and passes in cinch configuration for the bot. passes a reference to itself that you can configure
    c.server = 'irc.freenode.net' #the server we're connecting to 
    c.realname = 'Rosie' #real name that shows up in who's there list in irc
   # c.password = ENV['IRC_PASS'] password used to connect to IRC server. don't need one for freenode
 
      c.channels = ['#rosie'] #the channel the bot connects to 
      c.user = 'Rosie' #actual name of the bot
      c.nick = c.user #sets nickname as same as user name
  end

  on :message, "hello" do |m| #when a message happens that says hello, call my block
    m.reply "Hello, #{m.user.nick}"
  end

  on :message, /cheer (.*?) | up (.*)/ do |m, name| #via cinch amazingness, it uses a regex to find the parameters and pass in that information
    m.reply "feel better, #{name}"
  end

  on :message, /.*weather.*/ do |m|
    open("http://api.wunderground.com/api/d7aa1bd257c65230/geolookup/conditions/q/DC/Washington.json") do |f|
      json_string = f.read
      parsed_json = JSON.parse(json_string)
      location = parsed_json['location']['city']
      temp_f = parsed_json['current_observation']['temp_f']
      weather = parsed_json['weather'] #not working
      m.reply "Current temperature in #{location} is: #{temp_f} and conditions are #{weather}\n"
    end
  end

  on :message, /.*morning.*/ do |m|
    message = [
      [:reply, "Good morning to you too!"],
      [:reply, "it's a brand new day!"],
      [:reply, "I'm sleepy today"],
      [:action, "yawns"],
      [:action, "makes coffee"],
      [:action, "*throws open all the windows* it's a glorious day today"]
    ]
    m.reply message.sample #comes out with the brackets.
  end
  #when someone says they're angry or frustrated... have teresa flipping a table
  on :message, /.*(angr|frustr|annoy).*/i do |m| #permelink: http://rubular.com/r/xwJ6lsIOE3
    gifs = [
      "http://buzzworthy.mtv.com//wp-content/uploads/buzz/2013/10/giphy1.gif",
      "http://25.media.tumblr.com/f9c10ad19d909a351b5bbec90b08064c/tumblr_murtfzl9N81ql5yr7o1_500.gif",
      "http://i.perezhilton.com/wp-content/uploads/2013/06/real-housewives-new-jersey-drama-back.gif",
    ]
    m.reply gifs.sample
  end #last link not working

  #cheer up, provides a unicorn/rainbow butterfly picture

  #asking for Rosie 
 # http://31.media.tumblr.com/fe021d747a605a8a7cba5767011251e1/tumblr_mjpo4q44aj1rjatglo1_500.gif

  #coffee responses
  # http://wac.9ebf.edgecastcdn.net/809EBF/ec-origin.chicago.barstoolsports.com/files/2012/12/badcoffee.gif
  # http://thoughtcatalog.files.wordpress.com/2013/08/tumblr_ln3pef2aly1qaq98ro1_400.gif%3Fw%3D400%26h%3D211
  # http://25.media.tumblr.com/57acd60ebc217bc00169fd73b52be5a6/tumblr_mi5u4eeJZv1qcwyxho1_500.gif
  # https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSP8TfZHYrpS1Hz2jM_vdwOToNN949vYDPFZ74G3vw41r4rNH6k


  #squirrel

  #score keeper

  #collection of URLs for the week

  #trivia

  #I am batman

  #district taco mention
  # http://images5.fanpop.com/image/photos/30300000/Da-best-3-mean-girls-30385685-500-225.gif
  # http://25.media.tumblr.com/22d830dbc9bd5de756417f2e009e9e65/tumblr_mtbufrOGsO1ql5yr7o1_500.gif
  # http://bcgavel.com/wp-content/uploads/2013/11/Gilmore-Girls-gif.gif

  # #random
  # http://i.perezhilton.com/wp-content/uploads/2013/02/teresa-giudice-joe-testimony.gif #do I look fazed

  # #lol
  # http://26.media.tumblr.com/tumblr_lsx76yuu0U1qa4vt9o1_500.gif

  # #something related to code
  # http://lifeisopinion.ca/content/images/2013/Oct/Sneakers-1.gif
  # http://1.bp.blogspot.com/-MHsyzGREaOM/UE5i5Virs4I/AAAAAAAACV0/3ThUl1CGw9o/s1600/320.jpg

  #clean up
  http://www.appliancesonlineblog.com.au/wp-content/uploads/2012/03/Rosie-from-The-Jetsons.jpg

end


bot.start 

