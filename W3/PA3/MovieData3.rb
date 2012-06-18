#Tom Ma
#Program Assignment 3
#June 17th
#Purpose: write four methods to find movies and users in the movie data


#a class for every single rating, from last assignments 
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

	def to_a 
		[@user, @movie, @rate]
	end

end

#the class for the moviedata, contains all the required methods
class MovieData
	def initialize(file_path, u="u.data")
		@file_path = file_path
		@u = u
		if u == "u.data"
			file = File.new(@file_path+"/"+u, "r")
		else 
			file = File.new(@file_path+"/"+u+".base", "r")
		end
		@list = file.readlines.collect{|x| Rating.new(x)}
	end

	#to give a hash of users point to the ratings they have
	def gen_usrlist
		@ulist = {}
		#to make the hash map consist of empty arrays
		@list.each do |x|
			@ulist[x.user] = @ulist[x.user]||[] 
	 		@ulist[x.user] << x 
	 	end
	 	@ulist
	end


	#to find movies fulfill certain condtion
	def find_movies(condition)
		found_movies=[]
		#seperate the movie by different genre
		@movie_list[condition[:genre]].each do |x| 
			if x.title.downcase.include?(condition[:title].downcase)
				found_movies<<x
			end
		end
		found_movies
	end

	#to find certain users fulfilling certain condition
	def find_users(condition)
		found_users = []
		#seperate users by sex
		@user_list[condition[:sex]].each do |x|
			if condition[:agerange].include?(x.age) && condition[:job]==x.job
				found_users << x
			end
		end
		found_users
	end


	#read users from u.user
	def load_users
		@user_list = {}
		File.open(@file_path+'/'+"u.user") do |x|
			x.each do |line|
				u = User.new(line)
				@user_list[u.sex]= @user_list[u.sex]||[]
				@user_list[u.sex] << u
			end
		end
	end

	#give the name list
	def title_list
		@movie_index
	end

	#load movies from u.item
	def load_movies
		@movie_list = {}
		@movie_index = {}
		File.open(@file_path+'/'+"u.item", 'r:iso-8859-1') do |x|
			x.each do |line| 
				m = Movie.new(line)
				#seperate the movie by different genre
				m.genre.each do |k, v| 
					if v 
						@movie_list[k] = @movie_list[k] || []
						@movie_list[k] << m
						@movie_index[m.id] = @movie_index[m.id] || m.title
					end
				end
			end
		end
		@movie_list
	end
	#return an array of movies of a certain genre and year
	def test1(genre, year)
		found_movies=[]
		@movie_list[genre].each do |x|
			if x.year == year 
				found_movies<<x
			end
		end
		found_movies
	end

	#return n top-viewed movies of a certain sex and age range
	def test2(agerange,sex,n)
		found_movies={}
		usrlist = gen_usrlist
		@user_list[sex].each do |x|
			if agerange.include?(x.age)
				usrlist[x.id].each do |y|
					m=y.movie
					found_movies[m] = found_movies[m] || 0
					found_movies[m] = found_movies[m] +1
				end
			end
		end
		found_movies.sort_by{|k,v| v}.reverse[0..n-1]
	end


end
#class for a single user
class User 
	attr_accessor :id, :age, :sex, :job
	def initialize(line)
		id, age, sex, job = line.split("|")
		@id = Integer(id)
		@age = Integer(age)
		@sex = :M if sex == "M"
		@sex = :F if sex =="F"
		@job = job
	end
end


#class for a single movie
class Movie
	attr_accessor :id, :title, :date, :video_date, :imdb_url, :genre, :year 
	def initialize (line)
		id, title, date, video_date, imdb_url, unknown, action, adventure, animation, childrens, comedy, crime, documentary, drama, fantasy, film_noir, horror, musical, mystery, romance, sci_fi, thriller, war, western=line.split('|')
		@id=Integer(id)
		@title=title
		@date=date
		@video_date=video_date
		@imdb_url=imdb_url
		@year = Integer(date[-4..-1])
		@genre = {}
		@genre["unknown"]=Integer(unknown)==1
		@genre["action"]=Integer(action)==1
		@genre["adventure"]=Integer(adventure)==1
		@genre["animation"]=Integer(animation)==1
		@genre["childrens"]=Integer(childrens)==1
		@genre["comedy"]=Integer(comedy)==1
		@genre["crime"]=Integer(crime)==1
		@genre["documentary"]=Integer(documentary)==1
		@genre["drama"]=Integer(drama)==1
		@genre["fantasy"]=Integer(fantasy)==1
		@genre["film_noir"]=Integer(film_noir)==1
		@genre["horror"]=Integer(horror)==1
		@genre["musical"]=Integer(musical)==1
		@genre["mystery"]=Integer(mystery)==1
		@genre["romance"]=Integer(romance)==1
		@genre["sci_fi"]=Integer(sci_fi)==1
		@genre["thriller"]=Integer(thriller)==1
		@genre["war"]=Integer(war)==1
		@genre["western"]=Integer(western)==1
	end
end

#test
start = Time.now
a = MovieData.new("ml-100k")
a.load_movies
a.load_users


#a.find_movies(:title=>"star trek", :genre=>"sci_fi").each {|x| puts x.title}
#a.find_users(:job=>"student", :agerange=>(18..25), :sex=>:M).each {|x| puts x.id} 
#a.test1("sci_fi",1996).each {|x| puts "#{x.title} #{x.id}"}
a.test2((18..25),:F,5).each {|x| puts a.title_list[x[0]]}
ending = Time.now

puts "Time used: #{ending-start}." 
