  require "minitest/autorun"
  require_relative 'poker'

  class TestPoker < Minitest::Test
    def setup
      @sf = %w(6C 7C 8C 9C TC) # straight flush
      @fk = %w(9D 9H 9S 9C 7D) # four of a kind
      @fh = %w(TD TC TG 7C 7D) # full house
      @tp = %w(5S 5D 9H 9C 6S) # two_pairs
      @s1 = %w(AS 2S 3S 4S 5C) # A-5 straight
      @s2 = %w(2C 3C 4C 5C 6C) # 2-6 straight
      @ah = %w(AS 2S 3S 4S 6C) # A high
      @sh = %w(2S 3S 4S 6C 7D) # 7 high

      @fk_ranks = card_ranks(@fk)
      @tp_ranks = card_ranks(@tp)
    end

    def test_deal_two_hands_of_5_cards
      res = deal(2, 5)
      assert res.size == 2
      assert true == res.all? { |n| n.size == 5 }
    end

    def test_deal_three_hands_of_8_cards
      res = deal(3, 8)
      assert res.size == 3
      assert true == res.all? { |n| n.size == 8 }
    end

    def test_kind1
      assert kind(4, @fk_ranks) == 9
    end

    def test_kind2
      assert kind(3, @fk_ranks) == nil
    end

    def test_kind3
      assert kind(2, @fk_ranks) == nil
    end

    def test_kind1
      assert kind(1, @fk_ranks) == 7
    end

    def test_two_pair1
      assert two_pair(@fk_ranks) == nil
    end

    def test_two_pair2
      assert two_pair(@tp_ranks) == [9, 5]
    end

    def test_straight1
      assert straight([9, 8, 7, 6, 5]) == true
    end

    def test_straight2
      assert straight([9, 8, 8, 6, 5]) == false
    end

    def test_flush1
      assert flush(@sf) == true
    end

    def test_flush2
      assert flush(@fk) == false
    end

    def test_card_ranks1
      assert card_ranks(@sf) == [10, 9, 8, 7, 6]
    end

    def test_card_ranks2
      assert card_ranks(@fk) == [9, 9, 9, 9, 7]
    end

    def test_card_ranks3
      assert card_ranks(@fh) == [10, 10, 10, 7, 7]
    end

    # Test cases for the functions in poker program
    def test_hands
      assert poker([@sf, @fk, @fh]) == [@sf]
    end

    def test_hands2
      assert poker([@fk, @fh]) == [@fk]
    end

    def test_identical_hands
      assert poker([@fh, @fh]) == [@fh, @fh]
    end

    def test_one_player
      assert poker([@sf]) == [@sf]
    end

    def test_hundred_players
      assert poker(Array.new(1, @sf) + Array.new(99, @fh)) == [@sf]
    end

    def test_no_players
      assert_raises(NoHandError) { poker([]) }
    end

    def test_hand_rank1
      assert hand_rank(@sf) == [8, 10]
    end

    def test_hand_rank2
      assert hand_rank(@fk) == [7, 9, 7]
    end

    def test_hand_rank3
      assert hand_rank(@fh) == [6, 10, 7]
    end
  end
