#!/usr/bin/ruby
$lower = /[a-z]/ # matches all lower case  characters
$upper = /[A-Z]/ # matches all upper case characters
$special = /\W\s/ # matches special characters, i.e. !@#$%^&*
$nums = /[0-9]/ # matches all numbers
$common = Array.new

wordsFile = File.new("./4000-most-common-english-words-csv.csv", "r")
for word in wordsFile
	$common = $common << word
end
wordsFile.close

class ComplexString
	@string = nil
	@score = nil

	def initialize(password)
		@string = password
		@score = 0
	end

	# Takes a string S and returns an integer 0-3 
	def checkLen
		strLen = @string.length
		if strLen > 8
			@score += 3
		elsif strLen > 5 && strLen <= 8
			@score += 2
		elsif strLen > 3 && strLen <= 5
			@score += 1
		end
	end

	# Evaluates to false if the length of the string is less than 6
	def tooShort?
		@string.length <= 5
	end

	def getScore
		@score
	end

	def getString
		@string
	end

	# adds 1 point to SCORE if the ComplexString does not contain a common word
	def checkIfCommon
		hasMatch = false
		for word in $common
			if /#{@string}/ =~ word
				hasMatch = true
				break
			end
		end
		puts hasMatch
		if !hasMatch
			puts "does not have common"
			@score += 1
		end
	end

	# Increments SCORE by the addinonal levels of complexity, if the passowrd
	# is complex.
	def checkComplexity
		hasSpecial = false
		hasUpper = false
		hasLower = false
		hasNums = false
		for word in $common
			if $lower =~ word && !hasLower
				@score += 1
				hasLower = true
			end
			#if $upper =~ word && !hasUpper
			#	@score += 2
			#	hasUpper = true
			#end
			if $nums =~ word && !hasNums
				@score += 1
				hasNums = true
			end
			#f $special =~ word && !hasSpecial
			#	@score += 2
			#	hasSpecial = true
			#end
		end
	end
end

# main
if ARGV.length == 1
	password = ARGV[0]
else
	puts "Enter password: "
	password = gets # if empty, password defaluts to a newline character"\n"
end
while (password == "\n")
	puts "you must enter a password"
	puts "Enter password: "
	password = gets
end
password = ComplexString.new(password)
if !password.tooShort?
	password.checkLen
	password.checkIfCommon
	#password.checkComplexity
	puts password.getScore.to_s
else
	puts "your password is too short"
	exit
end