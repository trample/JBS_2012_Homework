#movie_data
#Tom Ma
#2012 June 2
#Purpose: to create a class which can give a popularity list for the movies and similarity list for the users



class MovieData
	#load data by STDIN
	def load_data
		@list = STDIN.readlines.collect{|x| x.split[0..2]}
	end

	
	#generate a popularity list by the adding the ratings of each movie
	def popularity_list
		@pop_list = {}
		@list.each do |x|
			@pop_list[x[1].to_i] = 0
	 	end
	 	@list.each do |x|
	 		@pop_list[x[1].to_i] += x[2].to_i
	 	end
	 	@pop_list.sort_by {|k,v| v}.reverse

	end

	#return a ranking of a movie in the popularity list
	def popularity(movie_id)
		if @pop_list == nil 
			@pop_list = popularity_list
			@pop_list[movie_id]
		else @pop_list[movie_id]
		end
	end

	#generate the user list from the data
	#it's basically a hash map with the ratings of each user
	def gen_usrlist
		@ulist = {}
		#to make the hash map consist of empty arrays
		#Is there another way to do this??????
		@list.each do |x|
			@ulist[x[0]] = [] 
		end
		@list.each do |x|
	 		@ulist[x[0]] += [[x[1], x[2].to_i]] 
	 	end
	 	@ulist
	end

	#to tell how similar two users are 
	def similarity(user1, user2)
		if @ulist == nil 
			@ulist = gen_usrlist()
		end
		u1 = @ulist[user1.to_s]
		u2 = @ulist[user2.to_s]
		#first get the same ratings the two users have 
		similar = u1&u2
		#then calculate what portion the same part is of all the ratings of the user with fewer ratings
		similar.size.to_f/[u1.size, u2.size].min
	end

	#generate a list by compare every user with one user to compare how similar it is with other users
	def most_similar(user)
		if @ulist == nil 
			@ulist = gen_usrlist()
		end
		main = @ulist[user]
		most_similar_list = {}
		@ulist.each do |x|
			if x != main
 	 			most_similar_list[x[0]] = similarity(x[0], user)
 	 		end
 	 	end
 	 	most_similar_list.sort_by{|k,v| v}.reverse
	end
end

#a class of the movie information
class Movies
	def load 
		movie_file = File.new("u.item", "r")
		@movie_list = movie_file.readlines.collect{|x| x.split("|")[1]}
	end

	#return the name of a movie according to the number
	def movie_name (num)
		@movie_list[num-1]
	end
end

data = MovieData.new
mo = Movies.new
movie_data=mo.load
@list= data.load_data
a = data.popularity_list
a.each {|x| puts "#{a.index(x)+1}. #{x[0]} #{mo.movie_name(x[0])}"}
#puts "the popularity of 50  is #{data.popularity(50)}"
#@ulist=data.gen_usrlist
#@ulist["919"].each {|x| puts "#{x[0]}=>#{x[1]}"}
#puts @ulist["2"].size
#puts data.similarity(1,2)
#puts "first line is the total rating of the user"
#data.most_similar(364).each {|x| puts "#{x[0]}: #{x[1]}"}


