puts "enter a line: "
line = "my phone number is 9969259"

cell = line[/\d+[\s\d-]+/]
if cell != nil
	if cell.size > 6 
		puts "the line contains valid US phone number:"
		puts "the number: "+cell
	end
end

cosnum = line[/\w+\s\d+[abj]+/]
if cosnum != nil
	puts "the line contains a Brandeis Course Number: "
	puts "Course Number: "+cosnum
end

http = line.scan(/http[\w:\.\/-]+/)
if http != [] 
	puts "the line contains urls:"
	puts http
end

