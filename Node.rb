class Node
  attr_accessor :left_node, :right_node
  attr_reader: :data
  def initialize(data=nil, left_node=nil, right_node=nil)
    @data = data
    @left_node = left_node
    @right_node = right_node
  end

end