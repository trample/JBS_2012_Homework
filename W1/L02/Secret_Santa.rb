#Secret_Santa
#Tom Ma
#W1L02
#Purpose: to assign a person to secretly send a gift to another person

#create a person class to represent a person, not really useful
class Person 
	attr_accessor :first, :last, :email

	def initialize(first, last, email)
		@first, @last, @email = first, last, email
	end

	def to_s
		 "#{@first} #{@last}"
	end

	#to compare two person and see if they are from the same family
	def == (one)
		if @last == one.last then true
		else false 
		end
	end

	#to get rid of the "<..>""
	def get_email
		@email[1..-2]
	end
end


#read names from a file and put them into a array
names = []
lines = readlines
lines.each do |line|
	first, last, email = line.split
	person = Person.new(first, last, email)
	names += [person]
end


#a method to make pairs of gift sender and reciever
def mkpair(names)
	pairs = []
	i = 0
	while i<(names.size-1)
		pairs += [[[names[i]],[names[i+1]]]]
		i=i+1
	end 
	return pairs += [[[names[i]],[names[0]]]]
end

# to figure out if the assignment fulfills the requirement
fulfill = false
while !fulfill 
	names = names.shuffle
	pairs = mkpair(names)
	flag = false
	pairs.each do |pair|
		if pair[0] == pair[1]
			flag = true
		end 
	end
	if !flag 
	 fulfill=true
	end
end


#mail sending tutorial from http://blog.jerodsanto.net/2009/02/a-simple-ruby-method-to-send-emai/
#-----------------------------------------------------------------
require 'net/smtp'
def send_email(to,opts={})
  opts[:server]      ||= 'localhost'
  opts[:from]        ||= 'tomma@brandeis.edu'
  opts[:from_alias]  ||= 'Santa Appointer'
  opts[:subject]     ||= "You need to see this"
  opts[:body]        ||= "Important stuff!"

  msg = <<END_OF_MESSAGE
From: #{opts[:from_alias]} <#{opts[:from]}>
To: <#{to}>
Subject: #{opts[:subject]}

#{opts[:body]}
END_OF_MESSAGE

  Net::SMTP.start(opts[:server]) do |smtp|
    smtp.send_message msg, opts[:from], to
  end
end
#-----------------------------------------------------------------



#final excuting: send emails out and prints the result
pairs.each do |pair|
	email = pair[0][0].get_email
	#since local server won't work I just put it in comment
	#send_email email, :body => "you should send gift to #{pair[1]}"

	puts "#{pair[0]} should send gift to #{pair[1]}!!"
end


