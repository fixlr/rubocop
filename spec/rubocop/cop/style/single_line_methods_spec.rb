# encoding: utf-8

require 'spec_helper'

module Rubocop
  module Cop
    module Style
      describe SingleLineMethods, :config do
        subject(:slm) { SingleLineMethods.new(config) }
        let(:cop_config) { { 'AllowIfMethodIsEmpty' => true } }

        it 'registers an offence for a single-line method' do
          inspect_source(slm,
                         ['def some_method; body end',
                          'def link_to(name, url); {:name => name}; end',
                          'def @table.columns; super; end'])
          expect(slm.messages).to eq(
            [SingleLineMethods::MSG] * 3)
        end

        context 'when AllowIfMethodIsEmpty is disabled' do
          let(:cop_config) { { 'AllowIfMethodIsEmpty' => false } }

          it 'registers an offence for an empty method' do
            inspect_source(slm, ['def no_op; end',
                                 'def self.resource_class=(klass); end',
                                 'def @table.columns; end'])
            expect(slm.offences.size).to eq(3)
          end
        end

        context 'when AllowIfMethodIsEmpty is enabled' do
          let(:cop_config) { { 'AllowIfMethodIsEmpty' => true } }

          it 'accepts a single-line empty method' do
            inspect_source(slm, ['def no_op; end',
                                 'def self.resource_class=(klass); end',
                                 'def @table.columns; end'])
            expect(slm.offences).to be_empty
          end
        end

        it 'accepts a multi-line method' do
          inspect_source(slm, ['def some_method',
                               '  body',
                               'end'])
          expect(slm.offences).to be_empty
        end

        it 'does not crash on an method with a capitalized name' do
          inspect_source(slm, ['def NoSnakeCase',
                               'end'])
          expect(slm.offences).to be_empty
        end
      end
    end
  end
end
