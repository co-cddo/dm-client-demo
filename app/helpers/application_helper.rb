module ApplicationHelper
  def valid_record_tag(record)
    text, colour = if record.json_valid?
                     %w[Valid green]
                   else
                     %w[Invalid red]
                   end
    content_tag :strong, text, class: "govuk-tag govuk-tag--#{colour}"
  end
end
