require 'spec_helper'

describe Issue do
  describe "when adding an issue to a conversation" do
    context "and the conversation id is not correct" do
      it "should return an issue with an error" do
        issue = Issue.create({:description=>"Testing"})
        Conversation.stub(:find).with(999).and_return(nil)
        issue = Issue.add_to_conversation(issue, 999)
        issue.errors[:conversation_id].nil?.should == false
        issue.errors[:conversation_id].blank?.should == false  
      end
    end
    context "and the issue saves successfully" do
      it "should add the issue to a conversation" do
        issue = Issue.create({:description=>"Testing"})
        conversation = Factory.create(:conversation)
        Conversation.stub(:find).with(1).and_return(conversation)
        issue = Issue.add_to_conversation(issue, 1)
        conversation.posts.count.should == 1
        conversation.posts[0].postable.should == issue
      end
      it "should return an issue with no errors" do
        issue = Issue.create({:description=>"Testing"})
        conversation = Factory.create(:conversation)
        Conversation.stub(:find).with(1).and_return(conversation)
        issue = Issue.add_to_conversation(issue, 1)
        issue.errors.count.should == 0
      end      
    end
  end  
end
