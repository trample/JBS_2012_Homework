class Rating 
	attr_accessor :user, :movie, :rate
	
	def initialize(data)
		@user, @movie, @rate = data.split
		@user = @user.to_i
		@movie= @movie.to_i
		@rate = @rate.to_i
	end

	def to_s 
		puts "[#{@user}, #{@movie}, #{@rate}]"
	end

end

class MovieData
	def initialize(file_path)
		file = File.new(file_path, "r")
		@list = file.readlines.collect{|x| Rating.new(x)}
	end

	def popularity_list
		@pop_list = {}
		@list.each do |x|
			@pop_list[x.movie] = 0
	 	end
	 	@list.each do |x|
	 		@pop_list[x.movie] += x.rate
	 	end
	 	@pop_list.sort_by {|k,v| v}.reverse

	end

	def popularity(movie_id)
		@pop_list = @pop_list || popularity_list
		@pop_list[movie_id]
	end

	def gen_usrlist
		@ulist = {}
		#to make the hash map consist of empty arrays
		
		@list.each do |x|
			@ulist[x.user] = [] 
		end
		@list.each do |x|
	 		@ulist[x.user] << x 
	 	end
	 	@ulist
	end

	def gen_movlist
		@mlist = {}
		#to make the hash map consist of empty arrays
		
		@list.each do |x|
			@mlist[x.movie] = [] 
		end
		@list.each do |x|
	 		@mlist[x.movie] << x 
	 	end
	 	@mlist
	end

	def rating(u,m)
		r = @ulist[u] & @mlist[m]
		if r[0] != nil
			r[0].rate
		end
	end


	def movies(u)
		m = @ulist[u].collect {|x| x.movie}
	end

	def viewers(m)
		u = @mlist[m].collect {|x| x.user}
	end

	def similarity(user1, user2)
		u1 = @ulist[user1].collect {|x| [x.movie, x.rate]}
		u2 = @ulist[user2].collect {|x| [x.movie, x.rate]}
		#first get the same ratings the two users have 
		similar = u1&u2
		#then calculate what portion the same part is of all the ratings of the user with fewer ratings
		similar.size.to_f/[u1.size, u2.size].min
	end

	def most_similar(user)
		most_similar_list = {}
		@ulist.each do |k, v|
 	 		most_similar_list[k] = similarity(k, user)
 	 	end
 	 	most_similar_list.sort_by{|k,v| v}.reverse
	end

	def predict(u,m)
		list = most_similar(u)
		list.each do |k, v|
			a=rating(k,m)
			if a != nil
				return a
			end
		end
		return nil
	end


end

class MovieNames
	def initialize 
		movie_file = File.new("u.item", "r")
		@movie_list = movie_file.readlines.collect{|x| x.split("|")[1]}
	end

	#return the name of a movie according to the number
	def movie_name (num)
		@movie_list[num-1]
	end
end


puts "start"
start = Time.now
mmm = MovieData.new("u.data")
@mlist = mmm.gen_movlist
@ulist = mmm.gen_usrlist
#puts mmm.similarity(1,848)
i=1


puts mmm.predict(300,1)

names = MovieNames.new

#@ulist[1].each {|x| puts "#{names.movie_name(x.movie)}: #{x.rate}"}
ending = Time.now
puts ending-start




