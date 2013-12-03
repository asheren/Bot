#Rosie the Bot ##alternate name sababot

require 'cinch'
require 'open-uri'
require 'json'
require 'pry'
require 'sequel'
DB = Sequel.connect('sqlite://bot.db') #sets a global constant called DB

score = DB[:score] 

score.insert(:nick => 'rosie', :points => 10)

#TODO ###class Score and with an end at the end of this class. make an instance score = score.new and figure out some of the procedural stuff in there
def nick_id(nick) #find out if a nick is already in the DB or if we need to create it
  set = DB[:score].where(:nick => nick) #finds the list of every score that has the nickname nick (nick being whatever the person's nick is)
  if set.empty? #if it doesn't find anything
    nil #returns nil
  else
    set.first[:id] #otherwise grab the id of the first and return it. it'll return the id and not the nick
  end
end

def insert_or_update_score(nick, points)
  if nick_id(nick)
    #1. fetch 2. increment number 3. save it back
    row = DB[:score].where(:id => nick_id(nick)).first
    updated_points = row[:points] + points 
    DB[:score].where(:id => nick_id(nick)).update(:points => updated_points)
  else
    DB[:score].insert(:nick => nick, :points => points) #creates a new nick in the DB and gives it the points
  end
end





bot = Cinch::Bot.new do #using cinch to create a new bot. The new method takes a block
  configure do |c| #In the block. configuring (method configure) that also takes a block
                  #and passes in cinch configuration for the bot. passes a reference to itself that you can configure
    c.server = 'irc.freenode.net' #the server we're connecting to 
    c.realname = 'Rosie' #real name that shows up in who's there list in irc
   # c.password = ENV['IRC_PASS'] password used to connect to IRC server. don't need one for freenode
 
      c.channels = ['#rosie'] #the channel the bot connects to 
      c.user = 'Rosie_' #actual name of the bot #TODO: register rosie_
      c.nick = c.user #sets nickname as same as user name
  end

  #hi permalink: http://rubular.com/r/S8j2JhJaMf
  on :message, /\bh(i|ello)\b/i do |m| #when a message happens that says hello, call my block
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
      [:reply, "http://gifrific.com/wp-content/uploads/2012/04/bunny-sleep-work.gif"],
      [:action, "yawns"],
      [:action, "makes coffee"],
      [:action, "*throws open all the windows* it's a glorious day today"]
    ]
    msg = message.sample     # Pick a random value from the "message" array (e.g. [:action, "smiles"])
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
      "http://www.reactiongifs.com/wp-content/uploads/2013/09/so-mad-i-could.gif",
    ]
    m.reply gifs.sample
  end 

  on :message, /#{config.nick}\?/i do |m| #asking for Rosie permalink: http://rubular.com/r/StuBnfzUE6
    response = [
      [:reply, "Did someone ask for me?"],
      [:reply, "http://31.media.tumblr.com/fe021d747a605a8a7cba5767011251e1/tumblr_mjpo4q44aj1rjatglo1_500.gif"],
      [:reply, "what do you want now?"],
      [:reply, "#{m.user.nick}, why are you bothering me?"],
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

  #squirrel- taken from Radbot: https://github.com/csexton/radbot/blob/master/bot.rb
  on :message do |m|
    if rand(500) == 0
      m.reply "SQUIRREL!"
    end
  end

  on :message, /squirrel/i do |m|
    m.reply "SQUIRREL!"
  end

  # #random
  # http://i.perezhilton.com/wp-content/uploads/2013/02/teresa-giudice-joe-testimony.gif #do I look fazed

  ##todo: find more lol responses
  on :message, /\blol\b/i do |m| #lol permalink: http://rubular.com/r/rp8qmLsmvP
    images = [
      "http://26.media.tumblr.com/tumblr_lsx76yuu0U1qa4vt9o1_500.gif",
      "http://t1.gstatic.com/images?q=tbn:ANd9GcRHO011b4PdAtKNYAzDfMm1aBeW_EW5afQ8wgEdRvI1eYQZB0o0",
      "http://i.imgur.com/PgP44.png",
    ]
    m.reply images.sample
  end

  on :message, /.*joke.*/i do |m| #rosie, tell me a joke permalink: http://rubular.com/r/nj5dZuQfnk
    responses = [
      "It’s hard to explain puns to kleptomaniacs because they always take things literally.",
      "What does a nosey pepper do? Get jalapeño business.",
      "You kill vegetarian vampires with a steak to the heart.",
      "If you want to catch a squirrel just climb a tree and act like a nut.",
      "Did you hear about the Mexican train killer? He had locomotives.",
      "How does NASA organize their company parties? They planet.",
      "Why does Snoop Dogg carry an umbrella? Fo’ drizzle.",
      "What did Jay-Z call his girlfriend before they got married? Feyoncé.",
      "How many kids with ADHD does it take to change a light bulb? Let’s go play on our bikes.",
      "What do you call dangerous precipitation? A rain of terror.",
      "What’s the best part about living in Switzerland? Not sure, but the flag is a big plus.",
      "Why can’t a bike stand on its own? It’s two tired.",
      "What do you call a big pile of kittens? A meowntain.",
      "I wrote a song about a tortilla. Well actually, it’s more of a wrap.",
      "How did the hipster burn his tongue? He drank his coffee before it was cool.",
      "You want to hear a pizza joke? Never mind, it’s pretty cheesy.",
      "Dry erase boards are remarkable.",
    ]
    m.reply responses.sample
  end


  on :message, /.*(district taco).*/i do |m| #district taco mention permalink: http://rubular.com/r/HyGCwpSps9
    gifs = [
      "http://images5.fanpop.com/image/photos/30300000/Da-best-3-mean-girls-30385685-500-225.gif",
      "http://25.media.tumblr.com/22d830dbc9bd5de756417f2e009e9e65/tumblr_mtbufrOGsO1ql5yr7o1_500.gif",
      "http://bcgavel.com/wp-content/uploads/2013/11/Gilmore-Girls-gif.gif",
    ]
    m.reply gifs.sample
  end

  on :message do |m| #randomly say "I am Batman"
    if rand(500) == 0 #to test, change random number to a number you would expect to get forcing it to respond
      m.reply "I am Batman!"
    end
  end

  on :message, /\b(I love|I hate) .*cod.*/i do |m| # love or hate code permalink:  http://rubular.com/r/XJX6N4Z2Rj
    images = [
      "http://lifeisopinion.ca/content/images/2013/Oct/Sneakers-1.gif",
      "http://leaksource.files.wordpress.com/2013/04/hacker-programming.gif",
    ]
    m.reply images.sample
  end

  on :message, /.*(refactor).*/i do |m| #refactor permalink: http://rubular.com/r/Kdg7UFlKnr
    reply = [
      "http://www.appliancesonlineblog.com.au/wp-content/uploads/2012/03/Rosie-from-The-Jetsons.jpg",
      "My software never has bugs. It just develops random features",
    ]
    m.reply reply.sample
  end

  #TODO #add a command that looks for a + or - number, then parses the string and turn it into a value for points
    #will need a regex + - number word kind of thing. a bot :on message command that calls insert_or_update score and 
    #then a command that will list db[:score].all
  on :message, /\W\d+\s\w*/ do |m| # + or - number #{user.nick} permalink: http://rubular.com/r/sf7ZZ8IZeN
    m.reply insert_or_update_score(nick, points)
  end

  on :message, /.*my.score.*/i do |m| #what's my score permalink: http://rubular.com/r/LtWE7EkqFD
    m.reply DB[:score].nick 
  end

  on :message, /.*score.*/i do |m| #scoreboard permalink: http://rubular.com/r/7GefKYh7UJ
    m.reply DB[:score].all
  end

  #collection of URLs for the week

  #trivia
end


bot.start 

