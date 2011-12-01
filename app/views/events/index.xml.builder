xml.events do
  xml.categories('Thursday, Friday, Saturday, Sunday')
  @events.each do |event_obj|
    xml.event(:id => event_obj.id) do
      xml.name(event_obj.name)
      xml.description(event_obj.description)

      xml.starttime(event_obj.event_start)
      xml.endtime(event_obj.event_end)

      xml.location(event_obj.location)
      xml.image(event_obj.flyer)
      xml.categories(event_obj.categories)
    end
  end
end
