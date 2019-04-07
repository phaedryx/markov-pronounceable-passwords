# frozen_string_literal:true

# A naive algorithm for pronounceable passwords using a Markov Chain. This is
# for example purposes only.
class Pronounceable
  def initialize
    @words = File.open('./web2').each_line.each_with_object([]) do |word, array|
      array << word.downcase.strip
    end

    @markov = @words.each_with_object(Hash.new { |h, k| h[k] = [] }) do |word, hash|
      word.scan(/./).each_cons(2) { |pair| hash[pair.first] << pair.last }
    end
  end

  def enumerator(seed = nil)
    Enumerator.new do |y|
      seed ||= @markov.keys.sample

      loop do
        y << seed
        seed = @markov[seed].sample
      end
    end
  end

  def word(length = 8)
    @enumerator ||= enumerator

    Array.new(length) { @enumerator.next }.join
  end
end
