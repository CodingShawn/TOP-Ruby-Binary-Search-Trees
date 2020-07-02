require_relative 'Node'
require 'pry'

class Tree
  def initialize(array)
    @root = build_tree(array.sort.uniq) #array has to be sorted and duplicates removed
  end

  def build_tree(sorted_array)
    array_length = sorted_array.length
    if array_length == 0
      nil
    elsif array_length == 1
      Node.new(sorted_array[0])
    else
      midpoint = array_length / 2
      lhs_node = build_tree(sorted_array[0...midpoint])
      rhs_node = build_tree(sorted_array[(midpoint + 1)...array_length])
      Node.new(sorted_array[midpoint], lhs_node, rhs_node)
    end
  end 

  def insert(value)
    pointer = @root
    new_node = Node.new(value)
    loop do #repeatedly searching for null spot to insert node
      if pointer.data > value
        if pointer.left_node == nil
          pointer.left_node = new_node
          break
        else #continue down the tree
          pointer = pointer.left_node
        end
      else
        if pointer.right_node == nil
          pointer.right_node = new_node
          break
        else 
          pointer = pointer.right_node
        end
      end
    end 
  end

  #def 
end

x = Tree.new([1,2,3,4,5,6,7,8,9,10])
x.insert(6)
p x.to_s