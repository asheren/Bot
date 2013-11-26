#Rosie the Bot ##alternate name sababot

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
      c.user = 'Miss_Rosie' #actual name of the bot ##rosie is taken... does the bot need to be registered?
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
      weather = parsed_json['current_observation']['weather'] 
      feelslike_f = parsed_json['current_observation']['feelslike_f']
      m.reply "Current temperature in #{location} is: #{temp_f} F but it feels like #{feelslike_f} F. Conditions are #{weather}.\n"
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
    msg = response.sample     # Pick a random value from the "message" array (e.g. [:action, "smiles"])
    if msg.first == :action     # See what the first element in that array is (e.g. [:action, "smiles"].first => :action)
      m.channel.action msg.last # If it equals :action, then "/me" it to the channel
    else
      m.reply msg.last  # Otherwise just reply like normal
    end #comes out with the brackets.
  end
 
  on :message, /.*(angr|frustr|annoy).*/i do |m| #permalink: http://rubular.com/r/xwJ6lsIOE3
    gifs = [
      "http://buzzworthy.mtv.com//wp-content/uploads/buzz/2013/10/giphy1.gif",
      "http://25.media.tumblr.com/f9c10ad19d909a351b5bbec90b08064c/tumblr_murtfzl9N81ql5yr7o1_500.gif",
      "http://i.perezhilton.com/wp-content/uploads/2013/06/real-housewives-new-jersey-drama-back.gif",
    ]
    m.reply gifs.sample
  end 

  on :message, /Rosie\?/i do |m, name| #asking for Rosie permalink: http://rubular.com/r/StuBnfzUE6
    response = [
      [:reply, "Did someone ask for me?"],
      [:reply, "http://31.media.tumblr.com/fe021d747a605a8a7cba5767011251e1/tumblr_mjpo4q44aj1rjatglo1_500.gif"],
      [:reply, "what do you want now?"],
      [:reply, "#{name}, why are you bothering me?"],
      [:reply, "it wasn't me."],
      [:reply, "yyyyeessss?"],
      [:action, "hides"],
    ]
    msg = response.sample     # Pick a random value from the "message" array (e.g. [:action, "smiles"])
    if msg.first == :action     # See what the first element in that array is (e.g. [:action, "smiles"].first => :action)
      m.channel.action msg.last # If it equals :action, then "/me" it to the channel
    else
      m.reply msg.last  # Otherwise just reply like normal
    end
  end
 

  on :message, /.*(coffee).*/i do |m|
    gifs = [
      "http://wac.9ebf.edgecastcdn.net/809EBF/ec-origin.chicago.barstoolsports.com/files/2012/12/badcoffee.gif",
      "http://thoughtcatalog.files.wordpress.com/2013/08/tumblr_ln3pef2aly1qaq98ro1_400.gif%3Fw%3D400%26h%3D211",
      "http://25.media.tumblr.com/57acd60ebc217bc00169fd73b52be5a6/tumblr_mi5u4eeJZv1qcwyxho1_500.gif",
      "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSP8TfZHYrpS1Hz2jM_vdwOToNN949vYDPFZ74G3vw41r4rNH6k",
      "COOOFFFEEEEE!",
    ]
    m.reply gifs.sample
  end

  #squirrel

  #score keeper

  #collection of URLs for the week

  #trivia

  # #random
  # http://i.perezhilton.com/wp-content/uploads/2013/02/teresa-giudice-joe-testimony.gif #do I look fazed

  # #lol
  # http://26.media.tumblr.com/tumblr_lsx76yuu0U1qa4vt9o1_500.gif

  on :message, /.*(district taco).*/i do |m| #district taco mention permalink: http://rubular.com/r/HyGCwpSps9
    gifs = [
      "http://images5.fanpop.com/image/photos/30300000/Da-best-3-mean-girls-30385685-500-225.gif",
      "http://25.media.tumblr.com/22d830dbc9bd5de756417f2e009e9e65/tumblr_mtbufrOGsO1ql5yr7o1_500.gif",
      "http://bcgavel.com/wp-content/uploads/2013/11/Gilmore-Girls-gif.gif",
    ]
    m.reply gifs.sample
  end

  on :message do |m| #randomly say "I am Batman"
    if rand(500) == 0
      m.reply "I am Batman!"
    end
  end

  on :message, /\b(I love|I hate) .*cod.*/i do |m| # love or hate code permalink:  http://rubular.com/r/XJX6N4Z2Rj
    images = [
      "http://lifeisopinion.ca/content/images/2013/Oct/Sneakers-1.gif",
    ]
    m.reply images.sample
  end

  on :message, /.*(refactor).*/i do |m| #refactor permalink: http://rubular.com/r/Kdg7UFlKnr
    reply = [
      "http://www.appliancesonlineblog.com.au/wp-content/uploads/2012/03/Rosie-from-The-Jetsons.jpg",
    ]
    m.reply reply.sample
  end
end


bot.start 

