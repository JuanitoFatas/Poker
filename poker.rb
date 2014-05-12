NoHandError = Class.new(StandardError)

def deal num_of_hands, n=5, deck=%w(2 3 4 5 6 7 8 9 T J Q K A).product(%w(S H D C)).map(&:join)
  deck.shuffle!
  (0...num_of_hands).map do |i|
    deck[n*i...n*(i+1)]
  end
end

# Return a array of all items equal to the max of the enumerable.
def allmax(hands, key=nil)
  result, max_hand_val = [], []
  key = key || ->(x) { x }
  hands.each do |hand|
    hand_val = key.call(hand)
    if result.empty? || (hand_val <=> max_hand_val) == 1
      result, max_hand_val = [hand], hand_val
    elsif (hand_val <=> max_hand_val) == 0
      result << hand
    end
  end
  return result
end

# Return a list of winning hands: poker([hand, ...]) => [hand, ...]
def poker hands
  raise NoHandError if hands.empty?
  allmax(hands, method(:hand_rank))
end

# return a value indicating the ranking of a hand
# 9 diffrent kinds of hand
# straight flush: 8
# 4 of a kind:    7
# full house:     6
# flush:          5
# straight:       4
# 3 of a kind:    3
# 2 pair:         2
# kind:           1
# high card:      0
def hand_rank(hand)
  ranks = card_ranks(hand) # card_ranks return the ranks in sorted order

  if straight(ranks) && flush(hand)
    return [8, ranks.max] # 2 3 4 5 6 => [8, 6], 6 7 8 9 T => [8, T]
  elsif kind(4, ranks)
    return [7, kind(4, ranks), kind(1, ranks)] # 9 9 9 9 3 => [7, 9, 3]
  elsif kind(3, ranks) && kind(2, ranks) # 8 8 8 K K => [6, 8, 13]
    return [6, kind(3, ranks), kind(2, ranks)]
  elsif flush(hand)
    return [5, ranks]
  elsif straight(ranks)
    return [4, ranks.max]
  elsif kind(3, ranks)
    return [3, kind(3, ranks), ranks]
  elsif two_pair(ranks)
    return [2, kind(2, ranks), ranks]
  elsif kind(2, ranks)
    return [1, kind(2, ranks), ranks]
  else
    return [0, ranks]
  end
end

# Return a array of ranks, sorted with higher first.
# Example usage:
# ["6C", "7C", "8C", "9C", "TC"] => [10, 9, 8, 7, 6]
def card_ranks(cards)
  ranks = cards.map { |card| '--23456789TJQKA'.index(card[0]) }
  ranks.sort! { |a, b| b <=> a }
  if ranks == [14, 5, 4, 3, 2]
    [5, 4, 3, 2, 1]
  else
    ranks
  end
end

# Return True if the ordered ranks form a 5-card straight.
def straight(ranks)
  return (ranks.max - ranks.min) == 4 && ranks.uniq.size == 5
end

# Return True if all the cards have the same suit.
def flush(hand)
  suits = hand.map { |card| card[1] }
  return suits.uniq.one?
end

# Return the first rank that this hand has exactly n of.
# Return None if there is no n-of-a-kind in the hand.
def kind(n, ranks)
  ranks.each { |r| return r if ranks.count(r) == n }
  return nil
end

# If there are two pair, return the two ranks as a
# array: [highest, lowest]; otherwise return nil.
def two_pair(ranks)
  pair = kind(2, ranks)
  lowpair = kind(2, ranks.reverse)
  return [pair, lowpair] if pair && lowpair != pair
  return nil
end
