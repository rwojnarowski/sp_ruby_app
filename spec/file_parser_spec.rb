# frozen_string_literal: true

require './lib/file_parser'

describe FileParser do
  describe '.call' do
    subject { described_class.call(file) }

    context 'when file is valid' do
      let(:file) { ['spec/fixtures/webserver.log'] }
      let(:expected_output) {
        <<~HTML
          ==== Most viewed urls: ====
          "Url: /about               Visits: 19"
          "Url: /home                Visits: 19"
          "Url: /help_page/1         Visits: 18"
          "Url: /about/2             Visits: 17"
          "Url: /contact             Visits: 16"
          "Url: /index               Visits: 11"

          ==== Most unique visits ====
          "Url: /home                Unique visits: 14"
          "Url: /about               Unique visits: 13"
          "Url: /about/2             Unique visits: 12"
          "Url: /help_page/1         Unique visits: 12"
          "Url: /index               Unique visits: 10"
          "Url: /contact             Unique visits: 10"
        HTML
      }

      it 'returns most viewed and most unique urls' do
        expect { subject }.to output(expected_output).to_stdout
      end
    end

    context 'when file is invalid' do
      context 'when file is missing' do
        let(:file) { '' }

        it 'returns missing file notice' do
          expect { subject }.to output("File is missing!\n").to_stdout
        end
      end

      context 'when file is not found' do
        let(:file) { 'webserver1.log' }

        it 'returns invalid file notice' do
          expect { subject }.to output("File not found!\n").to_stdout
        end
      end
    end
  end
end
