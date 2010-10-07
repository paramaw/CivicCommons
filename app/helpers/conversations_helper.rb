module ConversationsHelper
  def format_rating(contribution)
    return "" unless contribution.total_rating
    out = contribution.total_rating > 0 ? "+" : ""
    out += contribution.total_rating.to_s
  end
  
  def format_user_rating(value)
    return case value
    when 1
      "You found this productive"
    else
      "You found this unproductive"
    end
  end

  def format_time(t)
     return "no particular time" if t.nil?
     return t.localtime.strftime("%c")
  end
  
  def format_time_only(t)
    return t.localtime.strftime("%l:%M %p") unless t.nil?
  end
  
  def contribution_action_past_tense(contribution_type)
    case contribution_type
    when "Answer"
      "answered:"
    when "AttachedFile"
      "shared a file:"
    when "Comment"
      "commented:"
    when "EmbeddedSnippet"
      "shared a video:"
    when "Link"
      "shared a link:"
    when "PAContribution"
      "wrote a contribution:"
    when "Question"
      "asked a question:"
    when "SuggestedAction"
      "suggested an action:"
    else
      "commented:"
    end
  end
  
  # This method allows you to get the subset of direct descendents of this_contribution_id from the complete thread of root_contribution_and_descendents
  #  root_contribution in this case is a TopLevelContribution node, and the whole thing has already been loaded by the controller,
  #  so we don't want to poll the database for each subset when we've already loaded the entire set once.
  def display_direct_descendant_subset(top_level_descendants, this_contribution_id)
    out = ""
    return out unless top_level_descendants
    top_level_descendants.select{ |c| c.parent_id == this_contribution_id }.sort_by{ |c| c.created_at }.each do |contribution|
      out += render(:partial => "conversations/contributions/threaded_contribution_template", :locals => { :contribution => contribution })
    end
    raw(out)
  end
end
