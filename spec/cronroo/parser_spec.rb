require "spec_helper"

RSpec.describe CronRoo::Parser do
  describe "validations" do
    let(:valid_inputs) do
      [
        "5 4 * * * * echo $1",
        "15 14 1 * * bin/run example",
        "0 22 * * 1-5 /usr/bin/find 1",
        "*/15 0 1,15 * 1-5 /usr/bin/find",
        "23 0-20/2 * * * foo bar 1"
      ]
    end

    context "a valid string" do
      it "does not add errors" do
        valid_inputs.each do |input|
          parser = CronRoo::Parser.new(input:)
          parser.validate
          expect(parser.errors).to be_empty, "#{input} is valid"
        end
      end
    end

    context "without an input" do
      subject { described_class.new.tap(&:validate) }

      it "adds errors" do
        expect(subject.errors).not_to be_empty
      end
    end

    context "an invalid string" do
      context "validating command length" do
        let(:invalid_inputs) do
          [
            "5 4",
            "0 22 * *",
            "*/15 0 1,15"
          ]
        end

        it "adds errors" do
          invalid_inputs.each do |input|
            parser = CronRoo::Parser.new(input:)
            parser.validate
            expect(parser.errors).not_to be_empty
          end
        end
      end

      context "validating each expression" do
        xit "adds errors" do

        end
      end
    end
  end
end
