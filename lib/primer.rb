class Primer
  attr_reader :name, :sequence, :note

  def initialize(name:, sequence:, note: "")
    @name = name
    @note = note
    # TODO: extract sequence normalizer
    @sequence = sequence.downcase
  end

  def overlap(position:, container:)
    start_pos = bindable_region(container, position).index(sequence)
    if start_pos
      binding_site = Position.new(
        start_pos: start_pos,
        end_pos: start_pos + size
      )
      target_within_bindable_region = Position.new(
        start_pos: size - 1,
        end_pos: size - 1 + position.size
      )
      binding_site.overlap_with(target_within_bindable_region)
    else
      0
    end
  end

  def bindable_region(contained_in, position)
    contained_in[position.start_pos - size + 1...position.end_pos + size - 1]
  end

  def reverse_complement
    Primer.new(
      name: name + "--reverse",
      sequence: sequence_reverse_compliment,
    )
  end

  private

  def size
    @_size ||= sequence.size
  end

  REVERSE_COMPLIMENT_BASES = {
    "a" => "t",
    "c" => "g",
    "t" => "a",
    "g" => "c",
  }

  def sequence_reverse_compliment
    sequence.
      reverse.
      each_char.
      map { |char| REVERSE_COMPLIMENT_BASES[char] }.
      join
  end
end
