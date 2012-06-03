# pre work for JBS 2012
# Madlibs
# Tom Ma tomma@brandeis.edu 
# May 28th 2012
# purpose: to ask for two gemstones and give a story with that two gemstons
class Madlibs 
	attr_accessor :gemlove, :gemhate
	
	#initializer
	def initialize()
		puts "Please enter your favorite gemstone: "
		gemlove = gets
		puts "Please enter your hated gemstone: "
		gemhate = gets
		@gemlove = gemlove
		@gemhate = gemhate
	end

	#prints out the story
	def output
		puts "Our favorite language is #{@gemlove}. We think #{@gemlove} is better than #{@gemhate}."
	end

end

# not really sure what this is for
if __FILE__ == $0
	mg = Madlibs.new
	mg.output
end
