# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Director.destroy_all
Movie.destroy_all
Actor.destroy_all
Character.destroy_all

directors = [
  { name: "Francis Ford Coppola", dob: "04/07/1939" },
  { name: "Christopher Nolan", dob: "07/30/1970" },
  { name: "Frank Darabont", dob: "01/29/1959" }
  ]
  
movies = [
  { title: "The Godfather", year: "1972", director: "Francis Ford Coppola" },
  { title: "The Godfather: Part II", year: "1974", director: "Francis Ford Coppola" },
  { title: "The Shawshank Redemption", year: "1994", director: "Frank Darabont" },
  { title: "The Dark Knight", year: "1972", director: "Christopher Nolan" }
  ]

characters = [
  { name: "Bruce Wayne", movie: "The Dark Knight", actor: "Christian Bale"},
  { name: "Michael Corleone", movie: "The Godfather", actor: "Al Pacino" },
  { name: "Andy Dufresne", movie: "The Shawshank Redemption", actor: "Tim Robbins"},
  { name: "Red Redding", movie: "The Shawshank Redemption", actor: "Morgan Freeman"}
  ]

actors = [
  { name: "Christian Bale", dob: "01/30/1974" },
  { name: "Al Pacino", dob: "04/25/1940" },
  { name: "Tim Robbins", dob: "10/16/1958" },
  { name: "Morgan Freeman", dob: "06/01/1937" }
  ]
  
directors.each do |director|
  d = Director.new
  d.name = director[:name]
  d.dob = Date.strptime director[:dob], '%m/%d/%Y'
  d.save
end  

movies.each do |movie|
  m = Movie.new
  m.title = movie[:title]
  m.year = movie[:year]
  m.director = Director.find_by_name(movie[:director])
  m.save
end

actors.each do |actor|
  a = Actor.new
  a.name = actor[:name]
  a.dob = Date.strptime actor[:dob], '%m/%d/%Y'
  a.save
end

characters.each do |character|
  c = Character.new
  c.name = character[:name]
  c.movie = Movie.find_by_title(character[:movie])
  c.actor = Actor.find_by_name(character[:actor])
  c.save
end