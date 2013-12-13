#Rosie the Bot ##alternate name sababot

require 'cinch'
require 'open-uri'
require 'json'
require 'pry'
require 'sequel'
require_relative 'db'
require_relative 'cleverbot'

#binding.pry 

bot = Cinch::Bot.new do #using cinch to create a new bot. The new method takes a block
  configure do |c| #In the block. configuring (method configure) that also takes a block
                  #and passes in cinch configuration for the bot. passes a reference to itself that you can configure
    c.server = 'irc.freenode.net' #the server we're connecting to 
    c.realname = 'Rosie' #real name that shows up in who's there list in irc
   # c.password = ENV['IRC_PASS'] password used to connect to IRC server. don't need one for freenode
 
      c.channels = ['#arlingtonruby'] #the channel the bot connects to 
      c.user = 'rosiebot' #actual name of the bot #TODO: register rosie_
      c.nick = c.user #sets nickname as same as user name
      c.plugins.plugins = [Cinch::Plugins::Cleverbot]
  end

    
 

  #hi permalink: http://rubular.com/r/S8j2JhJaMf
  on :message, /\bh(i|ello)\b/i do |m| #when a message happens that says hello, call my block
    m.reply "Hello, #{m.user.nick}"
  end

  on :message, /cheer up (.*)/ do |m, name| #via cinch amazingness, it uses a regex to find the parameters and pass in that information
    m.reply "feel better, #{m.user.nick}"
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
 
  on :message, /.*(compliment #{m.user.nick}).*/i do |m|
    responses = [
      "#{m.user.nick}, you're wonderful",
      "#{m.user.nick}, you're fantastic",
      "#{m.user.nick}, you make me want to be a better bot",
      "#{m.user.nick}, your code is legendary",
      "#{m.user.nick}, your code is like the things dreams are made of",
      "#{m.user.nick}, you're so pretty",
      "http://31.media.tumblr.com/tumblr_mbgemfUDEw1riqizno1_500.gif",
      "http://big.assets.huffingtonpost.com/Ryan1.gif",
    ]
    m.reply responses.sample
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

   on :message do |m|
    if rand(500) == 0
      m.reply "http://girlsgonegeek.files.wordpress.com/2013/01/liz-lemon-im-a-princess.gif"
    end
  end

  # on :message, /squirrel/i do |m| #because arlington ruby can't have nice things
  #   m.reply "SQUIRREL!"
  # end

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
      "http://24.media.tumblr.com/83f38af57b95f9f98204409cf1f7c37e/tumblr_mh3es6vGIT1rxnegyo5_500.gif",
    ]
    m.reply reply.sample
  end

  on :message, /([+-]\d+)\s+(\w*)/ do |m, points, nick| # + or - number #{user.nick} permalink: http://rubular.com/r/x47YbN2Sea
    if nick == m.user.nick 
      m.reply "No points for you! As punishment -100 points"
      DB.instance.insert_or_update_score(nick, -100)
    else
      if nick && points 
        DB.instance.insert_or_update_score(nick, points.to_i)
        m.reply "#{nick} has #{DB.instance.lookup_score(nick)} points"
      end
    end
  end

  on :message, /#{config.nick}.*my.score.*/i do |m| #what's my score permalink: http://rubular.com/r/LtWE7EkqFD
    #binding.pry
    score = DB.instance.lookup_score(m.user.nick)
    if score 
      m.reply "#{m.user.nick} Your score is: #{score} points"
    else
      m.reply "You have no points, which is sad."
    end
  end

  on :message, /#{config.nick}.*leaderboard.*/i do |m| #scoreboard permalink: http://rubular.com/r/7GefKYh7UJ 
    m.reply "            Leaderboard"
    db = DB.instance 
    score = db.score.reverse_order(:points).all #DB.instance.score is long because it's a singleton. Good for DBs because
                                        #you can only get one instance of it. There are issues with using singleton pattern but if you're
                                        #only using it for the same thing everywhere (ie- a db connection) then it makes sense.
                                        #DB is the class and we need to get an instance of the class and then score is the method from the DB class
    scores = score.map {|e| "#{e[:nick].rjust(20)} #{e[:points]}"}
    scores.each do |s|
      m.reply s 
    end #first sort, then print only nick and points, and align them correctly
  end

  #collection of URLs for the week

  #trivia
end


bot.start 

