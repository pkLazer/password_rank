# Application to rank a password. Outputs a score 0-10
import sys, re, md5

lower = re.compile("[a-z]")
upper = re.compile("[A-Z]")
nums = re.compile("[0-9]")
special = re.compile("\W")
wordsFile = open("./4000-most-common-english-words-csv.csv", "r")
common = wordsFile.readlines()
wordsFile.close()

class ComplexString:
	string = None
	score = 0
	def __init__(self, string):
		self.string = string

	# Returns False if the length of the string is less than 6
	def tooShort(self):
		return len(self.string) <= 5

	# Takes a string S and returns an integer 0-3 
	def checkLen(self):
		strLen = len(self.string)
		if strLen > 8:
			self.score += 3
		elif strLen > 5 & strLen <= 8:
 			self.score += 2
		elif strLen > 3 & strLen <= 5:
			self.score += 1
	
	# Increments SCORE by the addinonal levels of complexity, if the passowrd
	# is complex.
	def checkComplexity(self):
		hasSpecial = False
		hasUpper = False
		hasLower = False
		hasNums = False
		for c in self.string:
			if nums.match(c) and not hasNums:
				self.score += 1
				hasNums = True
			if lower.match(c) and not hasLower:
				self.score += 1
				hasLower = True
			if upper.match(c) and not hasUpper:
				self.score += 2
				hasUpper = True
			if special.match(c) and not hasSpecial:
				self.score += 2
				hasSpecial = True

	# adds 1 point to SCORE if the ComplexString does not contain a common word 
	def checkIfCommon(self):
		notInCommon = True
		for word in common:
			checkWord = re.compile(word.strip())
			if checkWord.match(self.string):
				notInCommon = False
		if notInCommon:
			self.score += 1

	# Removes questionable input from the password
	def sanitize(self):
		self.string = self.string.replace("\\","")
		self.string = self.string.replace(".","")
		# add functionality to remove whitespace
		print self.string
	
	# Returns the md5 hash of the ComplexString
	def hashMD5(self):
		h = md5.new()
		h.update(self.string)
		return h.digest()

	# Returns the complexity score for this ComplexString
	def getScore(self):
		return self.score

if len(sys.argv) == 2:
	password = sys.argv[1]
else:
	password = raw_input("Enter password: ")
if password != "":
	password = ComplexString(password)
	if not password.tooShort():
		password.checkLen()
		password.checkComplexity()
		password.checkIfCommon()
		print "your password score is " + str(password.getScore())
	else:
		print "your password is too short"
		sys.exit(0)
else:
	print "you must enter a password"
	sys.exit(0)
