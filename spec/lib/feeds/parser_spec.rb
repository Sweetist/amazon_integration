require 'spec_helper'

module Feeds
  describe Parser do

    describe '#parse_submission' do
      context 'successful response' do
        it 'should return the feed id' do
          id = Parser.parse_submission(Responses.successful_submission)
          id.should eq "8253017998"
        end
      end

      context '#unsuccessful response' do
        it 'should raise an error' do
          expect { Parser.parse_submission(Responses.submission_error) }.to raise_error(SubmissionError)
        end
      end
    end

    describe '#parse_result' do
      context 'error processing feed' do
        it 'should return notification error' do
          message = Parser.parse_result(Responses.status_error)
          expected = {:notifications=> [
                       { :level=>"error",
                         :subject=>"Feed Error",
                        :description=> "Feed #8252984128 Not Processed. The quantities you provided for order id (103-6652650-4045858) were larger than the quantities that could be fulfilled. Please review the quantity from the order report and take into account any items that have been cancelled or already fulfilled.\n        "}]}

          message.should eq expected
        end
      end

      context 'successfully processed' do
        it 'should return notification info' do
          message = Parser.parse_result(Responses.successful_result)
          expected = {:notifications=>
                        [{:level=>"info",
                          :subject=>"Feed Complete",
                          :description=>"Succesfully processed feed # 8253017998"}]}
          message.should eq expected
        end
      end
    end
  end
end

