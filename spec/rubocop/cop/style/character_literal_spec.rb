# encoding: utf-8

require 'spec_helper'

module Rubocop
  module Cop
    module Style
      describe CharacterLiteral do
        subject(:cop) { CharacterLiteral.new }

        it 'registers an offence for character literals' do
          inspect_source(cop, ['x = ?x'])
          expect(cop.offences.size).to eq(1)
        end

        it 'registers an offence for literals like \n' do
          inspect_source(cop, ['x = ?\n'])
          expect(cop.offences.size).to eq(1)
        end

        it 'accepts literals like ?\C-\M-d' do
          inspect_source(cop, ['x = ?\C-\M-d'])
          expect(cop.offences).to be_empty
        end

        it 'accepts ? in a %w literal' do
          inspect_source(cop, ['%w{? A}'])
          expect(cop.offences).to be_empty
        end

        it "auto-corrects ?x to 'x'" do
          new_source = autocorrect_source(cop, 'x = ?x')
          expect(new_source).to eq("x = 'x'")
        end

        it 'auto-corrects ?\n to "\\n"' do
          new_source = autocorrect_source(cop, 'x = ?\n')
          expect(new_source).to eq('x = "\\n"')
        end
      end
    end
  end
end
