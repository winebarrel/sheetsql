describe Sheetsql::Parser do
  subject {|example| described_class.parse(example.example_group.description) }
  let(:attrs) { subject.to_h }

  describe 'SHOW SPREADSHEETS' do
    it { is_expected.to be_a Sheetsql::Command::ShowSpreadsheets }
    it { expect(attrs).to eq(like: nil) }
  end

  describe 'show spreadsheets' do
    it { is_expected.to be_a Sheetsql::Command::ShowSpreadsheets }
    it { expect(attrs).to eq(like: nil) }
  end

  describe 'SHOW SPREADSHEETS LIKE "%"' do
    it { is_expected.to be_a Sheetsql::Command::ShowSpreadsheets }
    it { expect(attrs).to eq(like: '%') }
  end

  describe 'SHOW SPREADSHEETS LIKE "%\\\\\\"\\\\\\""' do
    it { is_expected.to be_a Sheetsql::Command::ShowSpreadsheets }
    it { expect(attrs).to eq(like: '%\\"\\"') }
  end

  describe "SHOW SPREADSHEETS LIKE '%\\\\\\'\\\\\\''" do
    it { is_expected.to be_a Sheetsql::Command::ShowSpreadsheets }
    it { expect(attrs).to eq(like: "%\\'\\'") }
  end
end
