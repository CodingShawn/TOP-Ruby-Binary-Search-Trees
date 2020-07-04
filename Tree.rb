require_relative 'Node'

class Tree
  attr_reader :root

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

  def delete(value)
    target_node = find(value)
    pointer = @root
    prev_pointer = pointer #keep reference to previous node
    until pointer.data == value
      prev_pointer = pointer
      if pointer.data > value
        pointer = pointer.left_node
      else
        pointer = pointer.right_node
      end
    end
    #binding.pry
    if pointer.left_node == nil && pointer.right_node == nil #if target node is leaf node
      if prev_pointer.data > value
        prev_pointer.left_node = nil
      else
        prev_pointer.right_node = nil
      end
    elsif pointer.left_node != nil && pointer.right_node == nil
      if prev_pointer.data > value
        prev_pointer.left_node = pointer.left_node
      else
        prev_pointer.right_node = pointer.left_node
      end
    elsif pointer.left_node == nil && pointer.right_node != nil
      if prev_pointer.data > value
        prev_pointer.left_node = pointer.right_node
      else
        prev_pointer.right_node = pointer.right_node
      end
    else #have 2 children node
      min_node_pointer = pointer.right_node 
      #start from right node to search for min number on right subtree
      prev_min_node_pointer = pointer
      binding.pry
      replace_right = true #to determine if first right node is already min node
      until min_node_pointer.left_node == nil
        if replace_right == true
          prev_min_node_pointer = prev_min_node_pointer.right_node
          replace_right = false
        else
          prev_min_node_pointer = prev_min_node_pointer.left_node
        end
        min_node_pointer = min_node_pointer.left_node
      end
      pointer.data = min_node_pointer.data #replace target node with min node data
      if replace_right == true #remove node that was used to replace target node
        prev_min_node_pointer.right_node = min_node_pointer.right_node
      else
        prev_min_node_pointer.left_node = min_node_pointer.right_node
      end
    end
  end

  def find(value)
    pointer = @root
    until pointer.data == value
      if pointer.data > value
        pointer = pointer.left_node
      else
        pointer = pointer.right_node
      end
    end
    return pointer
  end

  def level_order
    queue = [@root]
    result = []

    until queue.empty?
      current = queue.shift
      if block_given?
        yield current.data
      else
        result.append current.data
      end

      queue.append(current.left_node) if current.left_node != nil
      queue.append(current.right_node) if current.right_node != nil
    end

    if block_given?
      return nil
    else
      return result
    end 
  end

  def level_order_recursive(queue = [@root], result = [], &block)
    current = queue.shift
    if current.nil?
      if block_given?
        nil
      else
        result
      end
    else
      if block_given?
        yield current.data
      else
        result.append current.data
      end
      queue.append(current.left_node) unless current.left_node.nil?
      queue.append(current.right_node) unless current.right_node.nil?
      level_order_recursive(queue, result, &block)
    end
  end

  def inorder(node = @root, result = [], &block)
    if node.nil?
      if block_given?
        nil
      else
        result
      end
    else
      if block_given?
        yield node.data
      else
        result.append node.data
      end
      inorder(node.left_node, result, &block)
      inorder(node.right_node, result, &block)
    end
  end

  def preorder(node = @root, result = [], &block)
    if node.nil?
      if block_given?
        nil
      else
        result
      end
    else
      preorder(node.left_node, result, &block)
      if block_given?
        yield node.data
      else
        result.append node.data
      end
      preorder(node.right_node, result, &block)
    end
  end

  def postorder(node = @root, result = [], &block)
    if node.nil?
      if block_given?
        nil
      else
        result
      end
    else
      postorder(node.left_node, result, &block)
      postorder(node.right_node, result, &block)
      if block_given?
        yield node.data
      else
        result.append node.data
      end
    end
  end

  def depth(node = @root)
    if node.left_node.nil? && node.right_node.nil?
      return 0
    elsif node.left_node.nil? ^ node.right_node.nil?
      if node.left_node.nil?
        return depth(node.right_node) + 1
      else
        return depth(node.left_node) + 1
      end
    else
      right_depth = depth(node.right_node)
      left_depth = depth(node.left_node)
      if right_depth > left_depth
        return right_depth + 1
      else 
        return left_depth + 1
      end
    end 
  end 

  def balanced? (node = @root)
    difference_in_depth = (depth(node.left_node) - depth(node.right_node)).abs
    return difference_in_depth <= 1
  end

  def rebalance!
    unless balanced?
      new_array = level_order
      @root = build_tree(new_array)
    end
  end
end