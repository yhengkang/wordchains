# NB: You don't have to use recursion for this one.

# The general idea is this:

#     First, write a helper method adjacent_words(word, dictionary).
#     Write a method find_chain(start_word, end_word, dictionary). It should:
#     Start with the starting word, add it to a set called current_words.
#     Grow a new set, new_words, by calling adjacent_words on each of the words in current_words.
#     Be careful not to add any of the current_words to new_words. You can do this by also keeping track of a set, visited_words. Each time you encounter a new word, add it to visited_words.
#     If you encounter the target word while building new_words, congratulations; there is a path to your target! If not, then you need to replace current_words with new_words, clear out new_words and regrow new_words (loop back around).
#     It's important to not revisit words that you've been to already or else you'll get stuck in loops.


# The advantage to this approach is that it visits all the words that are adjacent to the starting word. Then you grow that set of words to visit all the words that are two steps away. Then you visit all words that are three steps away...
# Okay, great. This will keep growing new_words until it hits the target. But how to find the chain?
# Instead of merely keeping track of a set of visited_words, keep track of a hash: the key can be the new word, and the value can be the word that we came from to first reach the new word. You can start this out with start_word mapping to nil.
# Write a method, build_chain(visited_words, word). This should lookup word in visited_words to find the prior word. Then lookup the prior word. Then the word prior to that. Keep going back (collecting the prior words in an array) until you hit nil. That means you already collected the starting word, too.
# Make sure to request a code review from your TA once you can find adjacent words.
# Good luck!
class TreeNode
	attr_accessor :value, :parent, :children

	def initialize(value)
		@value = value
		@parent = nil
		@children = []
	end

	def add_child(value)
		child = TreeNode.new(value)
		child.parent = self
		@children << child
		child
	end

	def dfs(target)
		if self.value == target
			return self.value
		else
			self.children.each do |child|
				child.dfs(target)
			end
		end
		return nil
	end

	def bfs(target)
		nodes = [self]
		until nodes.empty?
			node = nodes.shift
			if node.value == target
				return node
			else
				nodes += node.children
			end
		end
		nil
	end

	def find_path
		path = [@value]
		return path if @parent.nil?
		path += @parent.find_path
	end


end

class WordChains
	DICTIONARY = File.readlines("dictionary.txt").map(&:chomp)
	attr_reader :same_length_words, :start_word

	def initialize
		@start_words = ["beer"]
		@same_length_words = []
		@possible_words = []
		@visited_words = []  ##Everytime new words is found, it is added to @visited words
		@current_words = []
		@new_words = []
		@end_word = ""
	end

	def new_to_start
		puts "Adding new_words to start_words"
		@start_words += new_words
		puts "Clearing new_words"
		@new_words = []
	end

	def set_start(start_word)
		@start_words << start_word
	end

	def set_end(end_word)
		@end_word = end_word
	end

	def found_word
		puts "Found word!"
		p @new_words
	end

	def same_length 
		@same_length_words = DICTIONARY.select{|word| word.length == @start_words.first.length }
		@same_length_words -= @visited_words
	end

	def one_letter_diff?(word1, word2)
		different_letters = 0
		word1.split('').each_with_index do |letter, i|
			different_letters += 1 unless letter == word2[i]
		end
		if different_letters == 1
			true
		else
			false
		end
	end

#take each word in start_words
#creates an similiar_words array of all words that are similar
#takes from similar_words array words not in new_words
	def create_new_words(unvisited_words)
		@start_words.each do |word|
			similar_words = unvisited_words.select {|unvisited_word| one_letter_diff?(word, unvisited_word)}
			@new_words += similar_words.select {|similar_word| !@new_words.include?(similar_word)}
			return found_word if @new_words.include?(@end_word)
		end
		@visited_words += @new_words
		@new_words
	end
			
	def test_run
		same_length #populates same_length_words
		create_new_words(@same_length_words)
	end



end


	# def one_letter_diff
	# 	@same_length_words.each do |word|
	# 		different_letters = @start_word.split('') - word.split('')
	# 		if different_letters.length == 1
	# 			@possible_words << word
	# 		end
	# 	end
	# 	@possible_words
	# end
	#Doesnt work because the array doesnt care which letter comes first.  So abbe - beer = 1, since bs and es cancel

	# def one_letter_diff
	# 	@same_length_words.each do |word|
	# 		different_letters = 0
	# 		word.split('').each_with_index do |letter,i|
	# 			unless letter == @start_word[i]
	# 				different_letters += 1
	# 			end
	# 		end
	# 		@possible_words << word if different_letters == 1
	# 	end
	# 	@possible_words
	# end   		#test run done, now gotta modulize



	# def create_possible_words
	# 	same_length
	# 	one_letter_diff
	# end