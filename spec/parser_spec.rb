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
      it { expect(attrs).to eq(title: 'spreadsheet_name', like: nil) }
    end

    describe 'SHOW WORKSHEETS FROM spreadsheet_name like "%"' do
      it { is_expected.to be_a described_class }
      it { expect(attrs).to eq(title: 'spreadsheet_name', like: '%') }
    end

    describe 'SHOW WORKSHEETS FROM `スプレッドシート`' do
      it { is_expected.to be_a described_class }
      it { expect(attrs).to eq(title: 'スプレッドシート', like: nil) }
    end

    describe 'SHOW WORKSHEETS FROM `\\\\\\`\\\\\\``' do
      it { is_expected.to be_a described_class }
      it { expect(attrs).to eq(title: '\\`\\`', like: nil) }
    end
  end
end
