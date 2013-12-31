require 'singleton'

class DB
  include Singleton
  
  def initialize(file = 'sqlite://bot.db')
    @db = Sequel.connect(file)  #setup the DB connection
  end

  def score
    @db[:score]
  end


  
  def nick_id(nick) #find out if a nick is already in the DB or if we need to create it
    set = score.where(:nick => nick) #finds the list of every score that has the nickname nick (nick being whatever the person's nick is)
    if set.empty? #if it doesn't find anything
      nil #returns nil
    else
      set.first[:id] #otherwise grab the id of the first and return it. it'll return the id and not the nick
    end
  end

  def insert_or_update_score(nick, points)
    nick.downcase!
      if nick_id(nick)
        #1. fetch 2. increment number 3. save it back
        row = score.where(:id => nick_id(nick)).first
        updated_points = row[:points] + points 
        score.where(:id => nick_id(nick)).update(:points => updated_points)
      else
        score.insert(:nick => nick, :points => points) #creates a new nick in the DB and gives it the points
      end
  end

  def lookup_score(nick)
    score.filter(:nick => nick).first[:points] 
  rescue #def rescue end is the control flow. if there are any exceptions, the rescue catches the exception and returns nil because it's the last thing that happens in the method
    nil #this rescue thing can be dangerous because it can hide serious errors. 
  end
end

