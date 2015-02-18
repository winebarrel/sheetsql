describe Sheetsql::Parser do
  subject {|example| Sheetsql::Parser.parse(example.example_group.description) }
  let(:attrs) { subject.to_h }

  describe Sheetsql::Command::ShowSpreadsheets do
    describe 'SHOW SPREADSHEETS' do
      it { is_expected.to be_a described_class }
      it { expect(attrs).to eq(like: nil) }
    end

    describe 'show spreadsheets' do
      it { is_expected.to be_a described_class }
      it { expect(attrs).to eq(like: nil) }
    end

    describe 'SHOW SPREADSHEETS LIKE "%"' do
      it { is_expected.to be_a described_class }
      it { expect(attrs).to eq(like: '%') }
    end

    describe 'SHOW SPREADSHEETS LIKE "%\\\\\\"\\\\\\""' do
      it { is_expected.to be_a described_class }
      it { expect(attrs).to eq(like: '%\\"\\"') }
    end

    describe "SHOW SPREADSHEETS LIKE '%\\\\\\'\\\\\\''" do
      it { is_expected.to be_a described_class }
      it { expect(attrs).to eq(like: "%\\'\\'") }
    end
  end

  describe Sheetsql::Command::ShowWorksheets do
    describe 'SHOW WORKSHEETS FROM spreadsheet_name' do
      it { is_expected.to be_a described_class }
      it { expect(attrs).to eq(spreadsheet: 'spreadsheet_name') }
    end

    describe 'SHOW WORKSHEETS FROM `スプレッドシート`' do
      it { is_expected.to be_a described_class }
      it { expect(attrs).to eq(spreadsheet: 'スプレッドシート') }
    end

    describe 'SHOW WORKSHEETS FROM `\\\\\\`\\\\\\``' do
      it { is_expected.to be_a described_class }
      it { expect(attrs).to eq(spreadsheet: '\\`\\`') }
    end
  end
end
