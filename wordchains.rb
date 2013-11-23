
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
	attr_reader :same_length_words, :start_word, :visited_words

	def initialize(start_word)
		@start_word = TreeNode.new(start_word)
		@visited_nodes = [@start_word]
		@same_length_words = []
	end

	def same_length 
		@same_length_words = DICTIONARY.select{|word| word.length == @start_word.value.length }
	end

	def one_letter_diff?(word1,word2)
		letter_difference = 0
		word1.length.times do |i|
			letter_difference += 1 unless word1[i] == word2[i]
		end
		return true if letter_difference == 1
		return false
	end

	def build_word_tree(end_word)
		# puts "does this work?"
		visited_words = [@start_word.value]
		until visited_words.include?(end_word)
			@visited_nodes.each do |node|
				print "."
				@same_length_words.each do |same_length_word|
					if one_letter_diff?(node.value, same_length_word) && !visited_words.include?(same_length_word)
						visited_words << same_length_word
						@visited_nodes << node.add_child(same_length_word)
						@same_length_words -= [same_length_word]
					end
				end
			end
		end
	end

	def find_word_chain(end_word)
		@visited_nodes.first.bfs(end_word).find_path
	end

	def run_command(end_word)
		self.same_length
		build_word_tree(end_word)
		puts "\n\nThe chain is: #{find_word_chain(end_word).join(', ')}."
	end


end

