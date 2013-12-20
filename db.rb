#is there anything here that can be refactored? It looks pretty solid...
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
    score.filter(:nick => nick).first[:points] #if someone has no points, this throws an exception
  rescue #def rescue end is the control flow. if there are any exceptions, the rescue catches the exception and returns nil because it's the last thing that happens in the method
    nil #this rescue thing can be dangerous because it can hide serious errors. generally, use this for more explicit errors. but here, it's just a private bot so it's fine.
  end
end

# before had DB = Sequel.connect('sqlite://bot.rb') which set it as a global constant, changed it to an instance variable by
#putting it in a singleton class and initializing it.
#this means we also have to change all the DC[:score] instances in the code because that's now @db
#instead of just putting @db in each place, create a score method that does it for us (extract it into a method)