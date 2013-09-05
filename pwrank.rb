#!/usr/bin/ruby
lower = ["a", "b", "c", "d"]
upper = Array.new
special = Array.new
nums = Array.new
common = Array.new
# when using regex, need to check that the WHOLE word is is in the list,
# not just parts. i.e. 

wordsFile = File.new("./4000-most-common-english-words-csv.csv", "r")
for word in wordsFile
	common = common << word
end
wordsFile.close

class ComplexString
	@string = nil
	@score = 0

	def initialize(password)
		@string = password
	end

	# Takes a string S and returns an integer 0-3 
	def checkLen
		strLen = @string.length
		if strLen > 8
			@score += 3
		elsif strLen > 5 & strLen <= 8
			@score += 2
		elsif strLen > 3 & strLen <= 5
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
		if !common.include? @string
			@score += 1
		end
	end

	def checkComplexity
		@hasSpecial = false
		@hasUpper = false
		@hasLower = false
		@hasNums = false
	end
end

password = "skyler"
password = ComplexString.new(password)
if !password.tooShort?
	puts password.getString
end