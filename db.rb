require 'singleton'

class DB
  include Singleton
  
  def connect_database
    DB = Sequel.connect('sqlite://bot.db') #sets a global constant called DB
    score = DB[:score] 
  end

  attr_accessor :nick, :points 

  def initialize(nick, points)
    @nick = nick 
    @points = points 
  end
  
  def nick_id(nick) #find out if a nick is already in the DB or if we need to create it
    set = DB[:score].where(:nick => nick) #finds the list of every score that has the nickname nick (nick being whatever the person's nick is)
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
      row = DB[:score].where(:id => nick_id(nick)).first
      updated_points = row[:points] + points 
      DB[:score].where(:id => nick_id(nick)).update(:points => updated_points)
    else
      DB[:score].insert(:nick => nick, :points => points) #creates a new nick in the DB and gives it the points
    end
  end

  def lookup_score(nick)
    DB[:score].filter(:nick => nick).first[:points] #if someone has no points, this throws an exception
  rescue #def rescue end is the control flow. if there are any exceptions, the rescue catches the exception and returns nil because it's the last thing that happens in the method
    nil #this rescue thing can be dangerous because it can hide serious errors. generally, use this for more explicit errors. but here, it's just a private bot so it's fine.
  end
end