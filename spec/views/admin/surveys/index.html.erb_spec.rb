require 'spec_helper'

describe "admin/surveys/index.html.erb" do
  before(:each) do
    issue = stub_model(Issue,:id => 123)
    assign(:surveys, [
      stub_model(Survey,
        :surveyable_id => 1,
        :surveyable_type => "Surveyable Type",
        :title => "Title",
        :description => "MyText",
        :surveyable => issue,
        :type => 'Vote'
      ),
      stub_model(Survey,
        :surveyable_id => 1,
        :surveyable_type => "Surveyable Type",
        :title => "Title",
        :description => "MyText",
        :surveyable => issue,
        :type => 'Vote'
      )
    ])
  end

  it "renders a list of admin_surveys" do
    render
    rendered.should have_selector( "tr>td", :content => "Title".to_s, :count => 2 )
  end
end
